import 'package:arari_next/domain/telemetry/iboat_data.dart';

enum PumpState {
  left,
  right
}

final class PumpData extends IBoatData {
  final PumpState state;

  PumpData(this.state, {required super.timestamp});

  factory PumpData.empty() {
    return PumpData(PumpState.left, timestamp: 0);
  }
}