import 'package:arari_next/domain/models/iboat_data.dart';

enum PumpState {
  left,
  right
}

final class PumpData implements IBoatData {
  final PumpState state;

  PumpData(this.state);
}