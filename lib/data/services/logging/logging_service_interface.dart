import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

abstract interface class ILoggingService {
  void save(ITelemetryModel data);
}