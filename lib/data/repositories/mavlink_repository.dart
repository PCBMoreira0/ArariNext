import 'dart:async';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/bms_status_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_data1.dart';
import 'package:arari_next/domain/models/motor_data2.dart';
import 'package:arari_next/domain/models/mppt_data.dart';
import 'package:arari_next/domain/models/mppt_state_data.dart';
import 'package:arari_next/domain/models/pump_data.dart';
import 'package:arari_next/domain/models/radio_status_data.dart';
import 'package:arari_next/domain/models/temperature_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:arari_next/utils/mavlink/mavlink_to_models.dart';
import 'package:dart_mavlink/mavlink.dart';

class MavlinkRepository extends PacketRepository {

  /* Stream Controllers */
  final StreamController<BMSData> _bmsDataController = StreamController();
  final StreamController<BMSStatusData> _bmsStatusDataController = StreamController();
  final StreamController<GPSData> _gpsDataController = StreamController();
  final StreamController<InstrumentationData> _instrumentationDataController = StreamController();
  final StreamController<MotorData1> _motorData1Controller = StreamController();
  final StreamController<MotorData2> _motorData2Controller = StreamController();
  final StreamController<MPPTData> _mpptDataController = StreamController();
  final StreamController<MPPTStateData> _mpptStateDataController = StreamController();
  final StreamController<PumpData> _pumpDataController = StreamController();
  final StreamController<RadioStatusData> _radioStatusDataController = StreamController();
  final StreamController<TemperatureData> _temperatureDataController = StreamController();

  /* Streams */
  @override
  Stream<BMSData> get bmsData => _bmsDataController.stream.asBroadcastStream();
  @override
  Stream<BMSStatusData> get bmsStatusData => _bmsStatusDataController.stream.asBroadcastStream();
  @override
  Stream<GPSData> get gpsData => _gpsDataController.stream.asBroadcastStream();
  @override
  Stream<InstrumentationData> get instrumentationData => _instrumentationDataController.stream.asBroadcastStream();
  @override
  Stream<MotorData1> get motorData1 => _motorData1Controller.stream.asBroadcastStream();
  @override
  Stream<MotorData2> get motorData2 => _motorData2Controller.stream.asBroadcastStream();
  @override
  Stream<MPPTData> get mpptData => _mpptDataController.stream.asBroadcastStream();
  @override
  Stream<MPPTStateData> get mpptStateData => _mpptStateDataController.stream.asBroadcastStream();
  @override
  Stream<PumpData> get pumpData => _pumpDataController.stream.asBroadcastStream();
  @override
  Stream<RadioStatusData> get radioStatusData => _radioStatusDataController.stream.asBroadcastStream();
  @override
  Stream<TemperatureData> get temperatureData => _temperatureDataController.stream.asBroadcastStream();

  final MavlinkParser _mavlinkParser = MavlinkParser(MavlinkDialectArariboat());

  final ISerialService _serialService;

  MavlinkRepository({required ISerialService serialService}) : _serialService = serialService {
    _mavlinkParser.stream.listen(_processPackage);
    _serialService.read().listen((data) => _mavlinkParser.parse(data));
  }

  
  void _processPackage(MavlinkFrame frame){
    switch (frame.message) {
      case Bms bms:
        _bmsDataController.add(MavlinkToModels.toBms(bms));       
        break;
      
      case BmsStatus bmsStatus:
        _bmsStatusDataController.add(MavlinkToModels.toBmsStatus(bmsStatus));
        break;

      case Gps gps:
        _gpsDataController.add(MavlinkToModels.toGPS(gps));
        break;

      case Instrumentation instrumentation:
        _instrumentationDataController.add(MavlinkToModels.toInstrumentation(instrumentation));
        break;

      case EzkontrolMcuMeterDataI motorData1:
        _motorData1Controller.add(MavlinkToModels.toMotor1(motorData1));
        break;

      case EzkontrolMcuMeterDataIi motorData2:
        _motorData2Controller.add(MavlinkToModels.toMotor2(motorData2));
        break;
      
      case Mppt mppt:
        _mpptDataController.add(MavlinkToModels.toMppt(mppt));
        break;
      
      case MpptState mpptState:
        _mpptStateDataController.add(MavlinkToModels.toMpptState(mpptState));
        break;

      case Pumps pump:
        _pumpDataController.add(MavlinkToModels.toPump(pump));
        break;
      
      case RadioStatus radio:
        _radioStatusDataController.add(MavlinkToModels.toRadioStatus(radio));
        break;

      case Temperatures temperatures:
        _temperatureDataController.add(MavlinkToModels.toTemperature(temperatures));
        break;
      default:
    }
  }

  
}