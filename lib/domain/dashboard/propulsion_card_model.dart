import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';

class PropulsionCardModel extends CardModel {
  final MotorInstance selectedInstance;

  @override
  int get defaultW => 2;
  @override
  int get defaultH => 2;
  @override
  int get minH => 2;
  @override
  int get minW => 2;

  @override
  CardType get type => CardType.propulsion;

  const PropulsionCardModel({
    required super.id,
    required this.selectedInstance,
  });

  @override
  Map<String, dynamic> configToJson() {
    return {'selectedInstance': selectedInstance.name};
  }

  PropulsionCardModel copyWith({String? id, MotorInstance? selectedInstance}) {
    return PropulsionCardModel(
      id: id ?? this.id,
      selectedInstance: selectedInstance ?? this.selectedInstance,
    );
  }
}
