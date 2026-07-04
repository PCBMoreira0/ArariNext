import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';

final class MetricCardModel extends CardModel {
  final String selectedMetric;
  
  @override
  CardType get type => CardType.metric;

  @override
  int get defaultW => 2;
  @override
  int get defaultH => 2;
  @override
  int get minH => 2;
  @override
  int get minW => 2;

  const MetricCardModel({
    required this.selectedMetric,
    required super.id,
  });

  @override
  Map<String, dynamic> configToJson() {
    return {'selectedMetric': selectedMetric};
  }

  MetricCardModel copyWith({String? id, String? selectedMetric}) {
    return MetricCardModel(
      id: id ?? this.id,
      selectedMetric: selectedMetric ?? this.selectedMetric,
    );
  }
}
