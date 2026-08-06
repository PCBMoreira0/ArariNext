import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:arari_next/data/services/datasource/connection_event.dart';
import 'package:arari_next/data/services/datasource/serial_datasource_interface.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:dart_mavlink/mavlink_frame.dart';
import 'package:dart_mavlink/mavlink_message.dart';
import 'package:flutter/material.dart';

class MockSerialDatasourceRandom implements ISerialDatasource {
  final StreamController<Uint8List> _outputStreamController =
      StreamController<Uint8List>.broadcast();
  final StreamController<ConnectionEvent> _statusController =
      StreamController<ConnectionEvent>.broadcast();

  final Random _random = Random();

  Timer? _timer;
  int _sequence = 0;
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  @override
  Stream<Uint8List> get stream => _outputStreamController.stream;

  @override
  Stream<ConnectionEvent> get statusStream => _statusController.stream;

  @override
  ConnectionStatus get status => _currentStatus;

  void _updateStatus(ConnectionStatus status) {
    _currentStatus = status;
    if (!_statusController.isClosed) {
      _statusController.add(ConnectionEvent(ConnectionType.serial, status));
    }
  }

  @override
  void connect() {
    if (_currentStatus == ConnectionStatus.connected) return;

    _updateStatus(ConnectionStatus.connecting);

    _updateStatus(ConnectionStatus.connected);
    _startGeneratingData();
  }

  @override
  void disconnect() {
    _stopGeneratingData();
    _updateStatus(ConnectionStatus.disconnected);
  }

  @override
  void dispose() {
    disconnect();
    _outputStreamController.close();
    _statusController.close();
  }

  @override
  List<String> availablePorts() {
    return ['COM1', 'COM2', 'COM3', 'COM4', 'COM5'];
  }

  @override
  void setConfig(SerialSettings config) {
    debugPrint(
      'MockSerialDatasource: setConfig called with port: ${config.port}, baudrate: ${config.baudrate}',
    );
  }

  void _startGeneratingData() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (_outputStreamController.isClosed) return;

      final now = DateTime.now();
      final timestampSeconds = (now.millisecondsSinceEpoch ~/ 1000);
      final timestampMilliseconds = (now.millisecondsSinceEpoch % 1000);

      _sendMavlinkMessage(
        _generateInstrumentation(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateTemperatures(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateGps(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateBms(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateBmsStatus(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateMotorI(timestampSeconds, timestampMilliseconds, 0),
      ); // Motor Esquerdo
      _sendMavlinkMessage(
        _generateMotorI(timestampSeconds, timestampMilliseconds, 1),
      ); // Motor Direito
      _sendMavlinkMessage(
        _generateMotorIi(timestampSeconds, timestampMilliseconds, 0),
      );
      _sendMavlinkMessage(
        _generateMotorIi(timestampSeconds, timestampMilliseconds, 1),
      );
      _sendMavlinkMessage(
        _generateMppt(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generatePumps(timestampSeconds, timestampMilliseconds),
      );
      _sendMavlinkMessage(
        _generateRadioStatus(timestampSeconds, timestampMilliseconds),
      );
    });
  }

  void _stopGeneratingData() {
    _timer?.cancel();
    _timer = null;
  }

  void _sendMavlinkMessage(MavlinkMessage message) {
    final frame = MavlinkFrame.v1(
      _sequence = (_sequence + 1) % 256,
      1,
      1,
      message,
    );

    final Uint8List bytes = frame.serialize().buffer.asUint8List();
    _outputStreamController.add(bytes);
  }

  double _randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  // ==========================================
  // Geradores das mensagens MAVLink (Arariboat)
  // ==========================================

  Instrumentation _generateInstrumentation(int timestampSec, int timestampMs) {
    return Instrumentation(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      batteryCurrent: (_randomDouble(-40.0, 40.0) * 10).toInt(),
      motorCurrentLeft: (_randomDouble(0.0, 50.0) * 10).toInt(),
      motorCurrentRight: (_randomDouble(0.0, 50.0) * 10).toInt(),
      mpptCurrent: (_randomDouble(0.0, 30.0) * 10).toInt(),
      panelStrings: List.generate(
        4,
        (_) => (_randomDouble(0.0, 10.0) * 1000).toInt(),
      ),
      auxiliaryBatteryCurrent: (_randomDouble(0.0, 5.0) * 10).toInt(),
      batteryVoltage: (_randomDouble(48.0, 58.0) * 100).toInt(),
      auxiliaryBatteryVoltage: (_randomDouble(11.0, 14.5) * 100).toInt(),
      irradiance: _random.nextInt(1200),
    );
  }

  Temperatures _generateTemperatures(int timestampSec, int timestampMs) {
    return Temperatures(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      temperatureBatteryLeft: (_randomDouble(25.0, 45.0) * 100).toInt(),
      temperatureBatteryRight: (_randomDouble(25.0, 45.0) * 100).toInt(),
      temperatureMpptLeft: (_randomDouble(30.0, 60.0) * 100).toInt(),
      temperatureMpptRight: (_randomDouble(30.0, 60.0) * 100).toInt(),
      temperatureMotorLeft: (_randomDouble(35.0, 85.0) * 100).toInt(),
      temperatureMotorRight: (_randomDouble(35.0, 85.0) * 100).toInt(),
      temperatureEscLeft: (_randomDouble(30.0, 70.0) * 100).toInt(),
      temperatureEscRight: (_randomDouble(30.0, 70.0) * 100).toInt(),
      temperatureMotorCoverLeft: (_randomDouble(25.0, 50.0) * 100).toInt(),
      temperatureMotorCoverRight: (_randomDouble(25.0, 50.0) * 100).toInt(),
    );
  }

  Gps _generateGps(int timestampSec, int timestampMs) {
    return Gps(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      latitude: (_randomDouble(-22.95, -22.85) * 1e7).toInt(),
      longitude: (_randomDouble(-43.15, -43.05) * 1e7).toInt(),
      speed: (_randomDouble(0.0, 500.0)).toInt(), // cm/s
      course: _random.nextInt(360),
      heading: _random.nextInt(360),
      satellitesVisible: 4 + _random.nextInt(16),
      hdop: _random.nextInt(5) + 1,
    );
  }

  Bms _generateBms(int timestampSec, int timestampMs) {
    return Bms(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      voltages: List.generate(16, (_) => 3200 + _random.nextInt(400)), // mV
      temperatures: List.generate(
        2,
        (_) => (25 + _random.nextInt(20)) * 100,
      ), // cdegC
      currentBattery: (_randomDouble(-50.0, 50.0) * 10).toInt(), // dA
      stateOfCharge: _random.nextInt(91) + 10, // % [10-100]
    );
  }

  BmsStatus _generateBmsStatus(int timestampSec, int timestampMs) {
    return BmsStatus(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      temperatures: List.generate(2, (_) => (25 + _random.nextInt(20)) * 100),
      status: chargeDischargeStateDischarging | chargeDischargeDischargeMosOn,
      failureFlagsByte0: 0,
      failureFlagsByte1: 0,
      failureFlagsByte2: 0,
      failureFlagsByte3: 0,
      failureFlagsByte4: 0,
      failureFlagsByte5: 0,
      failureFlagsByte6: 0,
      faultCodeByte7: 0,
    );
  }

  EzkontrolMcuMeterDataI _generateMotorI(
    int timestampSec,
    int timestampMs,
    int instance,
  ) {
    return EzkontrolMcuMeterDataI(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      busVoltage: (_randomDouble(45.0, 58.0) * 10).toInt(), // dV (0.1V/bit)
      busCurrent: (_randomDouble(0.0, 100.0) * 10).toInt(), // dA
      rpm: _random.nextInt(3000),
      acceleratorOpening: _random.nextInt(101), // %
      instance: instance,
    );
  }

  EzkontrolMcuMeterDataIi _generateMotorIi(
    int timestampSec,
    int timestampMs,
    int instance,
  ) {
    return EzkontrolMcuMeterDataIi(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      controllerTemperature:
          30 + _random.nextInt(40) + 40, // offset -40 -> envia com +40
      motorTemperature: 30 + _random.nextInt(50) + 40,
      status: ezkontrolGearD1 | (ezkontrolOpModeDrive << 4),
      errorFlagsByte4: 0,
      errorFlagsByte5: 0,
      errorFlagsByte6: 0,
      lifeSignal: _random.nextInt(256),
      instance: instance,
    );
  }

  Mppt _generateMppt(int timestampSec, int timestampMs) {
    return Mppt(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      pvVoltage: (_randomDouble(60.0, 120.0) * 100).toInt(), // cV
      pvCurrent: (_randomDouble(0.0, 20.0) * 100).toInt(), // cA
      batteryVoltage: (_randomDouble(48.0, 58.0) * 100).toInt(),
      batteryCurrent: (_randomDouble(0.0, 15.0) * 100).toInt(),
    );
  }

  Pumps _generatePumps(int timestampSec, int timestampMs) {
    return Pumps(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      pumpStates: _random.nextInt(4), // Bit 0 e 1
    );
  }

  RadioStatus _generateRadioStatus(int timestampSec, int timestampMs) {
    return RadioStatus(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      rxerrors: _random.nextInt(5),
      instance: 0,
      rssi: 180 + _random.nextInt(70), // [0-254]
    );
  }
}
