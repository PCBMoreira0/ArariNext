import 'package:arari_next/config/settings_manager.dart';
import 'package:flutter/material.dart';

class SettingsViewmodel extends ChangeNotifier {
  List<String> _serialPorts = [];
  final List<int> _baudrates = [9600, 11500]; 
  String _selectedSerialPort = "";
  int _selectedBaudrate = 9600;

  List<String> get serialPorts => _serialPorts;
  List<int> get baudRates => _baudrates; 

  String get selectedSerialPort => _selectedSerialPort;
  int get selectedBaudrate => _selectedBaudrate;
  final SettingsManager _settings;

  SettingsViewmodel({required SettingsManager settings}) : _settings = settings;

  void downloadSettings() async {
    _serialPorts = ["COM1", "COM2", "COM3"];

    String selectedSerial = _settings.selectedSerialPort;
    if(!_serialPorts.contains(selectedSerial)){
      _selectedSerialPort = _serialPorts[0];
    }
    else{
      _selectedSerialPort = selectedSerial;
    }

    _selectedBaudrate = _settings.selectedBaudrate;
    
    notifyListeners();
  }

  Future<void> setSerialPort(String portName) async {
    await _settings.setSerialPort(portName);
    _selectedSerialPort = portName;
    notifyListeners();
  }

  Future<void> setBaudrate(int baudrate) async{
    await _settings.setBaudrate(baudrate);
    _selectedBaudrate = baudrate;
    notifyListeners();
  }
}