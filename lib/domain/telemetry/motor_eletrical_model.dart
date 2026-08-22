import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

enum MotorInstance {
  left,
  right
}

final class MotorEletricalModel extends ITelemetryModel {
  final double busVoltage;
  final double busCurrent;
  final int rpm;
  final int acceleratorOpening;
  final MotorInstance instance;

  MotorEletricalModel({required this.busVoltage, required this.busCurrent, required this.rpm, required this.acceleratorOpening, required this.instance, required super.timestamp});

  factory MotorEletricalModel.empty() {
    return MotorEletricalModel(busVoltage: 0, busCurrent: 0, rpm: 0, acceleratorOpening: 0, instance: MotorInstance.left, timestamp: 0);
  }
}