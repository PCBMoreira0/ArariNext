import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/bms_status_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/domain/models/mppt_data.dart';
import 'package:arari_next/domain/models/mppt_state_data.dart';
import 'package:arari_next/domain/models/pump_data.dart';
import 'package:arari_next/domain/models/radio_status_data.dart';
import 'package:arari_next/domain/models/temperature_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';


class MavlinkToModels {
  
  static GPSData toGPS(Gps gps){
    return GPSData(latitude: gps.latitude / 1e7, longitude: gps.longitude / 1e7, speed: double.parse((gps.speed * 0.0194384).toStringAsFixed(2)), course: gps.course, heading: gps.heading, visibleSatellites: gps.satellitesVisible, hdop: gps.hdop / 10.0, timestamp: gps.timestampSeconds * 1000 + gps.timestampMilliseconds);
  }

  static BMSData toBms(Bms bms){
    return BMSData(voltagesMillivolts: bms.voltages, temperatures: bms.temperatures, batteryCurrent: bms.currentBattery / 10.0, stateOfCharge: bms.stateOfCharge / 10.0, timestamp: bms.timestampSeconds * 1000 + bms.timestampMilliseconds);
  }

  static BMSStatusData toBmsStatus(BmsStatus bmsStatus){
    return BMSStatusData(temperatures: bmsStatus.temperatures.map((value) => value / 100.0).toList(), status: bmsStatus.status, failureFlagsByte0: bmsStatus.failureFlagsByte0, failureFlagsByte1: bmsStatus.failureFlagsByte1, failureFlagsByte2: bmsStatus.failureFlagsByte2, failureFlagsByte3: bmsStatus.failureFlagsByte3, failureFlagsByte4: bmsStatus.failureFlagsByte4, failureFlagsByte5: bmsStatus.failureFlagsByte5, failureFlagsByte6: bmsStatus.failureFlagsByte6, faultCodeByte7: bmsStatus.faultCodeByte7, timestamp: bmsStatus.timestampSeconds * 1000 + bmsStatus.timestampMilliseconds);
  }

  static InstrumentationData toInstrumentation(Instrumentation instrumentation){
    return InstrumentationData(batteryCurrent: instrumentation.batteryCurrent / 100.0, batteryVoltage: instrumentation.batteryVoltage / 100.0, motorCurrentLeft: instrumentation.motorCurrentLeft / 100.0, motorCurrentRight: instrumentation.motorCurrentRight / 100.0, mpptCurrent: instrumentation.mpptCurrent / 100.0, panelStrings: instrumentation.panelStrings.map((number) => number.toDouble() / 1000.0).toList(), auxBatteryCurrent: instrumentation.auxiliaryBatteryCurrent / 100.0, auxBatteryVoltage: instrumentation.auxiliaryBatteryVoltage / 100.0, irradiance: instrumentation.irradiance, timestamp: instrumentation.timestampSeconds * 1000 + instrumentation.timestampMilliseconds);
  }

  static MotorEletricalData toMotor1(EzkontrolMcuMeterDataI motorData1){
    return MotorEletricalData(busVoltage: motorData1.busVoltage / 10.0, busCurrent: motorData1.busCurrent / 10.0, rpm: motorData1.rpm, acceleratorOpening: motorData1.acceleratorOpening, instance: motorData1.instance == 0 ? MotorInstance.left : MotorInstance.right, timestamp: motorData1.timestampSeconds * 1000 + motorData1.timestampMilliseconds);
  }

  static MotorStateData toMotor2(EzkontrolMcuMeterDataIi motorData2){
    return MotorStateData(controllerTemperature: motorData2.controllerTemperature, motorTemperature: motorData2.motorTemperature, status: motorData2.status,  errorFlagByte4: motorData2.errorFlagsByte4, errorFlagByte5: motorData2.errorFlagsByte5, errorFlagByte6: motorData2.errorFlagsByte6, lifeSignal: motorData2.lifeSignal, instance: motorData2.instance == 0 ? MotorInstance.left : MotorInstance.right, timestamp: motorData2.timestampSeconds * 1000 + motorData2.timestampMilliseconds);
  } 

  static MPPTData toMppt(Mppt mppt){
    return MPPTData(pvVoltage: mppt.pvVoltage / 100.0, pvCurrent: mppt.pvCurrent / 100.0, batteryCurrent: mppt.batteryCurrent / 100.0, batteryVoltage: mppt.batteryVoltage / 100.0, timestamp: mppt.timestampSeconds * 1000 + mppt.timestampMilliseconds);
  }

  static MPPTStateData toMpptState(MpptState mpptState){
    return MPPTStateData(batteryStatus: mpptState.batteryStatus, chargingEquipmentStatus: mpptState.chargingEquipmentStatus, timestamp: mpptState.timestampSeconds * 1000 + mpptState.timestampMilliseconds);
  }

  static PumpData toPump(Pumps pump){
    return PumpData(pump.pumpStates == 0 ? PumpState.left : PumpState.right, timestamp: pump.timestampSeconds * 1000 + pump.timestampMilliseconds);
  }

  static RadioStatusData toRadioStatus(RadioStatus radio){
    return RadioStatusData(rxErrors: radio.rxerrors, instance: radio.instance == 0 ? RadioInstance.primary : RadioInstance.secondary, rssi: radio.rssi, timestamp: radio.timestampSeconds * 1000 + radio.timestampMilliseconds);
  }

  static TemperatureData toTemperature(Temperatures temperatures){
    return TemperatureData(temperatureBatteryLeft: temperatures.temperatureBatteryLeft / 100.0, temperatureBatteryRight: temperatures.temperatureBatteryRight / 100.0, temperatureMPPTLeft: temperatures.temperatureMpptLeft / 100.0, temperatureMPPTRight: temperatures.temperatureMpptRight / 100.0, temperatureMotorLeft: temperatures.temperatureMotorLeft / 100.0, temperatureMotorRight: temperatures.temperatureMotorRight / 100.0, temperatureESCRLeft: temperatures.temperatureEscLeft / 100.0, temperatureESCRRight: temperatures.temperatureEscRight / 100.0, temperatureMotorCoverLeft: temperatures.temperatureMotorCoverLeft / 100.0, temperatureMotorCoverRight: temperatures.temperatureMotorCoverRight / 100.0, timestamp: temperatures.timestampSeconds * 1000 + temperatures.timestampMilliseconds);
  }
}