import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metric_selection_menu_anchor.dart';
import 'package:flutter/material.dart';

class MetricDefinition {
  final String label;
  final String unit;
  final double Function(FullBoatData rawData) valueExtractor;

  MetricDefinition({
    required this.label,
    required this.unit,
    required this.valueExtractor,
  });
}

class MetricCardViewmodel {
  final List<MetricDefinition> metrics = [
    MetricDefinition(
      label: "Corrente da Bateria",
      unit: 'A',
      valueExtractor: (data) => data.bmsData.batteryCurrent,
    ),
    MetricDefinition(
      label: "Tensão da Bateria",
      unit: 'V',
      valueExtractor: (data) => data.bmsData.totalVoltage,
    ),
    MetricDefinition(
      label: "Estado de Carga da Bateria",
      unit: '%',
      valueExtractor: (data) => data.bmsData.stateOfCharge,
    ),
  ];

  late FullBoatData lastKnownData = FullBoatData.empty();

  late final ValueNotifier<MetricData> currentMetricNotifier;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final PacketRepository packetRepository;

  MetricCardViewmodel({required this.packetRepository}) {
    currentMetricNotifier = ValueNotifier<MetricData>(
      MetricData(label: metrics[0].label, value: 0.0, unit: metrics[0].unit),
    );

    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  List<String> get availableMetrics => metrics.map((m) => m.label).toList();

  void changeSelection(int newIndex) {
    _selectedIndex = newIndex;
    _updateUI(lastKnownData);
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    lastKnownData = newData;
    _updateUI(lastKnownData);
  }

  void _updateUI(FullBoatData data) {
    final definition = metrics[_selectedIndex];

    final double extractedValue = definition.valueExtractor(data);

    currentMetricNotifier.value = MetricData(
      label: definition.label,
      value: extractedValue,
      unit: definition.unit,
    );
  }
}
