import 'dart:io';

import 'package:arari_next/managers/connection_manager.dart';
import 'package:arari_next/managers/settings_manager.dart';
import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/data/services/logging/logging_service_influx.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';
import 'package:arari_next/data/services/datasource/serial_datasource.dart';
import 'package:flutter/material.dart';

class SettingsViewmodel extends ChangeNotifier {
  List<String> _serialPorts = [];
  List<String> get serialPorts => _serialPorts;
  final List<int> _baudrates = [9600, 115200];
  List<int> get baudRates => _baudrates;

  String _selectedSerialPort = "";
  String? get selectedSerialPort => _selectedSerialPort;
  int _selectedBaudrate = 9600;
  int get selectedBaudrate => _selectedBaudrate;
  bool get isSerialConnected =>
      _connectionManager.serialStatus == ConnectionStatus.connected;

  String _loggingPath = "";
  bool get isLogOpen => _log.isOpen;
  String get loggingPath => _loggingPath;

  final SettingsManager _settings;
  final ConnectionManager _connectionManager;
  final LoggingServiceInflux _log;

  SettingsViewmodel({
    required ConnectionManager connectionManager,
    required SettingsManager settings,
    required LoggingServiceInflux log,
  }) : _connectionManager = connectionManager,
       _settings = settings,
       _log = log {
    if (!Platform.isAndroid && !Platform.isIOS) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    _serialPorts = SerialDatasource.availablePorts();

    _selectedSerialPort = _settings.serial.port;
    _selectedBaudrate = _settings.serial.baudrate;
    _loggingPath = _settings.log.directory;

    await _connectionManager.setSerialConfig(
      SerialSettings(port: _selectedSerialPort, baudrate: _selectedBaudrate),
    );

    notifyListeners();
  }

  Future<void> toggleSerialPort() async {
    if (_connectionManager.serialStatus == ConnectionStatus.connected) {
      await _connectionManager.disconnect(ConnectionType.serial);
    } else {
      await _connectionManager.connect(ConnectionType.serial);
    }

    notifyListeners();
  }

  Future<void> setSerialPort(String port) async {
    _selectedSerialPort = port;
    await _connectionManager.setSerialConfig(
      SerialSettings(port: port, baudrate: _selectedBaudrate),
    );
    notifyListeners();
    await _settings.setSerial(_settings.serial.copyWith(port: port));
  }

  Future<void> setBaudrate(int baudrate) async {
    _selectedBaudrate = baudrate;
    final settings = _settings.serial.copyWith(baudrate: baudrate);
    await _connectionManager.setSerialConfig(settings);
    notifyListeners();
    await _settings.setSerial(settings);
  }

  Future<void> setLogDirectory(String dir) async {
    _loggingPath = dir;
    await _settings.setLog(_settings.log.copyWith(directory: dir));
    notifyListeners();
  }

  void toggleLogging() async {
    try {
      if (_log.isOpen) {
        await _log.close();
      } else {
        await _log.openFile(_loggingPath, "ararilog");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }
}
