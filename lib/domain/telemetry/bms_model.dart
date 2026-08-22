import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

final class BmsModel extends ITelemetryModel{
  final List<int> cellsVoltagesMillivolts;
  final List<int> temperatures;
  final double batteryCurrent;
  final double stateOfCharge;
  final double totalVoltage;

  BmsModel({required List<int> voltagesMillivolts, required List<int> temperatures, required this.batteryCurrent, required this.stateOfCharge, required super.timestamp}) : cellsVoltagesMillivolts = List.unmodifiable(voltagesMillivolts), temperatures = List.unmodifiable(temperatures), totalVoltage = (voltagesMillivolts.fold(0, (previousValue, value) => previousValue + value) / 1000.0);  
  
  factory BmsModel.empty() {
    return BmsModel(voltagesMillivolts: List.empty(), temperatures: List.empty(), batteryCurrent: 0, stateOfCharge: 0, timestamp: 0);
  }
}