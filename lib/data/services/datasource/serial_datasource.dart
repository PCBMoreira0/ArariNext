import 'dart:async';
import 'dart:typed_data';
import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialDatasource implements IDataSource {
  SerialSettings _config = SerialSettings(port: "", baudrate: 115200);
  SerialPort? _serialPort;
  SerialPortReader? _reader;
  StreamSubscription<Uint8List>? _subscription;
  bool _isReconnecting = false;
  Timer? _reconnectTimer;

  final StreamController<Uint8List> _outputStreamController =
      StreamController.broadcast();

  static List<String> availablePorts() => SerialPort.availablePorts;

  @override
  Stream<Uint8List> get stream => _outputStreamController.stream;

  final StreamController<ConnectionEvent> _statusController =
      StreamController<ConnectionEvent>.broadcast();

  @override
  Stream<ConnectionEvent> get statusStream => _statusController.stream;

  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  @override
  ConnectionStatus get status => _currentStatus;

  void _updateStatus(ConnectionStatus status) {
    _currentStatus = status;
    if (!_statusController.isClosed) {
      _statusController.add(ConnectionEvent(ConnectionType.serial, status));
    }
  }

  void setConfig(SerialSettings config) {
    if (status == ConnectionStatus.connected) {
      disconnect();
      _config = config;
      connect();
    } else {
      _config = config;
    }
  }

  @override
  void connect() {
    if (_serialPort != null && _serialPort!.isOpen) return;

    if (!_isReconnecting) {
      _updateStatus(ConnectionStatus.connecting);
    }

    try {
      final port = SerialPort(_config.port);

      if (!port.openReadWrite()) {
        port.dispose();
        throw Exception("Não foi possível abrir a porta ${_config.port}");
      }

      final config = port.config;
      config.baudRate = _config.baudrate;
      port.config = config;

      final reader = SerialPortReader(port);

      _subscription?.cancel();
      _subscription = reader.stream.listen(
        (data) => _outputStreamController.add(data),
        onError: (error) {
          _updateStatus(ConnectionStatus.error);
          _reconnect();
        },
      );

      _serialPort = port;
      _reader = reader;

      _updateStatus(ConnectionStatus.connected);
    } catch (e) {
      if (!_isReconnecting) {
        _updateStatus(ConnectionStatus.error);
      }

      rethrow;
    }
  }

  @override
  void disconnect() {
    _onDisconnect();
    _updateStatus(ConnectionStatus.disconnected);
  }

  void _onDisconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _subscription?.cancel();
    _subscription = null;

    _reader?.close();
    _reader = null;

    if (_serialPort != null && _serialPort!.isOpen) {
      _serialPort!.close();
    }
    _serialPort?.dispose();
    _serialPort = null;
  }

  void _reconnect() async {
    _onDisconnect();
    _updateStatus(ConnectionStatus.reconnecting);
    _isReconnecting = true;

    _reconnectTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        connect();
        if (_serialPort != null && _serialPort!.isOpen) {
          timer.cancel();
          _reconnectTimer = null;
          _isReconnecting = false;
        }
      } catch (e, _) {}
    });
  }

  @override
  void dispose() {
    disconnect();
    _outputStreamController.close();
    _statusController.close();
  }
}
