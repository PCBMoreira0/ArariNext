import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:flutter/widgets.dart';

class OldDashboardViewmodel {
  final PacketRepository _packetRepository;

  ValueNotifier<FullBoatData> fullBoatDataValueNotifier = ValueNotifier(
    FullBoatData.empty(),
  );

  OldDashboardViewmodel({required PacketRepository repository})
    : _packetRepository = repository {
    _packetRepository.data.listen((data) => _processModel(data));
  }

  void _processModel(FullBoatData? data) {
    if (data != null) {
      fullBoatDataValueNotifier.value = data;
    }
  }
}
