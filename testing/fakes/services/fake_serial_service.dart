import 'dart:typed_data';

import 'package:arari_next/data/services/serial/serial_service_interface.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:dart_mavlink/mavlink.dart';

class FakeSerialService implements ISerialService {
  Stream<Uint8List> data = Stream<Uint8List>.periodic(Duration(seconds: 1), mavlinkDecoded);
  static Uint8List mavlinkDecoded(int a){
    var gps = Gps(latitude: 377749000, longitude: -1224194000, timestampSeconds: 1700000000, speed: 347, timestampMilliseconds: 500, course: 50, heading: 50, satellitesVisible: 8, hdop: 9);
    var frame = MavlinkFrame.v1(0, 255, 1, gps);

    var motor2 = EzkontrolMcuMeterDataIi(timestampSeconds: 0, timestampMilliseconds: 560, controllerTemperature: 56, motorTemperature: 102, status: 233, errorFlagsByte4: int.parse("01100010", radix: 2), errorFlagsByte5: int.parse("00101101", radix: 2), errorFlagsByte6: int.parse("10100100", radix: 2), lifeSignal: 2, instance: 1);
    var frameMot = MavlinkFrame.v1(0, 255, 1, motor2);

    return frameMot.serialize();
  }
  
  @override
  void close() {
    // TODO: implement close
  }
  
  @override
  bool open() {
    // TODO: implement open
    throw UnimplementedError();
  }
  
  @override
  Stream<Uint8List> read() {
    return data;
  }
  
  @override
  bool write(Uint8List bytes) {
    // TODO: implement write
    throw UnimplementedError();
  }

}