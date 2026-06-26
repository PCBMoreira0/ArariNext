import 'dart:async';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/services/data_source_interface.dart';
import 'package:arari_next/data/services/logging_service_influx.dart';
import 'package:arari_next/domain/models/full_boat_data.dart';
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

      case Gps gps:
        _fullBoatData = _fullBoatData.copyWith(
          gpsData: MavlinkToModels.toGPS(gps),
        );

      case Instrumentation instrumentation:
        _fullBoatData = _fullBoatData.copyWith(
          instrumentationData: MavlinkToModels.toInstrumentation(
            instrumentation,
          ),
        );

      case EzkontrolMcuMeterDataI motorData1:
        _fullBoatData = _fullBoatData.copyWith(
          motorEletricalData: MavlinkToModels.toMotor1(motorData1),
        );

      case EzkontrolMcuMeterDataIi motorData2:
        _fullBoatData = _fullBoatData.copyWith(
          motorStateData: MavlinkToModels.toMotor2(motorData2),
        );

      case Mppt mppt:
        _fullBoatData = _fullBoatData.copyWith(
          mpptData: MavlinkToModels.toMppt(mppt),
        );

      case Pumps pump:
        _fullBoatData = _fullBoatData.copyWith(
          pumpData: MavlinkToModels.toPump(pump),
        );

      case RadioStatus radio:
        _fullBoatData = _fullBoatData.copyWith(
          radioStatusData: MavlinkToModels.toRadioStatus(radio),
        );

      case Temperatures temperatures:
        _fullBoatData = _fullBoatData.copyWith(
          temperatureData: MavlinkToModels.toTemperature(temperatures),
        );

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
