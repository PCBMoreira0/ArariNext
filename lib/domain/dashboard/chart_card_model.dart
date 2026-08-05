import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';

class ChartCardModel extends CardModel {
  final Duration selectedInterval;
  final List<String> selectedMetrics;

  @override
  int get defaultW => 2;
  @override
  int get defaultH => 1;
  @override
  int get minH => 1;
  @override
  int get minW => 2;

  const ChartCardModel({
    required super.id,
    required this.selectedInterval,
    required this.selectedMetrics,
  });

  @override
  Map<String, dynamic> configToJson() {
    return {
      "selectedInterval": selectedInterval.inMinutes,
      'selectedMetrics': selectedMetrics,
    };
  }

  @override
  CardType get type => CardType.chart;

  ChartCardModel copyWith({
    String? id,
    String? name,
    Duration? selectedInterval,
    List<String>? selectedMetrics,
  }) {
    return ChartCardModel(
      id: id ?? this.id,
      selectedInterval: selectedInterval ?? this.selectedInterval,
      selectedMetrics: selectedMetrics ?? this.selectedMetrics,
    );
  }

  factory ChartCardModel.empty(String id) {
    return ChartCardModel(
      id: id,
      selectedInterval: Duration(minutes: 1),
      selectedMetrics: [],
    );
  }
}
