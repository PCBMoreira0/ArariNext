import 'package:arari_next/domain/telemetry/iboat_data.dart';

abstract interface class ILoggingService {
  void save(IBoatData data);
}