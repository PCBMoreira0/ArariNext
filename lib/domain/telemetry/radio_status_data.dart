import 'package:arari_next/domain/telemetry/iboat_data.dart';

enum RadioInstance {
  primary,
  secondary
}

final class RadioStatusData extends IBoatData {
  final int rxErrors;
  final RadioInstance instance;
  final int rssi;

  RadioStatusData({required this.rxErrors, required this.instance, required this.rssi, required super.timestamp});
  
  factory RadioStatusData.empty(){
    return RadioStatusData(rxErrors: 0, instance: RadioInstance.primary, rssi: 0, timestamp: 0);
  }
}