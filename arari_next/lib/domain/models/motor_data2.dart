import 'package:arari_next/domain/models/iboat_data.dart';

enum MotorStatus {
  gear,
  breaking,
  operationMode,
  dcContactor
}

final class MotorData2 implements IBoatData {
  final int controllerTemperature;
  final int motorTemperature;
  final MotorStatus status;
  final int errorFlagByte4;
  final int errorFlagByte5;
  final int errorFlagByte6;
  final int lifeSignal;

  MotorData2({required this.controllerTemperature, required this.motorTemperature, required this.status, this.errorFlagByte4 = 0, this.errorFlagByte5 = 0, this.errorFlagByte6 = 0, required this.lifeSignal});
}