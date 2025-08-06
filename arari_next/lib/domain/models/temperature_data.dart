import 'package:arari_next/domain/models/iboat_data.dart';

final class TemperatureData implements IBoatData {
  final double temperatureBatteryLeft;
  final double temperatureBatteryRight;
  final double temperatureMPPTLeft;
  final double temperatureMPPTRight;

  TemperatureData({required this.temperatureBatteryLeft, required this.temperatureBatteryRight, required this.temperatureMPPTLeft, required this.temperatureMPPTRight});
}