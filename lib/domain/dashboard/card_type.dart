import 'package:arari_next/domain/dashboard/battery_card_model.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';

enum CardType {
  metric,
  propulsion,
  battery;

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
    }
  }
}
