import 'dart:async';
import 'dart:math';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/telemetry/bms_data.dart';
import 'package:arari_next/domain/telemetry/gps_data.dart';
import 'package:arari_next/domain/telemetry/instrumentation_data.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/domain/telemetry/motor_state_data.dart';
import 'package:arari_next/domain/telemetry/mppt_data.dart';
import 'package:arari_next/domain/telemetry/pump_data.dart';
import 'package:arari_next/domain/telemetry/radio_status_data.dart';
import 'package:arari_next/domain/telemetry/temperature_data.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';

class MockPacketRepository implements PacketRepository {
  final StreamController<FullBoatData?> _streamController = StreamController.broadcast();
  final Random _random = Random();
  Timer? _timer;

  @override
  Stream<FullBoatData?> get data => _streamController.stream;

  MockPacketRepository() {
    _startGeneratingData();
  }

  void _startGeneratingData() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _streamController.add(_generateMockFullBoatData());
    });
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }

  double _randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  FullBoatData _generateMockFullBoatData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return FullBoatData(
      bmsData: _generateBMSData(timestamp),
      motorEletricalDataLeft: _generateMotorEletricalData(MotorInstance.left, timestamp),
      motorStateDataLeft: _generateMotorStateData(MotorInstance.left, timestamp),
      motorEletricalDataRight: _generateMotorEletricalData(MotorInstance.right, timestamp),
      motorStateDataRight: _generateMotorStateData(MotorInstance.right, timestamp),
      mpptData: _generateMPPTData(timestamp),
      instrumentationData: _generateInstrumentationData(timestamp),
      gpsData: _generateGPSData(timestamp),
      temperatureData: _generateTemperatureData(timestamp),
      pumpData: PumpData.empty(), 
      radioStatusData: RadioStatusData.empty(), 
    );
  }

  BMSData _generateBMSData(int timestamp) {
    return BMSData(
      voltagesMillivolts: List.generate(14, (_) => 3200 + _random.nextInt(400)),
      temperatures: List.generate(4, (_) => 20 + _random.nextInt(25)),
      batteryCurrent: _randomDouble(-50.0, 50.0),
      stateOfCharge: _randomDouble(10.0, 100.0),
      timestamp: timestamp,
    );
  }

  MotorEletricalData _generateMotorEletricalData(MotorInstance instance, int timestamp) {
    return MotorEletricalData(
      busVoltage: _randomDouble(45.0, 58.0),
      busCurrent: _randomDouble(0.0, 100.0),
      rpm: _random.nextInt(3000),
      acceleratorOpening: _random.nextInt(101),
      instance: instance,
      timestamp: timestamp,
    );
  }

  MotorStateData _generateMotorStateData(MotorInstance instance, int timestamp) {
    return MotorStateData(
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

  MPPTData _generateMPPTData(int timestamp) {
    return MPPTData(
      pvVoltage: _randomDouble(60.0, 120.0),
      pvCurrent: _randomDouble(0.0, 20.0),
      batteryVoltage: _randomDouble(48.0, 58.0),
      batteryCurrent: _randomDouble(0.0, 15.0),
      timestamp: timestamp,
    );
  }

  InstrumentationData _generateInstrumentationData(int timestamp) {
    return InstrumentationData(
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

  GPSData _generateGPSData(int timestamp) {
    return GPSData(
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

  TemperatureData _generateTemperatureData(int timestamp) {
    return TemperatureData(
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