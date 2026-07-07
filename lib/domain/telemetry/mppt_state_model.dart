import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

enum MpptBatteryStatus {
  normal,
  overvoltage,
  undervoltage,
  lowVoltageDisconnect,
  fault,
  unknown
}

final class MPPTStateData extends ITelemetryModel {
  final int batteryStatus;
  final int chargingEquipmentStatus;

  MPPTStateData({required this.batteryStatus, required this.chargingEquipmentStatus, required super.timestamp});


  // MpptBatteryStatus _getStatus(int status){
  //   switch (status & 15) {
  //     case 0:
  //       return MpptBatteryStatus.normal;
  //     case 
  //     default:
  //   }
  // }
}