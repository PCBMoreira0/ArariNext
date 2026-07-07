import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/domain/telemetry/motor_state_data.dart';

class MotorData {
  final MotorEletricalData? eletrical;
  final MotorStateData? state;
  final MotorInstance instance;

  const MotorData({this.eletrical, this.state, required this.instance});

  factory MotorData.empty(MotorInstance instance) {
    return MotorData(
      eletrical: MotorEletricalData.empty(),
      state: MotorStateData.empty(),
      instance: instance,
    );
  }

  MotorData copyWith({
    MotorEletricalData? eletrical,
    MotorStateData? state,
    MotorInstance? instance,
  }) {
    return MotorData(
      eletrical: eletrical ?? this.eletrical,
      state: state ?? this.state,
      instance: instance ?? this.instance,
    );
  }
}
