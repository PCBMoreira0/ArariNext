import 'package:arari_next/domain/models/iboat_data.dart';

final class MPPTData implements IBoatData {
  final double pvVoltage;
  final double pvCurrent;
  final double batteryVoltage;
  final double batteryCurrent;
  double get mpptCurrent => (pvVoltage * pvCurrent * 0.98) / batteryVoltage;

  MPPTData({required this.pvVoltage, required this.pvCurrent, required this.batteryCurrent, required this.batteryVoltage});
}