import 'package:arari_next/domain/models/iboat_data.dart';

enum MpptBatteryStatus {
  normal,
  overvoltage,
  undervoltage,
  lowVoltageDisconnect,
  fault,
  unknown
}

final class MPPTStateData implements IBoatData {
  final int batteryStatus;
  final int chargingEquipmentStatus;

  MPPTStateData({required this.batteryStatus, required this.chargingEquipmentStatus});


  // MpptBatteryStatus _getStatus(int status){
  //   switch (status & 15) {
  //     case 0:
  //       return MpptBatteryStatus.normal;
  //     case 
  //     default:
  //   }
  // }
}