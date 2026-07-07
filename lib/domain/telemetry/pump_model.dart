import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

enum PumpState {
  left,
  right
}

final class PumpModel extends ITelemetryModel {
  final PumpState state;

  PumpModel(this.state, {required super.timestamp});

  factory PumpModel.empty() {
    return PumpModel(PumpState.left, timestamp: 0);
  }
}