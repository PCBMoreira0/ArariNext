import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/domain/telemetry/motor_state_model.dart';

class MotorModel {
  final MotorEletricalModel? eletrical;
  final MotorStateModel? state;
  final MotorInstance instance;

  const MotorModel({this.eletrical, this.state, required this.instance});

  factory MotorModel.empty(MotorInstance instance) {
    return MotorModel(
      eletrical: MotorEletricalModel.empty(),
      state: MotorStateModel.empty(),
      instance: instance,
    );
  }

  MotorModel copyWith({
    MotorEletricalModel? eletrical,
    MotorStateModel? state,
    MotorInstance? instance,
  }) {
    return MotorModel(
      eletrical: eletrical ?? this.eletrical,
      state: state ?? this.state,
      instance: instance ?? this.instance,
    );
  }
}
