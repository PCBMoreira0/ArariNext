import 'package:arari_next/domain/models/iboat_data.dart';

final class BMSData implements IBoatData{
  final List<double> voltages;
  final List<double> temperatures;
  final double batteryCurrent;
  final double stateOfCharge;
  final double totalVoltage;

  BMSData({required List<double> voltages, required List<double> temperatures, required this.batteryCurrent, required this.stateOfCharge}) : voltages = List.unmodifiable(voltages), temperatures = List.unmodifiable(temperatures), totalVoltage = voltages.fold(0, (previousValue, value) => previousValue + value);
}