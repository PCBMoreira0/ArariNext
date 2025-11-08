import 'package:arari_next/domain/models/iboat_data.dart';

final class PanelStrings {
  final double string1;
  final double string2;
  final double string3;
  final double string4;  PanelStrings({required this.string1, required this.string2, required this.string3, required this.string4});
}

final class InstrumentationData extends IBoatData {
  final double batteryCurrent;
  final double batteryVoltage;
  final double motorCurrentLeft;
  final double motorCurrentRight;
  final double mpptCurrent;
  final PanelStrings panelStrings;
  final double auxBatteryCurrent;
  final double auxBatteryVoltage;
  final int irradiance;
  double get generationPower => mpptCurrent * batteryVoltage;
  double get batteryPower => batteryCurrent * batteryVoltage;
  double get motorPowerLeft => motorCurrentLeft * batteryVoltage;
  double get motorPowerRight => motorCurrentRight * batteryVoltage;
  double get resultantPower => batteryPower * batteryVoltage;

  InstrumentationData({required this.batteryCurrent, required this.batteryVoltage, required this.motorCurrentLeft, required this.motorCurrentRight, required this.mpptCurrent, required List<double> panelStrings, required this.auxBatteryCurrent, required this.auxBatteryVoltage, required this.irradiance, required super.timestamp}) : panelStrings = PanelStrings(string1: panelStrings[0], string2: panelStrings[1], string3: panelStrings[2], string4: panelStrings[3]);

  factory InstrumentationData.empty() {
    return InstrumentationData(batteryCurrent: 0, batteryVoltage: 0, motorCurrentLeft: 0, motorCurrentRight: 0, mpptCurrent: 0, panelStrings: [0, 0, 0, 0], auxBatteryCurrent: 0, auxBatteryVoltage: 0, irradiance: 0, timestamp: 0);
  }
}