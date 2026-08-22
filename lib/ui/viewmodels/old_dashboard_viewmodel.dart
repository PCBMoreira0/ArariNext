import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:flutter/widgets.dart';

class OldDashboardViewmodel {
  final ITelemetryRepository _packetRepository;

  ValueNotifier<TelemetryModel> fullBoatDataValueNotifier = ValueNotifier(
    TelemetryModel.empty(),
  );

  OldDashboardViewmodel({required ITelemetryRepository repository})
    : _packetRepository = repository {
    _packetRepository.data.listen((data) => _processModel(data));
  }

  void _processModel(TelemetryModel? data) {
    if (data != null) {
      fullBoatDataValueNotifier.value = data;
    }
  }
}
