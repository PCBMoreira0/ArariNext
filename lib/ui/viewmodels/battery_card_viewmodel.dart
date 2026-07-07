import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:flutter/material.dart';

class BatteryCardViewmodel {
  final ValueNotifier<TelemetryModel> fullBoatDataValueNotifier = ValueNotifier(
    TelemetryModel.empty(),
  );

  final ITelemetryRepository packetRepository;

  BatteryCardViewmodel({required this.packetRepository}) {
    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  void onNewDataReceived(TelemetryModel? newData) {
    if (newData == null) return;
    fullBoatDataValueNotifier.value = newData;
  }
}
