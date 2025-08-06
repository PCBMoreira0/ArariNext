import 'package:arari_next/domain/models/iboat_data.dart';

enum RadioInstance {
  primary,
  secondary
}

final class RadioStatusData implements IBoatData {
  final int rxErrors;
  final RadioInstance instance;
  final int rssi;

  RadioStatusData({required this.rxErrors, required this.instance, required this.rssi});
}