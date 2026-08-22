import 'package:arari_next/domain/telemetry/bms_model.dart';
import 'package:arari_next/domain/telemetry/bms_status_model.dart';
import 'package:arari_next/domain/telemetry/gps_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';
import 'package:arari_next/domain/telemetry/instrumentation_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/domain/telemetry/motor_state_model.dart';
import 'package:arari_next/domain/telemetry/mppt_model.dart';
import 'package:arari_next/domain/telemetry/mppt_state_model.dart';
import 'package:arari_next/domain/telemetry/pump_model.dart';
import 'package:arari_next/domain/telemetry/radio_status_model.dart';
import 'package:arari_next/domain/telemetry/temperature_model.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:arari_next/utils/mavlink/mavlink_to_models.dart';
import 'package:dart_mavlink/mavlink.dart';

class MavlinkMapper {
  GpsModel toGPS(Gps gps) {
    return GpsModel(
      latitude: gps.latitude / 1e7,
      longitude: gps.longitude / 1e7,
      speed: double.parse((gps.speed * 0.0194384).toStringAsFixed(2)),
      course: gps.course,
      heading: gps.heading,
      visibleSatellites: gps.satellitesVisible,
      hdop: gps.hdop / 10.0,
      timestamp: gps.timestampSeconds * 1000 + gps.timestampMilliseconds,
    );
  }

  BmsModel toBms(Bms bms) {
    return BmsModel(
      voltagesMillivolts: bms.voltages,
      temperatures: bms.temperatures,
      batteryCurrent: bms.currentBattery / 10.0,
      stateOfCharge: bms.stateOfCharge / 10.0,
      timestamp: bms.timestampSeconds * 1000 + bms.timestampMilliseconds,
    );
  }

  BMSStatusData toBmsStatus(BmsStatus bmsStatus) {
    return BMSStatusData(
      temperatures: bmsStatus.temperatures
          .map((value) => value / 100.0)
          .toList(),
      status: bmsStatus.status,
      failureFlagsByte0: bmsStatus.failureFlagsByte0,
      failureFlagsByte1: bmsStatus.failureFlagsByte1,
      failureFlagsByte2: bmsStatus.failureFlagsByte2,
      failureFlagsByte3: bmsStatus.failureFlagsByte3,
      failureFlagsByte4: bmsStatus.failureFlagsByte4,
      failureFlagsByte5: bmsStatus.failureFlagsByte5,
      failureFlagsByte6: bmsStatus.failureFlagsByte6,
      faultCodeByte7: bmsStatus.faultCodeByte7,
      timestamp:
          bmsStatus.timestampSeconds * 1000 + bmsStatus.timestampMilliseconds,
    );
  }

  InstrumentationModel toInstrumentation(Instrumentation instrumentation) {
    return InstrumentationModel(
      batteryCurrent: instrumentation.batteryCurrent / 100.0,
      batteryVoltage: instrumentation.batteryVoltage / 100.0,
      motorCurrentLeft: instrumentation.motorCurrentLeft / 100.0,
      motorCurrentRight: instrumentation.motorCurrentRight / 100.0,
      mpptCurrent: instrumentation.mpptCurrent / 100.0,
      panelStrings: instrumentation.panelStrings
          .map((number) => number.toDouble() / 1000.0)
          .toList(),
      auxBatteryCurrent: instrumentation.auxiliaryBatteryCurrent / 100.0,
      auxBatteryVoltage: instrumentation.auxiliaryBatteryVoltage / 100.0,
      irradiance: instrumentation.irradiance,
      timestamp:
          instrumentation.timestampSeconds * 1000 +
          instrumentation.timestampMilliseconds,
    );
  }

  MotorEletricalModel toMotor1(EzkontrolMcuMeterDataI motorData1) {
    return MotorEletricalModel(
      busVoltage: motorData1.busVoltage / 10.0,
      busCurrent: motorData1.busCurrent / 10.0,
      rpm: motorData1.rpm,
      acceleratorOpening: motorData1.acceleratorOpening,
      instance: motorData1.instance == 0
          ? MotorInstance.left
          : MotorInstance.right,
      timestamp:
          motorData1.timestampSeconds * 1000 + motorData1.timestampMilliseconds,
    );
  }

  MotorStateModel toMotor2(EzkontrolMcuMeterDataIi motorData2) {
    return MotorStateModel(
      controllerTemperature: motorData2.controllerTemperature,
      motorTemperature: motorData2.motorTemperature,
      status: motorData2.status,
      errorFlagByte4: motorData2.errorFlagsByte4,
      errorFlagByte5: motorData2.errorFlagsByte5,
      errorFlagByte6: motorData2.errorFlagsByte6,
      lifeSignal: motorData2.lifeSignal,
      instance: motorData2.instance == 0
          ? MotorInstance.left
          : MotorInstance.right,
      timestamp:
          motorData2.timestampSeconds * 1000 + motorData2.timestampMilliseconds,
    );
  }

  MpptModel toMppt(Mppt mppt) {
    return MpptModel(
      pvVoltage: mppt.pvVoltage / 100.0,
      pvCurrent: mppt.pvCurrent / 100.0,
      batteryCurrent: mppt.batteryCurrent / 100.0,
      batteryVoltage: mppt.batteryVoltage / 100.0,
      timestamp: mppt.timestampSeconds * 1000 + mppt.timestampMilliseconds,
    );
  }

  MPPTStateData toMpptState(MpptState mpptState) {
    return MPPTStateData(
      batteryStatus: mpptState.batteryStatus,
      chargingEquipmentStatus: mpptState.chargingEquipmentStatus,
      timestamp:
          mpptState.timestampSeconds * 1000 + mpptState.timestampMilliseconds,
    );
  }

  PumpModel toPump(Pumps pump) {
    return PumpModel(
      pump.pumpStates == 0 ? PumpState.left : PumpState.right,
      timestamp: pump.timestampSeconds * 1000 + pump.timestampMilliseconds,
    );
  }

  RadioStatusModel toRadioStatus(RadioStatus radio) {
    return RadioStatusModel(
      rxErrors: radio.rxerrors,
      instance: radio.instance == 0
          ? RadioInstance.primary
          : RadioInstance.secondary,
      rssi: radio.rssi,
      timestamp: radio.timestampSeconds * 1000 + radio.timestampMilliseconds,
    );
  }

  TemperatureModel toTemperature(Temperatures temperatures) {
    return TemperatureModel(
      temperatureBatteryLeft: temperatures.temperatureBatteryLeft / 100.0,
      temperatureBatteryRight: temperatures.temperatureBatteryRight / 100.0,
      temperatureMPPTLeft: temperatures.temperatureMpptLeft / 100.0,
      temperatureMPPTRight: temperatures.temperatureMpptRight / 100.0,
      temperatureMotorLeft: temperatures.temperatureMotorLeft / 100.0,
      temperatureMotorRight: temperatures.temperatureMotorRight / 100.0,
      temperatureESCRLeft: temperatures.temperatureEscLeft / 100.0,
      temperatureESCRRight: temperatures.temperatureEscRight / 100.0,
      temperatureMotorCoverLeft: temperatures.temperatureMotorCoverLeft / 100.0,
      temperatureMotorCoverRight:
          temperatures.temperatureMotorCoverRight / 100.0,
      timestamp:
          temperatures.timestampSeconds * 1000 +
          temperatures.timestampMilliseconds,
    );
  }

  ITelemetryModel? map(MavlinkFrame frame) {
    switch (frame.message) {
      case Bms bms:
        return MavlinkToModels.toBms(bms);

      case BmsStatus bmsStatus:
        return MavlinkToModels.toBmsStatus(bmsStatus);

      case Gps gps:
        return MavlinkToModels.toGPS(gps);

      case Instrumentation instrumentation:
        return MavlinkToModels.toInstrumentation(instrumentation);

      case EzkontrolMcuMeterDataI motorData1:
        return MavlinkToModels.toMotor1(motorData1);

      case EzkontrolMcuMeterDataIi motorData2:
        return MavlinkToModels.toMotor2(motorData2);

      case Mppt mppt:
        return MavlinkToModels.toMppt(mppt);

      case MpptState mpptState:
        return MavlinkToModels.toMpptState(mpptState);

      case Pumps pump:
        return MavlinkToModels.toPump(pump);

      case RadioStatus radio:
        return MavlinkToModels.toRadioStatus(radio);

      case Temperatures temperatures:
        return MavlinkToModels.toTemperature(temperatures);

      default:
        return null;
    }
  }
}
