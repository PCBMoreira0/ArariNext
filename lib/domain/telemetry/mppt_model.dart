import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

final class MpptModel extends ITelemetryModel {
  final double pvVoltage;
  final double pvCurrent;
  final double batteryVoltage;
  final double batteryCurrent;
  double get mpptCurrent => (((pvVoltage * pvCurrent * 0.98) / batteryVoltage) * 100.0).roundToDouble() / 100;

  MpptModel({required this.pvVoltage, required this.pvCurrent, required this.batteryCurrent, required this.batteryVoltage, required super.timestamp});

  factory MpptModel.empty() {
    return MpptModel(pvVoltage: 0, pvCurrent: 0, batteryVoltage: 0, batteryCurrent: 0, timestamp: 0);
  }
}