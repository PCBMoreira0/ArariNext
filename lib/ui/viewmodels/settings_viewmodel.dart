import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/services/logging_service_influx.dart';
import 'package:arari_next/data/services/serial/model/serial_port_data.dart';
import 'package:arari_next/data/services/serial/serial_connector.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:flutter/material.dart';

class SettingsViewmodel extends ChangeNotifier {
  List<SerialPortData> _serialPorts = [];
  final List<int> _baudrates = [9600, 115200]; 
  SerialPortData? _selectedSerialPort;
  int _selectedBaudrate = 9600;
  bool get isSerialOpen => _serial.isPortOpen(); 
  String _loggingPath = "";
  bool get isLogOpen => _log.isOpen;

  List<SerialPortData> get serialPorts => _serialPorts;
  List<int> get baudRates => _baudrates; 
  String get loggingPath => _loggingPath;

  SerialPortData? get selectedSerialPort => _selectedSerialPort;
  int get selectedBaudrate => _selectedBaudrate;
  final SettingsManager _settings;
  final SerialService _serial;
  final LoggingServiceInflux _log;

  SettingsViewmodel({required SerialService serial, required SettingsManager settings, required LoggingServiceInflux log}) :  _serial = serial, _settings = settings, _log = log;
  
  void downloadSettings() async {
    _serialPorts = SerialConnector.readPorts();

    String selectedSerial = _settings.selectedSerialPort;
    for(var serial in _serialPorts){
      if(serial.name == selectedSerial){
        _selectedSerialPort = serial;
        break;
      }
    }
    _selectedSerialPort ??= null;

    _selectedBaudrate = _settings.selectedBaudrate;

    _loggingPath = _settings.getLogDirectory() ?? "";
    
    notifyListeners();
  }

  void toggleSerialPort(){
    if(_serial.isPortOpen()){
      _serial.close();
    }
    else{
      _serial.open();
    }
    
    notifyListeners();
  }

  Future<void> setSerialPort(SerialPortData port) async {
    await _settings.setSerialPort(port.name);
    _selectedSerialPort = port;
    notifyListeners();
  }

  Future<void> setBaudrate(int baudrate) async{
    await _settings.setBaudrate(baudrate);
    _selectedBaudrate = baudrate;
    notifyListeners();
  }

  Future<void> setLogDirectory(String dir) async{
    await _settings.setLoggingDirectory(dir);
    _loggingPath = dir;
    notifyListeners();
  }

  void toggleLogging() async {
    try{
       if(_log.isOpen){
       await _log.close();  
    }
    else{
      await _log.openFile(_loggingPath, "ararilog");
    }
    }catch(e){
      print(e.toString());
    }

    notifyListeners();
  }
}