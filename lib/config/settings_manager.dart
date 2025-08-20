import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsKeys {
  static const String selectedSerialPort = "serialPort";
  static const String selectedBaudrate = "baudrate";
}

class SettingsManager {
  final SharedPreferences _prefs;

  SettingsManager._({required prefs}) : _prefs = prefs;
  
  final StreamController<String> _serialPortStreamController = StreamController(); 
  Stream<String> get onSerialPortChanged => _serialPortStreamController.stream.asBroadcastStream();

  final StreamController<int> _baudrateStreamController = StreamController(); 
  Stream<int> get onBaudrateChanged => _baudrateStreamController.stream.asBroadcastStream();

  static Future<SettingsManager> create() async {
    return SettingsManager._(prefs: await SharedPreferences.getInstance());
  }

  String get selectedSerialPort {
    return _prefs.getString(SettingsKeys.selectedSerialPort) ?? "";
  }

  Future<void> setSerialPort(String port) async {
    await _prefs.setString(SettingsKeys.selectedSerialPort, port);
    _serialPortStreamController.add(port);
  }

  int get selectedBaudrate {
    return _prefs.getInt(SettingsKeys.selectedBaudrate) ?? 9600;
  }

  Future<void> setBaudrate(int baudrate) async {
    await _prefs.setInt(SettingsKeys.selectedBaudrate, baudrate);
    _baudrateStreamController.add(baudrate);
  }
}