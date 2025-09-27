import 'package:arari_next/domain/models/iboat_data.dart';

enum MotorInstance {
  left,
  right
}

final class MotorEletricalData implements IBoatData {
  final double busVoltage;
  final double busCurrent;
  final int rpm;
  final int acceleratorOpening;
  final MotorInstance instance;

  MotorEletricalData({required this.busVoltage, required this.busCurrent, required this.rpm, required this.acceleratorOpening, required this.instance});

  factory MotorEletricalData.empty() {
    return MotorEletricalData(busVoltage: 0, busCurrent: 0, rpm: 0, acceleratorOpening: 0, instance: MotorInstance.left);
  }
}