import 'dart:io';

import 'package:arari_next/data/services/logging_service_interface.dart';
import 'package:arari_next/domain/models/bms_data.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:arari_next/domain/models/instrumentation_data.dart';
import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/domain/models/motor_state_data.dart';
import 'package:arari_next/domain/models/mppt_data.dart';

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
  String lineProtocolAddTable(String buffer, String tableName) {
    buffer += tableName;
    return buffer;
  }

  String lineProtocolAddTag(
    String buffer,
    List<({String key, String value})> pair,
  ) {
    buffer += ",";

    int i;
    for (i = 0; i < pair.length - 1; i++) {
      buffer += "${pair[i].key}=${pair[i].value},";
    }
    buffer += "${pair[i].key}=${pair[i].value}";

    return buffer;
  }

  String lineProtocolAddField(
    String buffer,
    List<({String key, num value})> pair,
  ) {
    buffer += " ";

    int i;
    for (i = 0; i < pair.length - 1; i++) {
      if (pair[i].value is int) {
        buffer += "${pair[i].key}=${pair[i].value}i,";
      } else {
        buffer += "${pair[i].key}=${pair[i].value},";
      }
    }

    if (pair[i].value is int) {
      buffer += "${pair[i].key}=${pair[i].value}i";
    } else {
      buffer += "${pair[i].key}=${pair[i].value}";
    }

    return buffer;
  }

  String lineProtocolAddTimestamp(String buffer, int timestamp) {
    buffer += " $timestamp";
    return buffer;
  }

  String mavlinkEzkontrolItoLineProtocol(
    String buffer,
    MotorEletricalData data,
  ) {
    
    buffer = lineProtocolAddTable(buffer, "motorEletricalData");

    buffer = lineProtocolAddTag(buffer, 
    [
      (key: "instance", value: data.instance == MotorInstance.left ? "left" : "right")
    ]);
    
    buffer = lineProtocolAddField(buffer, 
    [
      (key: "busVoltage", value: data.busVoltage),
      (key: "busCurrent", value: data.busCurrent),
      (key: "rpm", value: data.rpm),
      (key: "acceleratorOpening", value: data.acceleratorOpening)
    ]);
    
    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  String mavlinkEzkontrolIItoLineProtocol(String buffer, MotorStateData data) {
    buffer = lineProtocolAddTable(buffer, "motorStateData");
    buffer = lineProtocolAddTag(buffer, 
    [
      (key: "instance", value: data.instance == MotorInstance.left ? "left" : "right")
    ]);
    
    buffer = lineProtocolAddField(buffer, 
    [
      (key: "controllerTemperature", value: data.controllerTemperature),
      (key: "motorTemperature", value: data.motorTemperature)
    ]);

    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  String mavlinkBMSToLineProtocol(String buffer, BMSData data) {
    buffer = lineProtocolAddTable(buffer, "bms");

    buffer = lineProtocolAddField(buffer, 
    [
      (key: "batteryCurrent", value: data.batteryCurrent),
      (key: "stateOfCharge", value: data.stateOfCharge),
      (key: "temperature1", value: data.temperatures[0]),
      (key: "temperature1", value: data.temperatures[1]),
      (key: "voltageCell1", value: data.cellsVoltagesMillivolts[0]),
      (key: "voltageCell2", value: data.cellsVoltagesMillivolts[1]),
      (key: "voltageCell3", value: data.cellsVoltagesMillivolts[2]),
      (key: "voltageCell4", value: data.cellsVoltagesMillivolts[3]),
      (key: "voltageCell5", value: data.cellsVoltagesMillivolts[4]),
      (key: "voltageCell6", value: data.cellsVoltagesMillivolts[5]),
      (key: "voltageCell7", value: data.cellsVoltagesMillivolts[6]),
      (key: "voltageCell8", value: data.cellsVoltagesMillivolts[7]),
      (key: "voltageCell9", value: data.cellsVoltagesMillivolts[8]),
      (key: "voltageCell10", value: data.cellsVoltagesMillivolts[9]),
      (key: "voltageCell11", value: data.cellsVoltagesMillivolts[10]),
      (key: "voltageCell12", value: data.cellsVoltagesMillivolts[11]),
      (key: "voltageCell13", value: data.cellsVoltagesMillivolts[12]),
      (key: "voltageCell14", value: data.cellsVoltagesMillivolts[13]),
      (key: "voltageCell15", value: data.cellsVoltagesMillivolts[14]),
      (key: "voltageCell16", value: data.cellsVoltagesMillivolts[15])
    ]);

    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  String mavlinkGPSToLineProtocol(String buffer, GPSData data) {
    buffer = lineProtocolAddTable(buffer, "gps");

    buffer = lineProtocolAddField(buffer, 
    [
      (key: "speed", value: data.speed),
      (key: "latitude", value: data.latitude),
      (key: "longitude",value: data.longitude)
    ]);

    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  String mavlinkInstrumentationToLineProtocol(
    String buffer,
    InstrumentationData data,
  ) {
    buffer = lineProtocolAddTable(buffer, "instrumentation");

    buffer = lineProtocolAddField(buffer, 
    [
      (key: "batteryCurrent", value: data.batteryCurrent),
      (key: "batteryVoltage", value: data.batteryVoltage),
      (key: "motorCurrentLeft", value: data.motorCurrentLeft),
      (key: "motorCurrentRight", value: data.motorCurrentRight),
      (key: "mpptCurrent", value: data.mpptCurrent),
      (key: "mppt_string1", value: data.panelStrings.string1),
      (key: "mppt_string2", value: data.panelStrings.string2),
      (key: "mppt_string3", value: data.panelStrings.string3),
      (key: "mppt_string4", value: data.panelStrings.string4)
    ]);

    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  String mavlinkMPPTToLineProtocol(String buffer, MPPTData data){
    buffer = lineProtocolAddTable(buffer, "mppt");
    
    buffer = lineProtocolAddField(buffer, 
    [
      (key: "pvVoltage", value: data.pvVoltage),
      (key: "pvCurrent", value: data.pvCurrent),
      (key: "batteryVoltage", value: data.batteryVoltage),
      (key: "batteryCurrent", value: data.batteryCurrent),
      (key: "mpptCurrent", value: data.mpptCurrent)
    ]);

    buffer = lineProtocolAddTimestamp(buffer, data.timestamp);

    return buffer;
  }

  @override
  Future<void> save(IBoatData? data) async {
    if (data == null) return;
    
    String buffer = '';

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
  }

  Future<void> close() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _isOpen = false;
  }
}
