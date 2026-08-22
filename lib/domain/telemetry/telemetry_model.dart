import 'package:arari_next/domain/telemetry/bms_model.dart';
import 'package:arari_next/domain/telemetry/gps_model.dart';
import 'package:arari_next/domain/telemetry/instrumentation_model.dart';
import 'package:arari_next/domain/telemetry/motor_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/domain/telemetry/motor_state_model.dart';
import 'package:arari_next/domain/telemetry/mppt_model.dart';
import 'package:arari_next/domain/telemetry/pump_model.dart';
import 'package:arari_next/domain/telemetry/radio_status_model.dart';
import 'package:arari_next/domain/telemetry/temperature_model.dart';

class TelemetryModel {
  final BmsModel? bmsData;
  late final MotorModel motorLeft;
  late final MotorModel motorRight;
  final MpptModel? mpptData;
  final InstrumentationModel? instrumentationData;
  final GpsModel? gpsData;
  final PumpModel? pumpData;
  final TemperatureModel? temperatureData;
  final RadioStatusModel? radioStatusData;

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

  TelemetryModel({
    this.bmsData,
    MotorEletricalModel? motorEletricalDataLeft,
    MotorEletricalModel? motorEletricalDataRight,
    MotorStateModel? motorStateDataLeft,
    MotorStateModel? motorStateDataRight,
    this.mpptData,
    this.instrumentationData,
    this.gpsData,
    this.pumpData,
    this.temperatureData,
    this.radioStatusData,
  }) {
    motorLeft = MotorModel(
      instance: MotorInstance.left,
      eletrical: motorEletricalDataLeft,
      state: motorStateDataLeft,
    );

    motorRight = MotorModel(
      instance: MotorInstance.right,
      eletrical: motorEletricalDataRight,
      state: motorStateDataRight,
    );
  }

  factory TelemetryModel.empty() {
    return TelemetryModel(
      bmsData: BmsModel.empty(),
      motorEletricalDataLeft: MotorEletricalModel.empty(),
      motorEletricalDataRight: MotorEletricalModel.empty(),
      motorStateDataLeft: MotorStateModel.empty(),
      motorStateDataRight: MotorStateModel.empty(),
      mpptData: MpptModel.empty(),
      instrumentationData: InstrumentationModel.empty(),
      gpsData: GpsModel.empty(),
      pumpData: PumpModel.empty(),
      temperatureData: TemperatureModel.empty(),
      radioStatusData: RadioStatusModel.empty(),
    );
  }

  TelemetryModel copyWith({
    BmsModel? bmsData,
    MotorEletricalModel? motorEletricalDataLeft,
    MotorEletricalModel? motorEletricalDataRight,
    MotorStateModel? motorStateDataLeft,
    MotorStateModel? motorStateDataRight,
    MpptModel? mpptData,
    InstrumentationModel? instrumentationData,
    GpsModel? gpsData,
    PumpModel? pumpData,
    TemperatureModel? temperatureData,
    RadioStatusModel? radioStatusData,
  }) {
    return TelemetryModel(
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
