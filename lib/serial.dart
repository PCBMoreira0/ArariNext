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

  // mostra as portas disponiveis.

  var availablePorts = SerialPort.availablePorts;

  String selectedPort = '';

  // organizar portas;

  List<SerialPortData> organizePorts() {

    List<SerialPortData> readyPortList = [];

    // para cada campo de endereço de porta checa se existem dados, se sim, os escreve nos campos, se não escreve N/D(Não Definido) nos campos, após isso adicona a porta a lista.

    for (final adress in availablePorts) {
      final port = SerialPort(adress);
      readyPortList.add(SerialPortData(
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

  void selectPort(String port) {

    selectedPort = port;

  }





}