import 'dart:async';
import 'package:arari_next/utils/console_log/console_buffer.dart';
import 'package:arari_next/domain/models/console_log.dart';

class Console {

  // Esse é o jeito de criar um singleton em dart, tenho que estudar construtores para entender melhor isso aqui, mas por enquanto vai servir

  // TODO estudar construtores 

  Console._privateConstructor();

  static final Console instance = Console._privateConstructor();


  // definindo tamanho maximo do cache do console

  static final int cacheSize = 100;

  // definindo o buffer com o tamanho maximo.
  

  final Buffer<ConsoleLog> _consoleCache = Buffer(size: cacheSize);

  final StreamController<ConsoleLog> _outputLogStreamController = StreamController();

  late Stream<ConsoleLog> outputLogStream = _outputLogStreamController.stream;

  void log (ConsoleLog info) {
    _outputLogStreamController.sink.add(info);
    _consoleCache.add(info);
  }

  List<ConsoleLog>? readCache() {
    if (_consoleCache.asList() == []) {
      return null;
    } else {
      return _consoleCache.asList();
    }
  }
 

}