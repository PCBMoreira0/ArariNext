import 'package:arari_next/domain/models/iboat_data.dart';

final class MPPTStateData implements IBoatData {
  final int batteryStatus;
  final int chargingEquipmentStatus;

  MPPTStateData({required this.batteryStatus, required this.chargingEquipmentStatus});
}