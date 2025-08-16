import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:arari_next/domain/models/motor_data1.dart';

enum MotorStatus {
  gear,
  breaking,
  operationMode,
  dcContactor
}

// DO NOT REORDER
enum EzkontrolErrorFlag {
  // byte 4 
  overcurrent,
  overload,
  overvoltage,
  undervoltage,
  controllerOverhead,
  motorOverheat,
  motorStalled,
  motorOutOfPhase,

  // byte5
  motorSensor,
  motorAuxSensor,
  encoderMisaligned,
  antiRunawayEngaged,
  mainAccelerator,
  auxAccelerator,
  preCharge,
  dcContactor,

  // byte6
  powerValve,
  currentSensor,
  autoTune,
  rs485,
  can,
  software
}

final class MotorData2 implements IBoatData {
  final int controllerTemperature;
  final int motorTemperature;
  final int status;
  final List<EzkontrolErrorFlag> errorFlags;
  final int lifeSignal;
  final MotorInstance instance;

  MotorData2._({required this.controllerTemperature, required this.motorTemperature, required this.status, required List<EzkontrolErrorFlag> errorFlags, required this.lifeSignal, required this.instance}) : errorFlags = List.unmodifiable(errorFlags);

  factory MotorData2({required int controllerTemperature, required int motorTemperature, required int status, int errorFlagByte4 = 0, int errorFlagByte5 = 0, int errorFlagByte6 = 0, required int lifeSignal, required MotorInstance instance}){

    List<EzkontrolErrorFlag> errorFlags = []; 

    // byte4
    for (int i = 0; i < 8; i++)
    {
        if((errorFlagByte4 & (128 >> i)) != 0)
        {
            errorFlags.add(EzkontrolErrorFlag.values[(i + 8 * 0)]);
        }
    }

    // byte5
    for (int i = 0; i < 8; i++)
    {
        if((errorFlagByte5 & (128 >> i)) != 0)
        {
            errorFlags.add(EzkontrolErrorFlag.values[(i + 8 * 1)]);
        }
    }

    for (int i = 0; i < 6; i++)
    {
        if((errorFlagByte6 & (128 >> i)) != 0)
        {
            errorFlags.add(EzkontrolErrorFlag.values[(i + 8 * 2)]);
        }
    }

    return MotorData2._(controllerTemperature: controllerTemperature, motorTemperature: motorTemperature, status: status,  errorFlags: errorFlags,lifeSignal: lifeSignal, instance: instance);
  }
}