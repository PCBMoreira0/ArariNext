import 'package:arari_next/domain/models/iboat_data.dart';

enum PumpState {
  on,
  off
}

final class PumpData implements IBoatData {
  final PumpState state;

  PumpData(this.state);
}