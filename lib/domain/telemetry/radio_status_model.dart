import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

enum RadioInstance {
  primary,
  secondary
}

final class RadioStatusModel extends ITelemetryModel {
  final int rxErrors;
  final RadioInstance instance;
  final int rssi;

  RadioStatusModel({required this.rxErrors, required this.instance, required this.rssi, required super.timestamp});
  
  factory RadioStatusModel.empty(){
    return RadioStatusModel(rxErrors: 0, instance: RadioInstance.primary, rssi: 0, timestamp: 0);
  }
}