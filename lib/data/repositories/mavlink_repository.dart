import 'dart:async';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:arari_next/utils/mavlink/mavlink_to_models.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:flutter/material.dart';

class MavlinkRepository extends PacketRepository {
  StreamController<IBoatData?> streamController = StreamController.broadcast();
  @override
  Stream<IBoatData?> get data => streamController.stream;

  final MavlinkParser _mavlinkParser = MavlinkParser(MavlinkDialectArariboat());

  final SerialService _serialService;

  MavlinkRepository({required SerialService serialService}) : _serialService = serialService {
    _mavlinkParser.stream.listen(_processPackage);
    _serialService.read().listen((data) => _mavlinkParser.parse(data));
  }

  IBoatData? _getModelFromMavlink(MavlinkFrame frame){
    switch (frame.message) {
      case Bms bms:
        return MavlinkToModels.toBms(bms);
      
      case BmsStatus bmsStatus:
        return MavlinkToModels.toBmsStatus(bmsStatus);

      case Gps gps:
        return MavlinkToModels.toGPS(gps);

      case Instrumentation instrumentation:
        return MavlinkToModels.toInstrumentation(instrumentation);

      case EzkontrolMcuMeterDataI motorData1:
        return MavlinkToModels.toMotor1(motorData1);

      case EzkontrolMcuMeterDataIi motorData2:
        return MavlinkToModels.toMotor2(motorData2);
      
      case Mppt mppt:
        return MavlinkToModels.toMppt(mppt);
      
      case MpptState mpptState:
        return MavlinkToModels.toMpptState(mpptState);

      case Pumps pump:
        return MavlinkToModels.toPump(pump);
      
      case RadioStatus radio:
        return MavlinkToModels.toRadioStatus(radio);

      case Temperatures temperatures:
        return MavlinkToModels.toTemperature(temperatures);

      default:
        return null;
    }
  }

  void _processPackage(MavlinkFrame frame){
    streamController.add(_getModelFromMavlink(frame));
  }  
}