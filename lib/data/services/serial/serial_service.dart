import 'dart:async';
import 'dart:typed_data';

import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/services/serial/serial_connector_refactor.dart';
import 'package:arari_next/data/services/serial/serial_service_interface.dart';
import 'package:libserialport/libserialport.dart';

class SerialService implements ISerialService {
  SerialService({required SerialConnector serial, required SettingsManager settings}) :  _serial = serial, _settings = settings {
    _settings.onSerialPortChanged.listen((data)
    {
      try{
       _serial.selectPortByName(data);
      } catch(e){
        _errorController.add(e);
      }
    });

    _settings.onBaudrateChanged.listen((data) 
    {
      try{
       _serial.setBaudRate(data);
      } catch(e){
        _errorController.add(e);
      }
    });
  }

  final SerialConnector _serial;
  final SettingsManager _settings;

  final StreamController<Uint8List> _serialStreamController = StreamController.broadcast();

  Stream<Uint8List> get _outputStream => _serialStreamController.stream;

  final StreamController<dynamic> _errorController = StreamController.broadcast();
  Stream<dynamic> get error => _errorController.stream;

  void open(){
    _serial.selectPortByName(_settings.selectedSerialPort);
    if(!_serial.open()) throw AssertionError(SerialPort.lastError!.message);
    _serial.setBaudRate(_settings.selectedBaudrate);
    _serialStreamController.addStream(_serial.read());
  }

  void close(){
    _serial.close();
  }

  bool isPortOpen(){
    return _serial.isOpen();
  }
  
  @override
  Stream<Uint8List> read() {
    print('chegou');
    return _outputStream;
  }
}