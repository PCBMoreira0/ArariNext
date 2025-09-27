import 'dart:async';

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

abstract class PacketRepository {
  Stream<BMSData> get bmsData;
  Stream<BMSStatusData> get bmsStatusData;
  Stream<GPSData> get gpsData;
  Stream<InstrumentationData> get instrumentationData;
  Stream<MotorEletricalData> get motorEletricalData;
  Stream<MotorStateData> get motorStateData;
  Stream<MPPTData> get mpptData;
  Stream<MPPTStateData> get mpptStateData;
  Stream<PumpData> get pumpData;
  Stream<RadioStatusData> get radioStatusData;
  Stream<TemperatureData> get temperatureData;
}