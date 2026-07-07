import 'dart:async';
import 'dart:math';

import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/telemetry/bms_model.dart';
import 'package:arari_next/domain/telemetry/gps_model.dart';
import 'package:arari_next/domain/telemetry/instrumentation_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/domain/telemetry/motor_state_model.dart';
import 'package:arari_next/domain/telemetry/mppt_model.dart';
import 'package:arari_next/domain/telemetry/pump_model.dart';
import 'package:arari_next/domain/telemetry/radio_status_model.dart';
import 'package:arari_next/domain/telemetry/temperature_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';

class MockPacketRepository implements ITelemetryRepository {
  final StreamController<TelemetryModel?> _streamController = StreamController.broadcast();
  final Random _random = Random();
  Timer? _timer;

  @override
  Stream<TelemetryModel?> get data => _streamController.stream;

  MockPacketRepository() {
    _startGeneratingData();
  }

  void _startGeneratingData() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _streamController.add(_generateMockFullBoatData());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }

  double _randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  TelemetryModel _generateMockFullBoatData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return TelemetryModel(
      bmsData: _generateBMSData(timestamp),
      motorEletricalDataLeft: _generateMotorEletricalData(MotorInstance.left, timestamp),
      motorStateDataLeft: _generateMotorStateData(MotorInstance.left, timestamp),
      motorEletricalDataRight: _generateMotorEletricalData(MotorInstance.right, timestamp),
      motorStateDataRight: _generateMotorStateData(MotorInstance.right, timestamp),
      mpptData: _generateMPPTData(timestamp),
      instrumentationData: _generateInstrumentationData(timestamp),
      gpsData: _generateGPSData(timestamp),
      temperatureData: _generateTemperatureData(timestamp),
      pumpData: PumpModel.empty(), 
      radioStatusData: RadioStatusModel.empty(), 
    );
  }

  BmsModel _generateBMSData(int timestamp) {
    return BmsModel(
      voltagesMillivolts: List.generate(14, (_) => 3200 + _random.nextInt(400)),
      temperatures: List.generate(4, (_) => 20 + _random.nextInt(25)),
      batteryCurrent: _randomDouble(-50.0, 50.0),
      stateOfCharge: _randomDouble(10.0, 100.0),
      timestamp: timestamp,
    );
  }

  MotorEletricalModel _generateMotorEletricalData(MotorInstance instance, int timestamp) {
    return MotorEletricalModel(
      busVoltage: _randomDouble(45.0, 58.0),
      busCurrent: _randomDouble(0.0, 100.0),
      rpm: _random.nextInt(3000),
      acceleratorOpening: _random.nextInt(101),
      instance: instance,
      timestamp: timestamp,
    );
  }

  MotorStateModel _generateMotorStateData(MotorInstance instance, int timestamp) {
    return MotorStateModel(
      controllerTemperature: 30 + _random.nextInt(50),
      motorTemperature: 30 + _random.nextInt(60),
      status: _random.nextInt(4),
      errorFlagByte4: _random.nextDouble() > 0.95 ? _random.nextInt(256) : 0,
      errorFlagByte5: _random.nextDouble() > 0.95 ? _random.nextInt(256) : 0,
      errorFlagByte6: _random.nextDouble() > 0.95 ? _random.nextInt(64) : 0,
      lifeSignal: _random.nextInt(256),
      instance: instance,
      timestamp: timestamp,
    );
  }

  MpptModel _generateMPPTData(int timestamp) {
    return MpptModel(
      pvVoltage: _randomDouble(60.0, 120.0),
      pvCurrent: _randomDouble(0.0, 20.0),
      batteryVoltage: _randomDouble(48.0, 58.0),
      batteryCurrent: _randomDouble(0.0, 15.0),
      timestamp: timestamp,
    );
  }

  InstrumentationModel _generateInstrumentationData(int timestamp) {
    return InstrumentationModel(
      batteryCurrent: _randomDouble(-40.0, 40.0),
      batteryVoltage: _randomDouble(48.0, 58.0),
      motorCurrentLeft: _randomDouble(0.0, 50.0),
      motorCurrentRight: _randomDouble(0.0, 50.0),
      mpptCurrent: _randomDouble(0.0, 30.0),
      panelStrings: List.generate(4, (_) => _randomDouble(0.0, 10.0)),
      auxBatteryCurrent: _randomDouble(0.0, 5.0),
      auxBatteryVoltage: _randomDouble(11.0, 14.5),
      irradiance: _random.nextInt(1200),
      timestamp: timestamp,
    );
  }

  GpsModel _generateGPSData(int timestamp) {
    return GpsModel(
      latitude: _randomDouble(-22.95, -22.85),
      longitude: _randomDouble(-43.15, -43.05),
      speed: _randomDouble(0.0, 15.0),
      course: _random.nextInt(360),
      heading: _random.nextInt(360),
      visibleSatellites: 4 + _random.nextInt(16),
      hdop: _randomDouble(0.5, 3.0),
      timestamp: timestamp,
    );
  }

  TemperatureModel _generateTemperatureData(int timestamp) {
    return TemperatureModel(
      temperatureBatteryLeft: _randomDouble(25.0, 45.0),
      temperatureBatteryRight: _randomDouble(25.0, 45.0),
      temperatureMPPTLeft: _randomDouble(30.0, 60.0),
      temperatureMPPTRight: _randomDouble(30.0, 60.0),
      temperatureMotorLeft: _randomDouble(35.0, 85.0),
      temperatureMotorRight: _randomDouble(35.0, 85.0),
      temperatureESCRLeft: _randomDouble(30.0, 70.0),
      temperatureESCRRight: _randomDouble(30.0, 70.0),
      temperatureMotorCoverLeft: _randomDouble(25.0, 50.0),
      temperatureMotorCoverRight: _randomDouble(25.0, 50.0),
      timestamp: timestamp,
    );
  }
}