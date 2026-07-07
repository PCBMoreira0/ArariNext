import 'dart:async';

import 'package:arari_next/domain/telemetry/telemetry_model.dart';

abstract class ITelemetryRepository {
  Stream<TelemetryModel?> get data;
  void dispose() {}
}
