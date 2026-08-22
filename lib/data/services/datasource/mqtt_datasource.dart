import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/domain/settings/mqtt_settings.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttDatasource implements IDataSource {
  final MqttServerClient _client;
  String _topic;

  StreamSubscription? _updatesSubscription;

  final StreamController<Uint8List> _outputStreamController =
      StreamController.broadcast();
  @override
  Stream<Uint8List> get stream => _outputStreamController.stream;

  final StreamController<ConnectionEvent> _connectionStateStreamController =
      StreamController.broadcast();
  @override
  Stream<ConnectionEvent> get statusStream =>
      _connectionStateStreamController.stream;

  MqttDatasource({
    String serverAddress = "localhost",
    String defaultTopic = "mavlink",
  }) : _client = MqttServerClient(serverAddress, ""),
       _topic = defaultTopic {
    _client.connectTimeoutPeriod = 2000;
    _client.autoReconnect = true;
    _client.setProtocolV311();
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onAutoReconnect = _onAutoReconnect;
  }

  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  @override
  ConnectionStatus get status => _currentStatus;

  void _updateStatus(ConnectionStatus status) {
    _currentStatus = status;
    if (!_connectionStateStreamController.isClosed) {
      _connectionStateStreamController.add(
        ConnectionEvent(ConnectionType.mqtt, status),
      );
    }
  }

  void setTopic(String topic) {
    if (status == ConnectionStatus.connected) {
      _client.unsubscribe(_topic);
      _topic = topic;
      _client.subscribe(topic, MqttQos.atMostOnce);
    } else {
      _topic = topic;
    }
  }

  Future<void> setConfig(MqttSettings config) async {
    disconnect();
    _client.port = config.port;
    _client.server = config.address;
    await connect();
  }

  @override
  Future<void> connect() async {
    _updateStatus(ConnectionStatus.connecting);

    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      disconnect();
      throw Exception("Sem conexão: $e");
    } on SocketException catch (e) {
      disconnect();
      throw Exception("Erro de socket: $e");
    }

    if (_client.connectionStatus!.state != MqttConnectionState.connected) {
      disconnect();
      throw Exception("Falha na conexão: ${_client.connectionStatus!.state}");
    }

    _client.subscribe(_topic, MqttQos.atMostOnce);

    await _updatesSubscription?.cancel();

    _updatesSubscription = _client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        if (c != null && c.isNotEmpty) {
          final recMess = c[0].payload as MqttPublishMessage;
          final pt = recMess.payload.message;
          _outputStreamController.add(pt.buffer.asUint8List());
        }
      },
    ); //onError: (rtt) => print("ENTROU AQUIII"), onDone: () => print("FINALIZOU"));
  }

  @override
  Future<void> disconnect() async {
    _client.disconnect();
  }

  void _onAutoReconnect() {
    _updateStatus(ConnectionStatus.reconnecting);
  }

  void _onSubscribed(String topic) {}

  void _onDisconnected() {
    _updatesSubscription?.cancel();

    if (_client.connectionStatus!.disconnectionOrigin !=
        MqttDisconnectionOrigin.solicited) {
      _updateStatus(ConnectionStatus.error);
    } else {
      _updateStatus(ConnectionStatus.disconnected);
    }
  }

  void _onConnected() {
    _updateStatus(ConnectionStatus.connected);
  }

  @override
  Future<void> dispose() async {
    disconnect();
    await _outputStreamController.close();
    await _connectionStateStreamController.close();
  }
}
