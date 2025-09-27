import 'dart:async';
import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/domain/models/mppt_data.dart';
import 'package:arari_next/domain/models/temperature_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:flutter/widgets.dart';

class DashboardViewmodel {
  final PacketRepository _packetRepository;

  ValueNotifier<BMSData> bmsValueNotifier = ValueNotifier(BMSData.empty());
  ValueNotifier<(int, int)> batteryRemainingTime = ValueNotifier((0,0));
  StreamSubscription? bmsStream;

  ValueNotifier<MotorEletricalData> motorLeftValueNotifier = ValueNotifier(MotorEletricalData.empty());
  ValueNotifier<MotorEletricalData> motorRightValueNotifier = ValueNotifier(MotorEletricalData.empty());
  StreamSubscription? motorStream;

  ValueNotifier<MotorStateData> motorStateRightValueNotifier = ValueNotifier(MotorStateData.empty());
  ValueNotifier<MotorStateData> motorStateLeftValueNotifier = ValueNotifier(MotorStateData.empty());
  StreamSubscription? motorStateStream;
  
  ValueNotifier<InstrumentationData> instrumentationValueNotifier = ValueNotifier(InstrumentationData.empty());
  StreamSubscription? instrumentationStream;

  ValueNotifier<TemperatureData> temperatureValueNotifier = ValueNotifier(TemperatureData.empty());
  StreamSubscription? temperatureStream;

  ValueNotifier<MPPTData> mpptValueNotifier = ValueNotifier(MPPTData.empty());
  StreamSubscription? mpptStream;
  

  DashboardViewmodel({required PacketRepository repository}) : _packetRepository = repository {
    bmsStream = _packetRepository.bmsData.listen(updateBMS);
    motorStream = _packetRepository.motorEletricalData.listen(updateMotor);
    motorStateStream = _packetRepository.motorStateData.listen(updateMotorState);
    instrumentationStream = _packetRepository.instrumentationData.listen(updateInstrumentation);
    temperatureStream = _packetRepository.temperatureData.listen(updateTemperature);
    mpptStream = _packetRepository.mpptData.listen(updateMppt);
  }

  void updateBMS(BMSData data){
    bmsValueNotifier.value = data;

    if(data.batteryCurrent != 0){
      double remaningHours = -1 * (((data.stateOfCharge / 100.0) * 40.0) / data.batteryCurrent);
      batteryRemainingTime.value = (remaningHours.floor(), ((remaningHours - remaningHours.floor()) * 60).round());
    }
    else{
      batteryRemainingTime.value = (0, 0);
    }
  }

  void updateMotor(MotorEletricalData data){
    if(data.instance == MotorInstance.left){
      motorLeftValueNotifier.value = data;
    }
    else{
      motorRightValueNotifier.value = data;
    }
  }

  void updateMotorState(MotorStateData data){
    if(data.instance == MotorInstance.left){
      motorStateLeftValueNotifier.value = data;
    }
    else{
      motorStateRightValueNotifier.value = data;
    }
  }

  void updateInstrumentation(InstrumentationData data){
    instrumentationValueNotifier.value = data;
  }

  void updateTemperature(TemperatureData data){
    temperatureValueNotifier.value = data;
  }

  void updateMppt(MPPTData data){
    mpptValueNotifier.value = data;
  }
}