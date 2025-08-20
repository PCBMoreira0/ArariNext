import 'dart:typed_data';

import 'package:dart_mavlink/types.dart';
import 'package:arari_next/data/services/serial/serial.dart';


void main() {
  SerialConnector con = SerialConnector();
  print(con.readPorts());
  con.selectPort(con.readPorts().elementAt(0));
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
