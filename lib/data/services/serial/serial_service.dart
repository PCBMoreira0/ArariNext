import 'dart:async';
import 'dart:typed_data';

import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/services/serial/serial_connector.dart';
import 'package:arari_next/data/services/serial/serial_service_interface.dart';
import 'package:libserialport/libserialport.dart';

/// Classe voltada para o uso de uma porta serial de forma que vários usuários possam ler da mesma porta (que é global, no escopo atual desta aplicação)
class SerialService implements ISerialService {
  /// Construtor:
  /// 
  /// [serial] Conexão com a comunicação serial
  /// 
  /// [settings] Configuração, usada para alterar os parâmetros da porta de acordo com o que foi configurado no [SettingsManager]
  /// 
  /// 
  /// Nota:
  ///   O construtor escuta a stream de alteração de configuração da porta e do baudrate, definidas no [SettingsManager] 
  SerialService({required SerialConnector serial, required SettingsManager settings}) :  _serial = serial, _settings = settings {

    // Escuta evento de mudança de porta no SettingsManager
    _settings.onSerialPortChanged.listen((data)
    {
      try{
       _serial.selectPortByName(data);
      } catch(e){
        handleError(e);
      }
    }, onError: (error) => handleError(error));

    // Escuta evento de mudança de baudrate no SettingsManager
    _settings.onBaudrateChanged.listen((data) 
    {
      try{
       _serial.setBaudRate(data);
      } catch(e){
        handleError(e);
      }
    }, onError: (error) => handleError(error));
  }

  final SerialConnector _serial;
  final SettingsManager _settings;

  /// Controlador responsável por redirecionar o que chega na porta serial para todos os ouvintes
  final StreamController<Uint8List> _serialStreamController = StreamController.broadcast();

  Stream<Uint8List> get _outputStream => _serialStreamController.stream;

  /// Controlador responsável por transmitir erros 
  final StreamController<dynamic> _errorController = StreamController.broadcast();
  Stream<dynamic> get error => _errorController.stream;

  /// Lida com os erros durante o uso do [SerialService]
  /// 
  /// Recebe um [error] como parâmetro
  void handleError(dynamic error){
    _errorController.add(error);
  }

  /// Abre a porta serial usando as configurações definidas no [SettingsManager]
  /// 
  /// Nota: Você precisa garantir que a porta definida nas configurações exista, se não um [AssertionError] será lançado
  void open(){
    // Abre a porta
    _serial.selectPortByName(_settings.selectedSerialPort);
    if(!_serial.open()) throw AssertionError(SerialPort.lastError!.message);
    _serial.setBaudRate(_settings.selectedBaudrate);

    // Redireciona a stream do read para o controlador. A Stream read() só pode ser ouvida uma única vez.
    // Caso a porta serial seja desconectada, um erro será gerado e função close() será chamada.
    // Caso ocorra QUALQUER ERRO, a porta serial será FECHADA!!!
    _serialStreamController.addStream(_serial.read().handleError((error) => close()), cancelOnError: true);
  }

  /// Fecha a porta serial
  void close(){
    if(_serial.isOpen()) _serial.close();
  }

  /// Retorna [True] se a porta estiver aberta e [False] caso contrário
  bool isPortOpen(){
    return _serial.isOpen();
  }
  
  /// Retorna a stream do controlador [_serialStreamController]
  @override
  Stream<Uint8List> read() {
    return _outputStream;
  }
}