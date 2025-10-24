import 'dart:async';
import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/domain/models/mppt_data.dart';
import 'package:arari_next/domain/models/temperature_data.dart';
import 'package:flutter/widgets.dart';

class DashboardViewmodel {
  BMSData? lastBatteryValue;
  MotorEletricalData? lastMotorValueRight;
  MotorEletricalData? lastMotorValueLeft;

  final PacketRepository _packetRepository;

  ValueNotifier<BMSData> bmsValueNotifier = ValueNotifier(BMSData.empty());
  ValueNotifier<(int, int)> batteryRemainingTimeWithGeneration = ValueNotifier((
    0,
    0,
  ));
  ValueNotifier<(int, int)> batteryRemainingTimeWithoutGeneration =
      ValueNotifier((0, 0));
  StreamSubscription? bmsStream;

  ValueNotifier<MotorEletricalData> motorLeftValueNotifier = ValueNotifier(
    MotorEletricalData.empty(),
  );
  ValueNotifier<MotorEletricalData> motorRightValueNotifier = ValueNotifier(
    MotorEletricalData.empty(),
  );
  StreamSubscription? motorStream;

  ValueNotifier<MotorStateData> motorStateRightValueNotifier = ValueNotifier(
    MotorStateData.empty(),
  );
  ValueNotifier<MotorStateData> motorStateLeftValueNotifier = ValueNotifier(
    MotorStateData.empty(),
  );
  StreamSubscription? motorStateStream;

  ValueNotifier<InstrumentationData> instrumentationValueNotifier =
      ValueNotifier(InstrumentationData.empty());
  StreamSubscription? instrumentationStream;

  ValueNotifier<TemperatureData> temperatureValueNotifier = ValueNotifier(
    TemperatureData.empty(),
  );
  StreamSubscription? temperatureStream;

  ValueNotifier<MPPTData> mpptValueNotifier = ValueNotifier(MPPTData.empty());
  StreamSubscription? mpptStream;

  ValueNotifier<GPSData> gpsValueNotifier = ValueNotifier(GPSData.empty());

  DashboardViewmodel({required PacketRepository repository})
    : _packetRepository = repository {
    _packetRepository.data.listen((data) => _processModel(data));
  }

  void _processModel(IBoatData? data) {
    if (data == null) return;
    if ((lastBatteryValue != null) &&
        (lastMotorValueRight != null) &&
        (lastMotorValueLeft != null)) {
      double currentSum =
          (lastMotorValueLeft!.busCurrent + lastMotorValueRight!.busCurrent);
      if (currentSum != 0) {
        double remainingHours =
            -1 *
            (((lastBatteryValue!.stateOfCharge / 100.0) * 40.0) / currentSum);
        batteryRemainingTimeWithoutGeneration.value = (
          remainingHours.floor(),
          ((remainingHours - remainingHours.floor()) * 60).round(),
        );
      } else {
        batteryRemainingTimeWithoutGeneration.value = (0, 0);
      }

      lastBatteryValue = null;
      lastMotorValueRight = null;
      lastMotorValueLeft = null;
    }

    switch (data) {
      case BMSData bms:
        updateBMS(bms);
        break;

      case MotorEletricalData motor:
        updateMotor(motor);
        break;

      case MotorStateData motorState:
        updateMotorState(motorState);
        break;

      case InstrumentationData inst:
        updateInstrumentation(inst);
        break;

      case TemperatureData temp:
        updateTemperature(temp);
        break;

      case MPPTData mppt:
        updateMppt(mppt);
        break;

      case GPSData gps:
        updateGPS(gps);
        break;
    }
  }

  void updateGPS(GPSData data) {
    gpsValueNotifier.value = data;
  }

  void updateBMS(BMSData data) {
    lastBatteryValue = data;
    bmsValueNotifier.value = data;

    if (data.batteryCurrent != 0) {
      double remainingHours =
          -1 * (((data.stateOfCharge / 100.0) * 40.0) / data.batteryCurrent);
      batteryRemainingTimeWithGeneration.value = (
        remainingHours.floor(),
        ((remainingHours - remainingHours.floor()) * 60).round(),
      );
    } else {
      batteryRemainingTimeWithGeneration.value = (0, 0);
    }
  }

  void updateMotor(MotorEletricalData data) {
    if (data.instance == MotorInstance.left) {
      lastMotorValueLeft = data;
      motorLeftValueNotifier.value = data;
    } else {
      lastMotorValueRight = data;
      motorRightValueNotifier.value = data;
    }
  }

  void updateMotorState(MotorStateData data) {
    if (data.instance == MotorInstance.left) {
      motorStateLeftValueNotifier.value = data;
    } else {
      motorStateRightValueNotifier.value = data;
    }
  }

  void updateInstrumentation(InstrumentationData data) {
    instrumentationValueNotifier.value = data;
  }

  void updateTemperature(TemperatureData data) {
    temperatureValueNotifier.value = data;
  }

  void updateMppt(MPPTData data) {
    mpptValueNotifier.value = data;
  }
}
