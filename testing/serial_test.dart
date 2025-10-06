import 'dart:async';
import 'dart:typed_data';

import 'package:arari_next/data/services/serial/model/serial_port_data.dart';
import 'package:arari_next/data/services/serial/serial_connector.dart';


void main() {
  SerialConnector con = SerialConnector();
  // print(SerialConnector.readPorts());
  var ports = SerialConnector.readPorts();
  var selectedPort;
  // for(int i = 0; i < ports.length; i++){
  //   if(ports[i].name == "COM9"){
  //     selectedPort = ports[i];
  //     break;
  //   }
  // }
  con.selectPort(SerialPortData("COM9", 0, '', '', '', '', '', '', '', '', '', ''));
  con.open();
  con.setBaudRate(9600);

  Stream<Uint8List> rawCon = con.read();
  rawCon.listen((data) => print(data.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ')), onError: (data) => print('ERRO: $data'));
  // Stream<String> upcomingData = rawCon.map((data) {
  //   print('read: $data, decoding it...');
  //   return String.fromCharCodes(data);
  // });


  // int counter = 0;

  // upcomingData.listen((data) {
  //   print(data);
  // }, onError: print);
}
  