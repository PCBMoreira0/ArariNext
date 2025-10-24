import 'dart:io';

import 'package:arari_next/data/services/logging_service_interface.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';

class LoggingServiceInflux implements ILoggingService {
  File? currentFile;
  IOSink? _sink;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  Future<void> openFile(String path, String fileName) async {
    Directory directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    currentFile = File(
      '${directory.path}/${fileName}_${DateTime.now().microsecondsSinceEpoch}.txt',
    );
    _sink = currentFile?.openWrite(mode: FileMode.append);
    _isOpen = true;
  }

  // Utilities
  String lineProtocolAddTag(String buffer, String key, String value) {
    buffer += "$key=$value,";
    return buffer;
  }

  String lineProtocolAddFieldDouble(String buffer, String key, double value) {
    buffer += "$key=$value,";
    return buffer;
  }

  String lineProtocolAddFieldInt(String buffer, String key, int value) {
    buffer += "$key=${value}i,";
    return buffer;
  }

  String lineProtocolAddTimestamp(String buffer) {
    buffer = buffer.substring(0, buffer.length - 1);
    buffer += " ${DateTime.now().millisecondsSinceEpoch}";
    return buffer;
  }

  String mavlinkEzkontrolItoLineProtocol(
    String buffer,
    MotorEletricalData data,
  ) {
    buffer = lineProtocolAddTag(buffer, "message", "motorEletricalData");
    buffer = lineProtocolAddTag(
      buffer,
      "instance",
      data.instance == MotorInstance.left ? "left" : "right",
    );
    buffer += " ";
    buffer = lineProtocolAddFieldDouble(buffer, "busVoltage", data.busVoltage);
    buffer = lineProtocolAddFieldDouble(buffer, "busCurrent", data.busCurrent);
    buffer = lineProtocolAddFieldInt(buffer, "rpm", data.rpm);
    buffer = lineProtocolAddFieldInt(
      buffer,
      "acceleratorOpening",
      data.acceleratorOpening,
    );
    buffer = lineProtocolAddTimestamp(buffer);
    return buffer;
  }

  String mavlinkEzkontrolIItoLineProtocol(
    String buffer,
    MotorStateData data,
  ) {
    buffer = lineProtocolAddTag(buffer, "message", "motorStateData");
    buffer = lineProtocolAddTag(
      buffer,
      "instance",
      data.instance == MotorInstance.left ? "left" : "right",
    );
    buffer += " ";
    buffer = lineProtocolAddFieldInt(
      buffer,
      "controllerTemperature",
      data.controllerTemperature,
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "motorTemperature",
      data.motorTemperature,
    );
    buffer = lineProtocolAddTimestamp(buffer);
    return buffer;
  }

  String mavlinkBMSToLineProtocol(String buffer, BMSData data) {
    buffer = lineProtocolAddTag(buffer, "message", "bms");
    buffer += " ";
    buffer = lineProtocolAddFieldDouble(
      buffer,
      "batteryCurrent",
      data.batteryCurrent,
    );
    buffer = lineProtocolAddFieldDouble(
      buffer,
      "stateOfCharge",
      data.stateOfCharge,
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "temperature1",
      data.temperatures[0],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "temperature2",
      data.temperatures[1],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell1",
      data.cellsVoltagesMillivolts[0],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell2",
      data.cellsVoltagesMillivolts[1],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell3",
      data.cellsVoltagesMillivolts[2],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell4",
      data.cellsVoltagesMillivolts[3],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell5",
      data.cellsVoltagesMillivolts[4],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell6",
      data.cellsVoltagesMillivolts[5],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell7",
      data.cellsVoltagesMillivolts[6],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell8",
      data.cellsVoltagesMillivolts[7],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell9",
      data.cellsVoltagesMillivolts[8],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell10",
      data.cellsVoltagesMillivolts[9],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell11",
      data.cellsVoltagesMillivolts[10],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell12",
      data.cellsVoltagesMillivolts[11],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell13",
      data.cellsVoltagesMillivolts[12],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell14",
      data.cellsVoltagesMillivolts[13],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell15",
      data.cellsVoltagesMillivolts[14],
    );
    buffer = lineProtocolAddFieldInt(
      buffer,
      "voltageCell16",
      data.cellsVoltagesMillivolts[15],
    );
    buffer = lineProtocolAddTimestamp(buffer);
    return buffer;
  }

  String mavlinkGPSToLineProtocol(String buffer, GPSData data){
    buffer = lineProtocolAddTag(buffer, "message", "gps");
    buffer += " ";
    buffer = lineProtocolAddFieldDouble(buffer, "speed", data.speed);
    buffer = lineProtocolAddFieldDouble(buffer, "latitude", data.latitude);
    buffer = lineProtocolAddFieldDouble(buffer, "longitude", data.longitude);
    buffer = lineProtocolAddTimestamp(buffer);
    return buffer;
  }

  String mavlinkInstrumentationToLineProtocol(String buffer, InstrumentationData data){
    buffer = lineProtocolAddTag(buffer, "message", "instrumentation");
    buffer += " ";
    buffer = lineProtocolAddFieldDouble(buffer, "batteryCurrent", data.batteryCurrent);
    buffer = lineProtocolAddFieldDouble(buffer, "batteryVoltage", data.batteryVoltage);
    buffer = lineProtocolAddFieldDouble(buffer, "batteryVoltage", data.batteryVoltage);
    buffer = lineProtocolAddFieldDouble(buffer, "motorCurrentLeft", data.motorCurrentLeft);
    buffer = lineProtocolAddFieldDouble(buffer, "motorCurrentRight", data.motorCurrentRight);
    buffer = lineProtocolAddFieldDouble(buffer, "mpptCurrent", data.mpptCurrent);
    buffer = lineProtocolAddFieldDouble(buffer, "mppt_string1", data.panelStrings.string1);
    buffer = lineProtocolAddFieldDouble(buffer, "mppt_string2", data.panelStrings.string2);
    buffer = lineProtocolAddFieldDouble(buffer, "mppt_string3", data.panelStrings.string3);
    buffer = lineProtocolAddFieldDouble(buffer, "mppt_string4", data.panelStrings.string4);
    buffer = lineProtocolAddTimestamp(buffer);
    return buffer;
  }

  @override
  Future<void> save(IBoatData? data) async {
    if (data == null) return;

    String buffer = "Yonah,";
    switch (data) {
      case MotorEletricalData motor:
        buffer = mavlinkEzkontrolItoLineProtocol(buffer, motor);
        break;
      case MotorStateData motorStateData:
        buffer = mavlinkEzkontrolIItoLineProtocol(buffer, motorStateData);
        break;
      case BMSData bms:
        buffer = mavlinkBMSToLineProtocol(buffer, bms);
        break;
      case InstrumentationData inst:
        buffer = mavlinkInstrumentationToLineProtocol(buffer, inst);
        break;
      case GPSData gps:
        buffer = mavlinkGPSToLineProtocol(buffer, gps);
        break;
      default:
        return;
    }

    _sink?.writeln(buffer);
    await _sink?.flush();
  }

  Future<void> close() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _isOpen = false;
  }
}
