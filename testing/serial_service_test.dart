import 'dart:typed_data';

import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/repositories/mavlink_repository.dart';
import 'package:arari_next/data/services/serial/model/serial_port_data.dart';
import 'package:arari_next/data/services/serial/serial_connector_refactor.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:arari_next/main.dart';
import 'package:flutter/material.dart';


void main() async {
  var serial = SerialService(serial: SerialConnector(), settings: await SettingsManager.create());

  serial.open();

  // MavlinkRepository repo = MavlinkRepository(serialService: serial);
  serial.read().listen((data) => print(data.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ')), onError: (data) => print('ERRO: $data'));
  // var a = MavlinkRepository(serialService: serial);
  // a.gpsData.listen((data) => print(data.speed));
  await Future.delayed(Duration(seconds: 5));

  serial.close();
  
  print('REABRINDO');
  await Future.delayed(Duration(seconds: 2));
  print('REABRIU');
  serial.open();
}