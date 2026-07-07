import 'dart:async';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/data/services/pipeline/telemetry_source_interface.dart';
import 'package:arari_next/domain/telemetry/bms_data.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/domain/telemetry/gps_data.dart';
import 'package:arari_next/domain/telemetry/iboat_data.dart';
import 'package:arari_next/domain/telemetry/instrumentation_data.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/domain/telemetry/motor_state_data.dart';
import 'package:arari_next/domain/telemetry/mppt_data.dart';
import 'package:arari_next/domain/telemetry/pump_data.dart';
import 'package:arari_next/domain/telemetry/radio_status_data.dart';
import 'package:arari_next/domain/telemetry/temperature_data.dart';

class MavlinkRepository extends PacketRepository {
  final ITelemetrySource _source;
  late StreamSubscription _sourceSubscription;

  final StreamController<FullBoatData?> _streamController =
      StreamController.broadcast();

  @override
  Stream<FullBoatData?> get data => _streamController.stream;

  FullBoatData _fullBoatData = FullBoatData();

  MavlinkRepository({required ITelemetrySource source}) : _source = source {
    _sourceSubscription = _source.stream.listen(
      (data) => _processData(data),
    );
  }

  void _processData(IBoatData data) {
    _updateFullData(data);
    _streamController.add(_fullBoatData);
  }

  void _updateFullData(IBoatData data) {
    switch (data) {
      case BMSData bms:
        _fullBoatData = _fullBoatData.copyWith(bmsData: bms);
        break;

      case GPSData gps:
        _fullBoatData = _fullBoatData.copyWith(gpsData: gps);
        break;

      case InstrumentationData instrumentation:
        _fullBoatData = _fullBoatData.copyWith(
          instrumentationData: instrumentation,
        );

        break;

      case MotorEletricalData motorEletrical:
        if (motorEletrical.instance == MotorInstance.left) {
          _fullBoatData = _fullBoatData.copyWith(
            motorEletricalDataLeft: motorEletrical,
          );
        } else if (motorEletrical.instance == MotorInstance.right) {
          _fullBoatData = _fullBoatData.copyWith(
            motorEletricalDataRight: motorEletrical,
          );
        }
        break;

      case MotorStateData motorState:
        if (motorState.instance == MotorInstance.left) {
          _fullBoatData = _fullBoatData.copyWith(
            motorStateDataLeft: motorState,
          );
        } else if (motorState.instance == MotorInstance.right) {
          _fullBoatData = _fullBoatData.copyWith(
            motorStateDataRight: motorState,
          );
        }
        break;

      case MPPTData mppt:
        _fullBoatData = _fullBoatData.copyWith(mpptData: mppt);
        break;

      case PumpData pump:
        _fullBoatData = _fullBoatData.copyWith(pumpData: pump);
        break;

      case RadioStatusData radio:
        _fullBoatData = _fullBoatData.copyWith(radioStatusData: radio);
        break;

      case TemperatureData temperatures:
        _fullBoatData = _fullBoatData.copyWith(temperatureData: temperatures);
        break;
    }
  }

  Future<void> dispose() async {
    _sourceSubscription.cancel();
    _streamController.close();
  }
}
