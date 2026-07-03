import 'package:arari_next/domain/telemetry/full_boat_data.dart';

class MetricDefinition {
  final String label;
  final String unit;
  final double Function(FullBoatData data) valueExtractor;
  final int Function(FullBoatData data) timeExtractor;

  MetricDefinition({
    required this.label,
    required this.unit,
    required this.valueExtractor,
    required this.timeExtractor,
  });
}

class MetricsCatalog {
  static final List<MetricDefinition> bms = [
    MetricDefinition(
      label: "Nível de bateria",
      unit: '%',
      valueExtractor: (data) => data.bmsData.stateOfCharge,
      timeExtractor: (data) => data.bmsData.timestamp,
    ),
    MetricDefinition(
      label: "Tensão da bateria",
      unit: 'V',
      valueExtractor: (data) => data.bmsData.totalVoltage,
      timeExtractor: (data) => data.bmsData.timestamp,
    ),
  ];

  static final List<MetricDefinition> motor = [
    MetricDefinition(
      label: "Tensão do motor (bombordo)",
      unit: 'V',
      valueExtractor: (data) => data.motorEletricalDataLeft.busVoltage,
      timeExtractor: (data) => data.motorEletricalDataLeft.timestamp,
    ),
    MetricDefinition(
      label: "Tensão do motor (boreste)",
      unit: 'V',
      valueExtractor: (data) => data.motorEletricalDataRight.busVoltage,
      timeExtractor: (data) => data.motorEletricalDataRight.timestamp,
    ),
    MetricDefinition(
      label: "Corrente do motor (boreste)",
      unit: 'V',
      valueExtractor: (data) => data.motorEletricalDataRight.busCurrent,
      timeExtractor: (data) => data.motorEletricalDataRight.timestamp,
    ),
  ];

  static final Map<String, List<MetricDefinition>> grouped = {
    "Bateria": bms,
    "Motor": motor,
  };
}
