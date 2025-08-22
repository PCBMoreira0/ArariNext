import 'dart:async';
import 'dart:typed_data';
import 'package:arari_next/domain/models/serial_port_data.dart';
import 'package:libserialport/libserialport.dart';
import 'dart:io';

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

  // Retorna a porta selecionada, null se nenhum porta tiver sido selecionada.
  SerialPort? selectedPort;

  late Stream<Uint8List>? outputStream;

  SerialPortReader? _reader;

  int? baudRate;

  // setting the baud rate 

  void setBaudRate(int baud) {

    baudRate = baud;

  }
  // Listar Portas e dados em strings literais

  List<SerialPortData> readPorts() {

    // Retorna as portas disponiveis.

    List<String> _availablePorts = SerialPort.availablePorts;

    // lista de portas bonita.
    List<SerialPortData> readyPortList = []; 

    // checa se a plataforma é linux e aplica patch
    if (Platform.isLinux) { _availablePorts = _availablePorts.sublist(1);}

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
  
  bool open() {

    // Checando se a porta selecionada é null, se for levanta um erro
    if (selectedPort == null) {
      throw ArgumentError.notNull('No serial port has been seelected');

    // Checando se a porta selecionada ja esta aberta, se estiver levanta um erro
    } else if (selectedPort!.isOpen) {
      throw AssertionError('Serial port is already open');

    } else if (baudRate == null) {
      throw AssertionError('BaudRate cant be null');

    } else {
      // Tentando abrir comuniação com a porta, exclamação pois temos certeza que a porta selecionada não é null.
      try {
        selectedPort!.openRead();        
        SerialPortConfig configuration = selectedPort!.config;

        // Setando a baudrate da porta depois de abri-la
        configuration.baudRate = 115200;
        configuration.setFlowControl(SerialPortFlowControl.rtsCts);
        configuration.parity = SerialPortParity.odd;
        configuration.dtr = 1;
        configuration.bits = 8;
        configuration.stopBits = 1;
        selectedPort!.config == configuration;
        // TODO implementar loging de status da porta, se a porta abrir, estamos aqui e temos que fazer algo
        return true;
      } on SerialPortError catch (err,_) {
        // TODO implementar loging de erros.
        rethrow;
        }
    }

    
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

  bool write(Uint8List message) {

    // checando erros previsisveis.
    checkPortIsGood();

    try {
      int? writteBytes;

      writteBytes = selectedPort!.write(message);
      // checa se o número de bytes confirmados é igual ao número de bytes enviados.
      if (message.length != writteBytes) {
          
        throw AssertionError('Number of bytes confirmed do not match de number of bytes sent');
        
      } else {
        return true;
      }
    } catch(err, _) {
      //TODO implementar loging de erros.
      rethrow;
    }
  }


  Stream<Uint8List> read() {

   // checando erros previsisveis.
    checkPortIsGood();

    try {
      // Convertendo stream 
      _reader = SerialPortReader(selectedPort!, timeout: 200);

      // Quando mensagem chega, converte ela de uint8 para string e streama a mesma novamente.
      outputStream = _reader!.stream;
      // Retorna a stream principal, excalamação já que sabemos que não é null pois juntamos a stream principal
      return outputStream!;
      } catch(err, _) {
      //TODO implementar loging de erros.
      rethrow;
    }
  }

  void close() { // evitar vazamentos de memoria por conta do serialPortReader, outputStream ou ReadWrite;

  if ( _reader != null) {
    _reader!.close();
  }

  if  (selectedPort != null) {
    selectedPort!.close();
  }

  }

}