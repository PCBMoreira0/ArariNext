import 'package:arari_next/domain/models/iboat_data.dart';

final class BMSData implements IBoatData{
  final List<int> cellsVoltagesMillivolts;
  final List<int> temperatures;
  final double batteryCurrent;
  final int stateOfCharge;
  final double totalVoltage;

  BMSData({required List<int> voltagesMillivolts, required List<int> temperatures, required this.batteryCurrent, required this.stateOfCharge}) : cellsVoltagesMillivolts = List.unmodifiable(voltagesMillivolts), temperatures = List.unmodifiable(temperatures), totalVoltage = (voltagesMillivolts.fold(0, (previousValue, value) => previousValue + value) / 1000.0);  
  factory BMSData.empty() {
    return BMSData(voltagesMillivolts: List.empty(), temperatures: List.empty(), batteryCurrent: 0, stateOfCharge: 0);
  }
}