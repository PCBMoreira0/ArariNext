import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

final class TemperatureModel extends ITelemetryModel {
  final double temperatureBatteryLeft;
  final double temperatureBatteryRight;
  final double temperatureMPPTLeft;
  final double temperatureMPPTRight;
  final double temperatureMotorLeft;
  final double temperatureMotorRight;
  final double temperatureESCRLeft;
  final double temperatureESCRRight;
  final double temperatureMotorCoverLeft;
  final double temperatureMotorCoverRight;

  TemperatureModel({required this.temperatureBatteryLeft, required this.temperatureBatteryRight, required this.temperatureMPPTLeft, required this.temperatureMPPTRight, required this.temperatureMotorLeft, required this.temperatureMotorRight, required this.temperatureESCRLeft, required this.temperatureESCRRight, required this.temperatureMotorCoverLeft, required this.temperatureMotorCoverRight, required super.timestamp});

  factory TemperatureModel.empty() {
    return TemperatureModel(temperatureBatteryLeft: 0, temperatureBatteryRight: 0, temperatureMPPTLeft: 0, temperatureMPPTRight: 0, temperatureMotorLeft: 0, temperatureMotorRight: 0, temperatureESCRLeft: 0, temperatureESCRRight: 0, temperatureMotorCoverLeft: 0, temperatureMotorCoverRight: 0, timestamp: 0);
  }
}