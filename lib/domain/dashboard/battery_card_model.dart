import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';

class BatteryCardModel extends CardModel {
  @override
  int get defaultW => 1;
  @override
  int get defaultH => 2;

  @override
  int get minH => 2;

  @override
  CardType get type => CardType.battery;

  const BatteryCardModel({required super.id});

  @override
  Map<String, dynamic> configToJson() {
    return {};
  }
}
