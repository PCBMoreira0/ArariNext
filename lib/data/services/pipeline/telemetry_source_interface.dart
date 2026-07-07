import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

abstract interface class ITelemetrySource {
  Stream<ITelemetryModel> get stream;

  void dispose() {}
}
