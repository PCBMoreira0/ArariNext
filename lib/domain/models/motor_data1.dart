import 'package:arari_next/domain/models/iboat_data.dart';

enum MotorInstance {
  left,
  right
}

final class MotorData1 implements IBoatData {
  final double busVoltage;
  final double busCurrent;
  final int rpm;
  final int acceleratorOpening;
  final MotorInstance instance;

  MotorData1({required this.busVoltage, required this.busCurrent, required this.rpm, required this.acceleratorOpening, required this.instance});
}