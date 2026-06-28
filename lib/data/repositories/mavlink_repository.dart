import 'dart:async';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/services/data_source_interface.dart';
import 'package:arari_next/data/services/logging_service_influx.dart';
import 'package:arari_next/domain/models/full_boat_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:arari_next/utils/mavlink/mavlink_to_models.dart';
import 'package:dart_mavlink/mavlink.dart';

class MavlinkRepository extends PacketRepository {
  StreamController<FullBoatData?> streamController =
      StreamController.broadcast();

  @override
  Stream<FullBoatData?> get data => streamController.stream;

  final MavlinkParser _mavlinkParser = MavlinkParser(MavlinkDialectArariboat());

  final IDataSource _dataSource;
  final LoggingServiceInflux _log;

  FullBoatData _fullBoatData = FullBoatData.empty();

  MavlinkRepository({
    required IDataSource dataSource,
    required LoggingServiceInflux log,
  }) : _dataSource = dataSource,
       _log = log {
    _mavlinkParser.stream.listen(_processPackage);
    _dataSource.stream.listen((data) => _mavlinkParser.parse(data));
  }

  _updateFullDataFromMavlink(MavlinkFrame frame) {
    switch (frame.message) {
      case Bms bms:
        _fullBoatData = _fullBoatData.copyWith(
          bmsData: MavlinkToModels.toBms(bms),
        );
        break;

      case Gps gps:
        _fullBoatData = _fullBoatData.copyWith(
          gpsData: MavlinkToModels.toGPS(gps),
        );
        break;

      case Instrumentation instrumentation:
        _fullBoatData = _fullBoatData.copyWith(
          instrumentationData: MavlinkToModels.toInstrumentation(
            instrumentation,
          ),
        );
        break;

      case EzkontrolMcuMeterDataI motorData1:
        MotorEletricalData motorEletricalData = MavlinkToModels.toMotor1(
          motorData1,
        );
        if (motorEletricalData.instance == MotorInstance.left) {
          _fullBoatData = _fullBoatData.copyWith(
            motorEletricalDataLeft: motorEletricalData,
          );
        } else if (motorEletricalData.instance == MotorInstance.right) {
          _fullBoatData = _fullBoatData.copyWith(
            motorEletricalDataRight: motorEletricalData,
          );
        }
        break;

      case EzkontrolMcuMeterDataIi motorData2:
        MotorStateData motorStateData = MavlinkToModels.toMotor2(motorData2);
        if (motorStateData.instance == MotorInstance.left) {
          _fullBoatData = _fullBoatData.copyWith(
            motorStateDataLeft: motorStateData,
          );
        } else if (motorStateData.instance == MotorInstance.right) {
          _fullBoatData = _fullBoatData.copyWith(
            motorStateDataRight: motorStateData,
          );
        }
        break;

      case Mppt mppt:
        _fullBoatData = _fullBoatData.copyWith(
          mpptData: MavlinkToModels.toMppt(mppt),
        );
        break;

      case Pumps pump:
        _fullBoatData = _fullBoatData.copyWith(
          pumpData: MavlinkToModels.toPump(pump),
        );
        break;

      case RadioStatus radio:
        _fullBoatData = _fullBoatData.copyWith(
          radioStatusData: MavlinkToModels.toRadioStatus(radio),
        );
        break;

      case Temperatures temperatures:
        _fullBoatData = _fullBoatData.copyWith(
          temperatureData: MavlinkToModels.toTemperature(temperatures),
        );
        break;

      default:
        return null;
    }
  }

  void _processPackage(MavlinkFrame frame) {
    _updateFullDataFromMavlink(frame);
    streamController.add(_fullBoatData);
    if (_log.isOpen) {
      // TODO: Fix logging to influxdb
      // _log.save(model);
    }
  }
}
