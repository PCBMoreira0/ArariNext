import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';

abstract class CardModel {
  final String id;
  final CardType type;

  int get defaultW => 1;
  int get defaultH => 1;
  int get minW => 1;
  int get minH => 1;
  double get maxW => double.infinity;
  double get maxH => double.infinity;

  const CardModel({required this.id, required this.type});

  Map<String, dynamic> configToJson();

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type.jsonValue, 'config': configToJson()};
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final config = json['config'] as Map<String, dynamic>;

    switch (CardType.fromJson(json['type'])) {
      case CardType.metric:
        return MetricCardModel(
          id: id,
          selectedMetric: config['selectedMetric'],
          type: CardType.metric,
        );

      default:
        throw Exception('Unknown card type: ${json['type']}');
    }
  }
}
