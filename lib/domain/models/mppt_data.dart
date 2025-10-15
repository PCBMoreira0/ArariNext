import 'package:arari_next/domain/models/iboat_data.dart';

final class MPPTData implements IBoatData {
  final double pvVoltage;
  final double pvCurrent;
  final double batteryVoltage;
  final double batteryCurrent;
  double get mpptCurrent => (((pvVoltage * pvCurrent * 0.98) / batteryVoltage) * 100.0).roundToDouble() / 100;

  MPPTData({required this.pvVoltage, required this.pvCurrent, required this.batteryCurrent, required this.batteryVoltage});

  factory MPPTData.empty() {
    return MPPTData(pvVoltage: 0, pvCurrent: 0, batteryVoltage: 0, batteryCurrent: 0);
  }
}