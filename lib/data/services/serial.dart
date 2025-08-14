import 'dart:async';
import 'dart:typed_data';
import 'package:arari_next/domain/models/serial_port_data.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

// extendendo intToString para nossos propósitos no serial;

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Nativa';
      default:
        return 'Desconhecido';
    }
  }
}

// definindo a classe para possibilitar multiplas conexões;

class SerialConnector {

  // Retorna as portas disponiveis.

  final _availablePorts = SerialPort.availablePorts;

  // Retorna a porta selecionada, null se nenhum porta tiver sido selecionada.
  SerialPort? selectedPort;

  StreamController<String> outputStreamController = StreamController();

  late Stream<String>? outputStream;

  SerialPortReader? _reader;

  // Listar Portas e dados em strings literais

  List<SerialPortData> listPorts() {

    List<SerialPortData> readyPortList = []; 

    // para cada campo de endereço de porta checa se existem dados, se sim, os escreve nos campos, se não escreve N/D(Não Definido) nos campos, após isso adicona a porta a lista.

    for (final adress in _availablePorts) {
      final port = SerialPort(adress);
      readyPortList.add(SerialPortData(
        adress,
        port.address,
        port.description ?? 'N/D',
        port.transport.toTransport(),
        port.busNumber?.toPadded() ?? 'N/D',
        port.deviceNumber?.toPadded() ?? 'N/D',
        port.vendorId?.toHex() ?? 'N/D',
        port.productId?.toHex() ?? 'N/D',
        port.manufacturer ?? 'N/D',
        port.productName ?? 'N/D',
        port.serialNumber ?? 'N/D',
        port.macAddress ?? 'N/D'
      ));
    }

   // retorna lista completa de portas e dados, formatados em strig.
    return readyPortList;
  }

  // seleciona uma porta;

  void selectPort(SerialPortData port) {

    selectedPort = SerialPort(port.name);

  }
  
  bool connect() {

    // Checando se a porta selecionada é null, se for levanta um erro
    if (selectedPort == null) {
      throw ArgumentError.notNull('No serial port has been seelected');

    // Checando se a porta selecionada ja esta aberta, se estiver levanta um erro
    } else if (selectedPort!.isOpen) {
      throw AssertionError('Serial port is already open');

    } else {
      // Tentando abrir comuniação com a porta, exclamação pois temos certeza que a porta selecionada não é null.
      try {
        selectedPort!.openReadWrite();
        // TODO implementar loging de status da porta, se a porta abrir, estamos aqui e temos que fazer algo
        return true;
      } on SerialPortError catch (err,_) {
        // TODO implementar loging de erros.
        rethrow;
        }
    }

    
  }

  // traduzindo a mensagem de string to uint8list 
  Uint8List _stringToUint8List(String message) {

    List<int> messageCode = message.codeUnits;
    
    Uint8List translatedMessage = Uint8List.fromList(messageCode);

    return translatedMessage;
  }

  // implementandos seguintes erros previsiveis: Porta não aberta, porta não definida 

  bool checkPortIsGood() {

    if (selectedPort == null) {

      throw ArgumentError.notNull('No serial port has been seelected');
      
    } else if (selectedPort!.isOpen == false) {

      throw AssertionError('Serial port is not open');

    // se não tivemos erros previsiveis, tentar de fato escrever a mensagem;
    } else {return true;}

  }

  bool send(String message) {

    // checando erros previsisveis.
    checkPortIsGood();

    try {
      int? writteBytes = selectedPort!.write(_stringToUint8List(message));

      // checa se o número de bytes confirmados é igual ao número de bytes enviados.
      if (_stringToUint8List(message).length != writteBytes) {

        throw AssertionError('Number of bytes confirmed do not match de number of bytes sent');

      } else {
        return true;
      }
    } catch(err, _) {
      //TODO implementar loging de erros.
      rethrow;
    }
  }
   
  // traduzindo a mensagem de string to uint8list 
  String _uint8ListToString(Uint8List serialMessage) {

   String decodedMessage = String.fromCharCodes(serialMessage);

    return decodedMessage;
  }

  Stream read() {

   // checando erros previsisveis.
    checkPortIsGood();

    try {
      // Convertendo stream 
      _reader = SerialPortReader(selectedPort!);
      // Quando mensagem chega, converte ela de uint8 para string e streama a mesma novamente.
      Stream<String>fromSerial = _reader!.stream.map((data) {
        return _uint8ListToString(data);
      });

      //junta a stream de mensagens recebidas serial a stream da classe.
      outputStreamController.sink.addStream(fromSerial);
      // Retorna a stream principal, excalamação já que sabemos que não é null pois juntamos a stream principal
      return outputStream!;
      } catch(err, _) {
      //TODO implementar loging de erros.
      rethrow;
    }
  }

  void dispose() { // evitar vazamentos de memoria por conta do serialPortReader, outputStream ou ReadWrite;

  outputStreamController.close();
  
  if ( _reader != null) {
    _reader!.close();
  }

  if  (selectedPort != null) {
    selectedPort!.close();
  }

  }

}