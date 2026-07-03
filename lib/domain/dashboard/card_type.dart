import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';

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
        return MetricCardModel(
          id: id,
          type: this,
          selectedMetric: 'Nível de bateria',
        );
      case CardType.propulsion:
        throw UnimplementedError();
      case CardType.battery:
        throw UnimplementedError();
    }
  }

  dynamic createViewModel({
    required CardModel model,
    required dynamic packetRepository,
    required Function(CardModel) onConfigChanged,
  }) {
    switch (this) {
      case CardType.metric:
        return MetricCardViewmodel(
          packetRepository: packetRepository,
          model: model as MetricCardModel,
          onConfigChanged: onConfigChanged,
        );
      case CardType.propulsion:
        throw UnimplementedError();
      case CardType.battery:
        throw UnimplementedError();
    }
  }
}
