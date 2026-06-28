import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';

class MetricsCatalog {
  // 1. Listas separadas e limpas
  static final List<MetricDefinition> bms = [
    MetricDefinition(label: "Nível de bateria", unit: '%', valueExtractor: (data) => data.bmsData.stateOfCharge),
    MetricDefinition(label: "Tensão da bateria", unit: 'V', valueExtractor: (data) => data.bmsData.totalVoltage),
  ];

  static final List<MetricDefinition> motor = [
    MetricDefinition(label: "Tensão do motor (bombordo)", unit: 'V', valueExtractor: (data) => data.motorEletricalDataLeft.busVoltage),
    MetricDefinition(label: "Corrente do motor (bombordo)", unit: 'A', valueExtractor: (data) => data.motorEletricalDataLeft.busCurrent),
  ];

  // 2. Um mapa auxiliar que facilita MUITO a vida do nosso BottomSheet
  static final Map<String, List<MetricDefinition>> grouped = {
    "Bateria": bms,
    "Motor": motor,
  };
}