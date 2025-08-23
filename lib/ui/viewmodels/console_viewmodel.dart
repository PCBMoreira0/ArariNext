import 'package:flutter/material.dart';
import 'package:arari_next/utils/console_log/console_buffer.dart';
import 'package:arari_next/domain/models/console_log.dart';

class ConsoleViewModel with ChangeNotifier {
  // Esse é o jeito de criar um singleton em dart, tenho que estudar construtores para entender melhor isso aqui, mas por enquanto vai servir

  // definindo tamanho maximo do cache do console

  int _cacheSize = 100;

  get cacheSize {
    return _cacheSize;
  }
  
  set cacheSize(int size) {
    size = _cacheSize;
    _consoleCache.size = _cacheSize;
  }

  List<ConsoleLog>get logs => _consoleCache.asList();

  // definindo o buffer com o tamanho maximo.

  late final Buffer<ConsoleLog> _consoleCache = Buffer(size: _cacheSize);

  bool isNotEmpty () {
    if (_consoleCache.asList() == []) {
      return true;
    }
    else {return false;}
  }

  void log (LogType logtype, String contents) {
    ConsoleLog info = ConsoleLog(type: logtype, datetime: DateTime.now(), contents: contents);
    _consoleCache.add(info);
    print("Dentro do cache: ${logs.first.contents}");
    notifyListeners();
  }

  void clear () {
    _consoleCache.clear();
    notifyListeners();
  }

}