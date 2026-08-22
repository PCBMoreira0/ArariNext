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

class MockSerialDatasource implements ISerialDatasource {
  final StreamController<Uint8List> _outputStreamController =
      StreamController<Uint8List>.broadcast();
  final StreamController<ConnectionEvent> _statusController =
      StreamController<ConnectionEvent>.broadcast();

  Timer? _timer;
  int _sequence = 0;
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  // ==========================================
  // Estado da Simulação (Coerência Temporal)
  // ==========================================
  int _tick = 0;
  double _batterySoc = 98.0; // Começa em 98% e diminui progressivamente
  double _latitude = -22.9068;
  double _longitude = -43.1729;
  final double _heading = 45.0; // Navegando para o Nordeste (graus)

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
  Future<void> connect() async {
    if (_currentStatus == ConnectionStatus.connected) return;

    _updateStatus(ConnectionStatus.connecting);
    _updateStatus(ConnectionStatus.connected);
    _startGeneratingData();
  }

  @override
  Future<void> disconnect() async {
    _stopGeneratingData();
    _updateStatus(ConnectionStatus.disconnected);
  }

  @override
  Future<void> dispose() async {
    disconnect();
    await _outputStreamController.close();
    await _statusController.close();
  }

  @override
  List<String> availablePorts() {
    return ['COM1', 'COM2', 'COM3', 'COM4', 'COM5'];
  }

  @override
  Future<void> setConfig(SerialSettings config) async {
    debugPrint(
      'MockSerialDatasource: setConfig called with port: ${config.port}, baudrate: ${config.baudrate}',
    );
  }

  void _startGeneratingData() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (_outputStreamController.isClosed) return;

      _tick++;
      _updateSimulationState();

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

  // ==========================================
  // Atualização do Estado Coerente
  // ==========================================
  void _updateSimulationState() {
    // Descarga contínua da bateria (0.05% a cada segundo, trava em 10%)
    if (_batterySoc > 10.0) {
      _batterySoc -= 0.05;
    }

    // Deslocamento suave do GPS com base na velocidade de cruzeiro
    const double speedDegPerSec = 0.00002;
    final double rad = _heading * (pi / 180.0);
    _latitude += speedDegPerSec * cos(rad);
    _longitude += speedDegPerSec * sin(rad);
  }

  // Funções auxiliares para valores correlacionados
  double get _currentThrottle => 60.0 + 5.0 * sin(_tick * 0.1); // 55% a 65%
  double get _currentRpm => _currentThrottle * 28.0; // ~1540 a 1820 RPM
  double get _currentSpeed => _currentThrottle * 4.5; // ~250 a 290 cm/s
  double get _currentMotorAmp =>
      _currentThrottle * 0.35; // ~19A a 22A por motor
  double get _currentBatteryVoltage =>
      48.0 + ((_batterySoc - 10.0) / 90.0) * 8.0; // 48V a 56V

  // ==========================================
  // Geradores das mensagens MAVLink (Arariboat)
  // ==========================================

  Instrumentation _generateInstrumentation(int timestampSec, int timestampMs) {
    final double motorCurrentTotal = _currentMotorAmp * 2;
    final double mpptCurrent = 12.0 + 1.5 * sin(_tick * 0.05);
    final double netBatteryCurrent = mpptCurrent - motorCurrentTotal;

    return Instrumentation(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      batteryCurrent: (netBatteryCurrent * 10).toInt(), // dA
      motorCurrentLeft: (_currentMotorAmp * 10).toInt(),
      motorCurrentRight: (_currentMotorAmp * 10).toInt(),
      mpptCurrent: (mpptCurrent * 10).toInt(),
      panelStrings: List.generate(
        4,
        (index) => (3.0 * 1000).toInt(),
      ), // 3A por string
      auxiliaryBatteryCurrent: 12, // 1.2A constante
      batteryVoltage: (_currentBatteryVoltage * 100).toInt(), // cV
      auxiliaryBatteryVoltage: 1260, // 12.60V estável
      irradiance: (850 + 20 * sin(_tick * 0.05)).toInt(), // ~850 W/m² estável
    );
  }

  Temperatures _generateTemperatures(int timestampSec, int timestampMs) {
    // Temperaturas sobem levemente e estabilizam
    final double drift = 2.0 * sin(_tick * 0.02);

    return Temperatures(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      temperatureBatteryLeft: ((32.0 + drift) * 100).toInt(),
      temperatureBatteryRight: ((32.5 + drift) * 100).toInt(),
      temperatureMpptLeft: ((41.0 + drift) * 100).toInt(),
      temperatureMpptRight: ((40.5 + drift) * 100).toInt(),
      temperatureMotorLeft: ((52.0 + drift * 1.5) * 100).toInt(),
      temperatureMotorRight: ((53.0 + drift * 1.5) * 100).toInt(),
      temperatureEscLeft: ((45.0 + drift) * 100).toInt(),
      temperatureEscRight: ((44.5 + drift) * 100).toInt(),
      temperatureMotorCoverLeft: ((30.0 + drift * 0.5) * 100).toInt(),
      temperatureMotorCoverRight: ((30.0 + drift * 0.5) * 100).toInt(),
    );
  }

  Gps _generateGps(int timestampSec, int timestampMs) {
    return Gps(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      latitude: (_latitude * 1e7).toInt(),
      longitude: (_longitude * 1e7).toInt(),
      speed: _currentSpeed.toInt(), // cm/s
      course: _heading.toInt(),
      heading: _heading.toInt(),
      satellitesVisible: 12, // Estável em 12 satélites
      hdop: 1, // HDOP excelente e fixo
    );
  }

  Bms _generateBms(int timestampSec, int timestampMs) {
    final int cellVoltageMv = ((_currentBatteryVoltage / 16.0) * 1000).toInt();

    return Bms(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      voltages: List.generate(
        16,
        (_) => cellVoltageMv,
      ), // 16 células balanceadas
      temperatures: [32, 33], // 32.0°C e 33°C em cdegC
      currentBattery: ((12.0 - (_currentMotorAmp * 2)) * 10).toInt(), // dA
      stateOfCharge: _batterySoc.toInt() * 10, // % [10-100] decrescente
    );
  }

  BmsStatus _generateBmsStatus(int timestampSec, int timestampMs) {
    return BmsStatus(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      temperatures: [3200, 3250],
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
      busVoltage: (_currentBatteryVoltage * 10).toInt(), // dV (0.1V/bit)
      busCurrent: (_currentMotorAmp * 10).toInt(), // dA
      rpm: _currentRpm.toInt(),
      acceleratorOpening: _currentThrottle.toInt(), // %
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
      controllerTemperature: 45 + 40, // 45°C + offset de 40
      motorTemperature: 52 + 40, // 52°C + offset de 40
      status: ezkontrolGearD1 | (ezkontrolOpModeDrive << 4),
      errorFlagsByte4: 0,
      errorFlagsByte5: 0,
      errorFlagsByte6: 0,
      lifeSignal: (_tick % 256), // Contador progressivo real
      instance: instance,
    );
  }

  Mppt _generateMppt(int timestampSec, int timestampMs) {
    final double mpptAmp = 12.0 + 1.5 * sin(_tick * 0.05);

    return Mppt(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      pvVoltage: 7800, // 78.00V cV (tensão dos painéis estável)
      pvCurrent: ((mpptAmp * _currentBatteryVoltage / 78.0) * 100)
          .toInt(), // cA conservação de energia
      batteryVoltage: (_currentBatteryVoltage * 100).toInt(),
      batteryCurrent: (mpptAmp * 100).toInt(), // cA
    );
  }

  Pumps _generatePumps(int timestampSec, int timestampMs) {
    return Pumps(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      pumpStates: 1, // Bomba 1 ligada de forma constante
    );
  }

  RadioStatus _generateRadioStatus(int timestampSec, int timestampMs) {
    return RadioStatus(
      timestampSeconds: timestampSec,
      timestampMilliseconds: timestampMs,
      rxerrors: 0,
      instance: 0,
      rssi: 210, // Sinal de rádio forte e estável
    );
  }
}
