import 'package:arari_next/domain/telemetry/full_boat_data.dart';

class MetricDefinition {
  final String id;
  final String label;
  final String unit;
  final double? Function(FullBoatData data) valueExtractor;
  final int Function(FullBoatData data) timeExtractor;

  MetricDefinition({
    required this.id,
    required this.label,
    required this.unit,
    required this.valueExtractor,
    required this.timeExtractor,
  });
}

class MetricsCatalog {
  static final List<MetricDefinition> bms = [
    MetricDefinition(
      id: "battery_level",
      label: "Nível Bat.",
      unit: '%',
      valueExtractor: (data) => data.bmsData?.stateOfCharge,
      timeExtractor: (data) => data.bmsData?.timestamp ?? 0,
    ),
    MetricDefinition(
      id: "battery_voltage",
      label: "Tensão Bat.",
      unit: 'V',
      valueExtractor: (data) => data.bmsData?.totalVoltage,
      timeExtractor: (data) => data.bmsData?.timestamp ?? 0,
    ),
  ];

  static final List<MetricDefinition> motor = [
    MetricDefinition(
      id: "motor_bb_voltage",
      label: "Tensão Mot.BB",
      unit: 'V',
      valueExtractor: (data) => data.motorLeft.eletrical?.busVoltage,
      timeExtractor: (data) => data.motorLeft.eletrical?.timestamp ?? 0,
    ),
    MetricDefinition(
      id: "motor_be_voltage",
      label: "Tensão Mot.BE",
      unit: 'V',
      valueExtractor: (data) => data.motorRight.eletrical?.busVoltage,
      timeExtractor: (data) => data.motorRight.eletrical?.timestamp ?? 0,
    ),
    MetricDefinition(
      id: "motor_be_current",
      label: "Corrente Mot.BE",
      unit: 'V',
      valueExtractor: (data) => data.motorRight.eletrical?.busCurrent,
      timeExtractor: (data) => data.motorRight.eletrical?.timestamp ?? 0,
    ),
  ];

  static final Map<String, List<MetricDefinition>> grouped = {
    "Bateria": bms,
    "Motor": motor,
  };

  static final Map<String, MetricDefinition> byId = {
    for (final group in grouped.values)
      for (final metric in group) metric.id: metric,
  };

  static MetricDefinition? findMetricDefinitionById(String id) {
    return byId[id];
  }
}
