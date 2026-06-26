import 'dart:async';

import 'package:arari_next/data/services/connection_event.dart';
import 'package:arari_next/data/services/mqtt/mqtt_config.dart';
import 'package:arari_next/data/services/mqtt/mqtt_datasource.dart';
import 'package:arari_next/data/services/serial/serial_config.dart';
import 'package:arari_next/data/services/serial/serial_datasource.dart';
import 'package:async/async.dart';

class ConnectionManager {
  ConnectionManager({
    required SerialDatasource serial,
    required MqttDatasource mqtt,
  }) : _serial = serial,
       _mqtt = mqtt {
        _connectionStreamGroup = StreamGroup.mergeBroadcast([_serial.statusStream, _mqtt.statusStream]);
       }

  final SerialDatasource _serial;
  final MqttDatasource _mqtt;

  late final Stream<ConnectionEvent> _connectionStreamGroup;
  Stream<ConnectionEvent> get connectionStream => _connectionStreamGroup;

  void setSerialConfig(SerialConfig config) {
    _serial.setConfig(config);
  }

  Future<void> setMqttConfig(MQTTConfig config) async {
    await _mqtt.setConfig(config);
  }

  Future<void> connect(ConnectionType connection) async {
    try {
      if (connection == ConnectionType.mqtt) {
        _mqtt.connect();
      } else if (connection == ConnectionType.serial) {
        _serial.connect();
      }
    } on Exception catch (err, _) {
      print("Houve uma exceção: $err");
    }
  }

  Future<void> disconnect(ConnectionType connection) async {
    if (connection == ConnectionType.mqtt) {
      _mqtt.disconnect();
    } else if (connection == ConnectionType.serial) {
      _serial.disconnect();
    }
  }

  void dispose(){
    _mqtt.dispose();
    _serial.dispose();
  }
}
