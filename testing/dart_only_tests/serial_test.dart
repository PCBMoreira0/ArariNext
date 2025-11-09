import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';



// void main() {
//   // SerialConnector con = SerialConnector();
//   // print(SerialConnector.readPorts());
//   // con.selectPort(SerialConnector.readPorts().first);
//   // con.setBaudRate(115200);
//   // con.open();

//   // Stream<Uint8List> rawCon = con.read();

//   // Stream<String> upcomingData = rawCon.map((data) {
//   //   print('read: $data, decoding it...');
//   //   return String.fromCharCodes(data);
//   // });

//   // rawCon.handleError((error) {
//   //   print('Erro serial: $error');
//   // });

//   // int counter = 0;

//   // upcomingData.listen((data) {
//   //   counter += 1;

//   //   if (data != '') {
//   //     print('$counter - $data');
//   //    }
//   // });

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Center(child: Text("Oi")),
//     );
//   }
// }

/*
 
 

  */
