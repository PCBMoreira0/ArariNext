import 'package:arari_next/domain/dashboard/card_model.dart';

class MetricCardModel extends CardModel {
  final String selectedMetric;

  MetricCardModel({
    required this.selectedMetric,
    required super.id,
    required super.type,
    required super.layout,
  });

  @override
  Map<String, dynamic> configToJson() {
    return {'selectedMetric': selectedMetric};
  }
}
