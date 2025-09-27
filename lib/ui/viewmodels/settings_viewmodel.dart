import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/services/serial/model/serial_port_data.dart';
import 'package:arari_next/data/services/serial/serial_connector_refactor.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:flutter/material.dart';

class SettingsViewmodel extends ChangeNotifier {
  List<SerialPortData> _serialPorts = [];
  final List<int> _baudrates = [9600, 115200]; 
  SerialPortData? _selectedSerialPort;
  int _selectedBaudrate = 9600;
  bool get isSerialOpen => _serial.isPortOpen(); 

  List<SerialPortData> get serialPorts => _serialPorts;
  List<int> get baudRates => _baudrates; 

  SerialPortData? get selectedSerialPort => _selectedSerialPort;
  int get selectedBaudrate => _selectedBaudrate;
  final SettingsManager _settings;
  final SerialService _serial;

  SettingsViewmodel({required SerialService serial, required SettingsManager settings}) :  _serial = serial, _settings = settings;
  
  void downloadSettings() async {
    _serialPorts = SerialConnector.readPorts();

    String selectedSerial = _settings.selectedSerialPort;
    for(var serial in _serialPorts){
      if(serial.name == selectedSerial){
        _selectedSerialPort = serial;
        break;
      }
    }
    _selectedSerialPort ??= _serialPorts[0];

    _selectedBaudrate = _settings.selectedBaudrate;
    
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
}