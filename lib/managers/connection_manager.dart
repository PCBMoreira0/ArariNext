import 'dart:async';

import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/domain/settings/mqtt_settings.dart';
import 'package:arari_next/data/services/datasource/mqtt_datasource.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';
import 'package:arari_next/data/services/datasource/serial_datasource.dart';
import 'package:async/async.dart';

class ConnectionManager {
  final SerialDatasource _serial;
  final MqttDatasource _mqtt;

  ConnectionStatus get serialStatus => _serial.status;
  ConnectionStatus get mqttStatus => _mqtt.status;

  late final Stream<ConnectionEvent> _connectionStreamGroup;
  Stream<ConnectionEvent> get connectionStream => _connectionStreamGroup;

  ConnectionManager({
    required SerialDatasource serial,
    required MqttDatasource mqtt,
  }) : _serial = serial,
       _mqtt = mqtt {
    _connectionStreamGroup = StreamGroup.mergeBroadcast([
      _serial.statusStream,
      _mqtt.statusStream,
    ]);
  }

  Future<void> setSerialConfig(SerialSettings config) async {
    await _serial.setConfig(config);
  }

  Future<void> setMqttConfig(MqttSettings config) async {
    await _mqtt.setConfig(config);
  }

  Future<void> connect(ConnectionType connection) async {
    try {
      if (connection == ConnectionType.mqtt) {
        await _mqtt.connect();
      } else if (connection == ConnectionType.serial) {
        await _serial.connect();
      }
    } on Exception catch (err, _) {
      print("Houve uma exceção: $err");
    }
  }

  Future<void> disconnect(ConnectionType connection) async {
    if (connection == ConnectionType.mqtt) {
      await _mqtt.disconnect();
    } else if (connection == ConnectionType.serial) {
      await _serial.disconnect();
    }
  }

  Future<void> dispose() async {
    await _mqtt.dispose();
    await _serial.dispose();
  }
}
