import 'package:arari_next/domain/dashboard/card_model.dart';

final class MetricCardModel extends CardModel {
  final String selectedMetric;

  const MetricCardModel({
    required this.selectedMetric,
    required super.id,
    required super.type,
  });

  @override
  Map<String, dynamic> configToJson() {
    return {'selectedMetric': selectedMetric};
  }

  MetricCardModel copyWith({String? id, String? selectedMetric}) {
    return MetricCardModel(
      id: id ?? this.id,
      type: type,
      selectedMetric: selectedMetric ?? this.selectedMetric,
    );
  }
}
