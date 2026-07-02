import 'package:arari_next/managers/settings_manager.dart';
import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/data/services/logging/logging_service_influx.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';
import 'package:arari_next/data/services/datasource/serial_datasource.dart';
import 'package:flutter/material.dart';

class SettingsViewmodel extends ChangeNotifier {
  List<String> _serialPorts = [];
  final List<int> _baudrates = [9600, 115200];
  String? _selectedSerialPort;
  int _selectedBaudrate = 9600;
  bool get isSerialConnected => _serial.status == ConnectionStatus.connected;
  String _loggingPath = "";
  bool get isLogOpen => _log.isOpen;

  List<String> get serialPorts => _serialPorts;
  List<int> get baudRates => _baudrates;
  String get loggingPath => _loggingPath;

  String? get selectedSerialPort => _selectedSerialPort;
  int get selectedBaudrate => _selectedBaudrate;
  final SettingsManager _settings;
  final SerialDatasource _serial;
  final LoggingServiceInflux _log;

  SettingsViewmodel({
    required SerialDatasource serial,
    required SettingsManager settings,
    required LoggingServiceInflux log,
  }) : _serial = serial,
       _settings = settings,
       _log = log;

  void downloadSettings() async {
    _serialPorts = SerialDatasource.availablePorts();

    String selectedSerial = _settings.serial.port;
    for (var serial in _serialPorts) {
      if (serial == selectedSerial) {
        _selectedSerialPort = serial;
        break;
      }
    }
    _selectedSerialPort ??= null;

    _selectedBaudrate = _settings.serial.baudrate;

    _loggingPath = _settings.log.directory;

    notifyListeners();
  }

  void toggleSerialPort() {
    if (_serial.status == ConnectionStatus.connected) {
      _serial.disconnect();
    } else {
      _serial.connect();
    }

    notifyListeners();
  }

  Future<void> setSerialPort(String port) async {
    await _settings.setSerial(_settings.serial.copyWith(port: port));
    _serial.setConfig(SerialSettings(port: port, baudrate: _selectedBaudrate));
    _selectedSerialPort = port;
    notifyListeners();
  }

  Future<void> setBaudrate(int baudrate) async {
    await _settings.setSerial(_settings.serial.copyWith(baudrate: baudrate));
    _serial.setConfig(
      SerialSettings(port: _selectedSerialPort ?? "", baudrate: baudrate),
    );
    _selectedBaudrate = baudrate;
    notifyListeners();
  }

  Future<void> setLogDirectory(String dir) async {
    await _settings.setLog(_settings.log.copyWith(directory: dir));
    _loggingPath = dir;
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
      print(e.toString());
    }

    notifyListeners();
  }
}
