import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/domain/models/mppt_data.dart';
import 'package:arari_next/domain/models/pump_data.dart';
import 'package:arari_next/domain/models/radio_status_data.dart';
import 'package:arari_next/domain/models/temperature_data.dart';

class FullBoatData {
  final BMSData bmsData;
  final MotorEletricalData motorEletricalData;
  final MotorStateData motorStateData;
  final MPPTData mpptData;
  final InstrumentationData instrumentationData;
  final GPSData gpsData;
  final PumpData pumpData;
  final TemperatureData temperatureData;
  final RadioStatusData radioStatusData;

  ({int hora, int minuto, bool isCharging})
  get batteryRemainingTimeEstimation {
    double netCurrent = bmsData.batteryCurrent;

    const double totalCapacityAh = 40.0;
    double currentAh = (bmsData.stateOfCharge / 100.0) * totalCapacityAh;

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

  ({int hora, int minuto, bool isCharging}) get batteryTimeWithoutGeneration {
    double currentSum =
        instrumentationData.motorCurrentLeft +
        instrumentationData.motorCurrentRight;

    const double totalCapacityAh = 40.0;
    double currentAh = (bmsData.stateOfCharge / 100.0) * totalCapacityAh;

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
    required this.bmsData,
    required this.motorEletricalData,
    required this.motorStateData,
    required this.mpptData,
    required this.instrumentationData,
    required this.gpsData,
    required this.pumpData,
    required this.temperatureData,
    required this.radioStatusData,
  });

  factory FullBoatData.empty() {
    return FullBoatData(
      bmsData: BMSData.empty(),
      motorEletricalData: MotorEletricalData.empty(),
      motorStateData: MotorStateData.empty(),
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
    MotorEletricalData? motorEletricalData,
    MotorStateData? motorStateData,
    MPPTData? mpptData,
    InstrumentationData? instrumentationData,
    GPSData? gpsData,
    PumpData? pumpData,
    TemperatureData? temperatureData,
    RadioStatusData? radioStatusData,
  }) {
    return FullBoatData(
      bmsData: bmsData ?? this.bmsData,
      motorEletricalData: motorEletricalData ?? this.motorEletricalData,
      motorStateData: motorStateData ?? this.motorStateData,
      mpptData: mpptData ?? this.mpptData,
      instrumentationData: instrumentationData ?? this.instrumentationData,
      gpsData: gpsData ?? this.gpsData,
      pumpData: pumpData ?? this.pumpData,
      temperatureData: temperatureData ?? this.temperatureData,
      radioStatusData: radioStatusData ?? this.radioStatusData,
    );
  }
}
