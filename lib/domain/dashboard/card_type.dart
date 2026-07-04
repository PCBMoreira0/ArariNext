import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';

enum CardType {
  metric(defaultW: 2, defaultH: 2),
  propulsion(defaultW: 3, defaultH: 2),
  battery(defaultW: 1, defaultH: 1);

  final int defaultW;
  final int defaultH;

  const CardType({required this.defaultW, required this.defaultH});

  CardModel createModel(String id) {
    switch (this) {
      case CardType.metric:
        return MetricCardModel(id: id, selectedMetric: 'Nível de bateria');
      case CardType.propulsion:
        return PropulsionCardModel(
          selectedInstance: MotorInstance.left,
          id: id,
        );
      case CardType.battery:
        throw UnimplementedError();
    }
  }
}
