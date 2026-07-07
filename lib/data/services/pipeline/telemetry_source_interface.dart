import 'package:arari_next/domain/telemetry/iboat_data.dart';

abstract interface class ITelemetrySource {
  Stream<IBoatData> get stream;

  void dispose() {}
}
