import 'package:arari_next/domain/dashboard/card_type.dart';

abstract class CardModel {
  final String id;
  CardType get type;

  int get defaultW => 1;
  int get defaultH => 1;
  int get minW => 1;
  int get minH => 1;
  double get maxW => double.infinity;
  double get maxH => double.infinity;

  const CardModel({required this.id});

  Map<String, dynamic> configToJson();

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type.name, 'config': configToJson()};
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final config = json['config'] as Map<String, dynamic>;

    final type = CardType.values.byName(json['type']);
    return type.createModel(id: id, config: config);
  }
}
