import 'package:arari_next/domain/telemetry/bms_data.dart';
import 'package:arari_next/domain/telemetry/gps_data.dart';
import 'package:arari_next/domain/telemetry/instrumentation_data.dart';
import 'package:arari_next/domain/telemetry/motor_data.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/domain/telemetry/motor_state_data.dart';
import 'package:arari_next/domain/telemetry/mppt_data.dart';
import 'package:arari_next/domain/telemetry/pump_data.dart';
import 'package:arari_next/domain/telemetry/radio_status_data.dart';
import 'package:arari_next/domain/telemetry/temperature_data.dart';

class FullBoatData {
  final BMSData? bmsData;
  late final MotorData motorLeft;
  late final MotorData motorRight;
  final MPPTData? mpptData;
  final InstrumentationData? instrumentationData;
  final GPSData? gpsData;
  final PumpData? pumpData;
  final TemperatureData? temperatureData;
  final RadioStatusData? radioStatusData;

  ({int hora, int minuto, bool isCharging})?
  get batteryRemainingTimeEstimation {
    if (bmsData == null) return null;

    double netCurrent = bmsData!.batteryCurrent;

    const double totalCapacityAh = 40.0;
    double currentAh = (bmsData!.stateOfCharge / 100.0) * totalCapacityAh;

    if (netCurrent == 0) {
      return (hora: 0, minuto: 0, isCharging: false);
    }

    double remainingHours;
    bool isCharging;

    // Corrente Negativa = Barco consumindo mais do que gerando (Descarregando)
    if (netCurrent < 0) {
      // DESCARREGANDO: Tempo para esvaziar
      isCharging = false;
      remainingHours = currentAh / netCurrent.abs();
    }
    // Corrente Positiva = Barco gerando mais do que consumindo (Carregando)
    else {
      isCharging = true;
      // CARREGANDO: Tempo para encher o que falta
      double ahMissingToFull = totalCapacityAh - currentAh;
      remainingHours = ahMissingToFull / netCurrent;
    }

    final hora = remainingHours.floor();
    final minuto = ((remainingHours - hora) * 60).round();

    return (hora: hora, minuto: minuto, isCharging: isCharging);
  }

  ({int hora, int minuto, bool isCharging})? get batteryTimeWithoutGeneration {
    if (bmsData == null || instrumentationData == null) return null;
    double currentSum =
        instrumentationData!.motorCurrentLeft +
        instrumentationData!.motorCurrentRight;

    const double totalCapacityAh = 40.0;
    double currentAh = (bmsData!.stateOfCharge / 100.0) * totalCapacityAh;

    if (currentSum == 0) {
      return (hora: 0, minuto: 0, isCharging: false);
    }

    double remainingHours;
    bool isCharging;

    // Corrente Negativa = Barco consumindo mais do que gerando (Descarregando)
    if (currentSum < 0) {
      // DESCARREGANDO: Tempo para esvaziar
      isCharging = false;
      remainingHours = currentAh / currentSum.abs();

      // Corrente Positiva = Barco gerando mais do que consumindo (Carregando)
    } else {
      // CARREGANDO: Tempo para encher o que falta
      isCharging = true;
      double ahMissingToFull = totalCapacityAh - currentAh;
      remainingHours = ahMissingToFull / currentSum;
    }

    final hora = remainingHours.floor();
    final minuto = ((remainingHours - hora) * 60).round();

    return (hora: hora, minuto: minuto, isCharging: isCharging);
  }

  FullBoatData({
    this.bmsData,
    MotorEletricalData? motorEletricalDataLeft,
    MotorEletricalData? motorEletricalDataRight,
    MotorStateData? motorStateDataLeft,
    MotorStateData? motorStateDataRight,
    this.mpptData,
    this.instrumentationData,
    this.gpsData,
    this.pumpData,
    this.temperatureData,
    this.radioStatusData,
  }) {
    motorLeft = MotorData(
      instance: MotorInstance.left,
      eletrical: motorEletricalDataLeft,
      state: motorStateDataLeft,
    );

    motorRight = MotorData(
      instance: MotorInstance.right,
      eletrical: motorEletricalDataRight,
      state: motorStateDataRight,
    );
  }

  factory FullBoatData.empty() {
    return FullBoatData(
      bmsData: BMSData.empty(),
      motorEletricalDataLeft: MotorEletricalData.empty(),
      motorEletricalDataRight: MotorEletricalData.empty(),
      motorStateDataLeft: MotorStateData.empty(),
      motorStateDataRight: MotorStateData.empty(),
      mpptData: MPPTData.empty(),
      instrumentationData: InstrumentationData.empty(),
      gpsData: GPSData.empty(),
      pumpData: PumpData.empty(),
      temperatureData: TemperatureData.empty(),
      radioStatusData: RadioStatusData.empty(),
    );
  }

  FullBoatData copyWith({
    BMSData? bmsData,
    MotorEletricalData? motorEletricalDataLeft,
    MotorEletricalData? motorEletricalDataRight,
    MotorStateData? motorStateDataLeft,
    MotorStateData? motorStateDataRight,
    MPPTData? mpptData,
    InstrumentationData? instrumentationData,
    GPSData? gpsData,
    PumpData? pumpData,
    TemperatureData? temperatureData,
    RadioStatusData? radioStatusData,
  }) {
    return FullBoatData(
      bmsData: bmsData ?? this.bmsData,
      motorEletricalDataLeft: motorEletricalDataLeft ?? motorLeft.eletrical,
      motorEletricalDataRight: motorEletricalDataRight ?? motorRight.eletrical,
      motorStateDataLeft: motorStateDataLeft ?? motorLeft.state,
      motorStateDataRight: motorStateDataRight ?? motorRight.state,
      mpptData: mpptData ?? this.mpptData,
      instrumentationData: instrumentationData ?? this.instrumentationData,
      gpsData: gpsData ?? this.gpsData,
      pumpData: pumpData ?? this.pumpData,
      temperatureData: temperatureData ?? this.temperatureData,
      radioStatusData: radioStatusData ?? this.radioStatusData,
    );
  }
}
