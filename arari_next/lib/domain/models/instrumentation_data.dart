import 'package:arari_next/domain/models/iboat_data.dart';

final class InstrumentationData implements IBoatData {
  final double batteryCurrent;
  final double batteryVoltage;
  final double motorCurrentLeft;
  final double motorCurrentRight;
  final double mpptCurrent;
  final double auxBatteryCurrent;
  final double auxBatteryVoltage;
  final double irradiance;
  double get generationPower => mpptCurrent * batteryVoltage;
  double get batteryPower => batteryCurrent * batteryVoltage;
  double get motorPowerLeft => motorCurrentLeft * batteryVoltage;
  double get motorPowerRight => motorCurrentRight * batteryVoltage;
  double get resultantPower => batteryPower * batteryVoltage;

  InstrumentationData({required this.batteryCurrent, required this.batteryVoltage, required this.motorCurrentLeft, required this.motorCurrentRight, required this.mpptCurrent, required this.auxBatteryCurrent, required this.auxBatteryVoltage, required this.irradiance});
}