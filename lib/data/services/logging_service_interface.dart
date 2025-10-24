import 'package:arari_next/domain/models/iboat_data.dart';

abstract interface class ILoggingService {
  void save(IBoatData data);
}