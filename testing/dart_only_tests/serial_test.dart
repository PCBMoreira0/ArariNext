import 'dart:typed_data';

import 'package:arari_next/data/services/serial/serial_connector_refactor.dart';


void main() {
  SerialConnector con = SerialConnector();
  print(SerialConnector.readPorts());
  con.selectPort(SerialConnector.readPorts().first);
  con.setBaudRate(115200);
  con.open();

  Stream<Uint8List> rawCon = con.read(); 

  Stream<String> upcomingData = rawCon.map((data) {
    print('read: $data, decoding it...');
    return String.fromCharCodes(data);
  });

  rawCon.handleError((error) {
    print('Erro serial: $error');
  });

  int counter = 0;

  upcomingData.listen((data) {
    counter += 1;
    
    if (data != '') {
      print('$counter - $data');
     }
  });
  }
  

 /*
 
 

  */
