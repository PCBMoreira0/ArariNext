import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:flutter/material.dart';

class BatteryCardViewmodel {
  final ValueNotifier<FullBoatData> fullBoatDataValueNotifier = ValueNotifier(
    FullBoatData.empty(),
  );

  final PacketRepository packetRepository;

  BatteryCardViewmodel({required this.packetRepository}) {
    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    fullBoatDataValueNotifier.value = newData;
  }
}
