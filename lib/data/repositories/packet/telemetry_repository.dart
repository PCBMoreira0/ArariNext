import 'dart:async';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/data/services/pipeline/telemetry_source_interface.dart';
import 'package:arari_next/domain/telemetry/bms_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:arari_next/domain/telemetry/gps_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';
import 'package:arari_next/domain/telemetry/instrumentation_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/domain/telemetry/motor_state_model.dart';
import 'package:arari_next/domain/telemetry/mppt_model.dart';
import 'package:arari_next/domain/telemetry/pump_model.dart';
import 'package:arari_next/domain/telemetry/radio_status_model.dart';
import 'package:arari_next/domain/telemetry/temperature_model.dart';

class TelemetryRepository extends ITelemetryRepository {
  final ITelemetrySource _source;
  late StreamSubscription _sourceSubscription;

  final StreamController<TelemetryModel?> _streamController =
      StreamController.broadcast();

  @override
  Stream<TelemetryModel?> get data => _streamController.stream;

  TelemetryModel _fullBoatData = TelemetryModel();

  TelemetryRepository({required ITelemetrySource source}) : _source = source {
    _sourceSubscription = _source.stream.listen(
      (data) => _processData(data),
    );
  }

  void _processData(ITelemetryModel data) {
    _updateFullData(data);
    _streamController.add(_fullBoatData);
  }

  void _updateFullData(ITelemetryModel data) {
    switch (data) {
      case BmsModel bms:
        _fullBoatData = _fullBoatData.copyWith(bmsData: bms);
        break;

      case GpsModel gps:
        _fullBoatData = _fullBoatData.copyWith(gpsData: gps);
        break;

      case InstrumentationModel instrumentation:
        _fullBoatData = _fullBoatData.copyWith(
          instrumentationData: instrumentation,
        );

        break;

      case MotorEletricalModel motorEletrical:
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

      case MotorStateModel motorState:
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

      case MpptModel mppt:
        _fullBoatData = _fullBoatData.copyWith(mpptData: mppt);
        break;

      case PumpModel pump:
        _fullBoatData = _fullBoatData.copyWith(pumpData: pump);
        break;

      case RadioStatusModel radio:
        _fullBoatData = _fullBoatData.copyWith(radioStatusData: radio);
        break;

      case TemperatureModel temperatures:
        _fullBoatData = _fullBoatData.copyWith(temperatureData: temperatures);
        break;
    }
  }

  @override
  Future<void> dispose() async {
    _sourceSubscription.cancel();
    _streamController.close();
  }
}
