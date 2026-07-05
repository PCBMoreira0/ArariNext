import 'package:arari_next/domain/dashboard/battery_card_model.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/chart_card_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';

enum CardType {
  metric,
  propulsion,
  battery,
  chart;

  CardModel createModel({required String id, Map<String, dynamic>? config}) {
    final cfg = config ?? {};

    switch (this) {
      case CardType.metric:
        return MetricCardModel(
          id: id,
          selectedMetric: cfg['selectedMetric'] ?? 'Nível de bateria',
        );
      case CardType.propulsion:
        return PropulsionCardModel(
          selectedInstance: cfg.containsKey('selectedInstance')
              ? MotorInstance.values.byName(cfg['selectedInstance'])
              : MotorInstance.left,
          id: id,
        );
      case CardType.battery:
        return BatteryCardModel(id: id);
      case CardType.chart:
        return ChartCardModel(
          id: id,
          selectedInterval: Duration(minutes: cfg['selectedInterval'] ?? 1),
          selectedMetrics: List<String>.from(cfg['selectedMetrics'] ?? []),
        );
    }
  }
}
