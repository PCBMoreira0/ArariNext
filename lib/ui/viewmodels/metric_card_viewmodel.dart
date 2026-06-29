import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metric_selection_menu_anchor.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:flutter/material.dart';


class MetricCardViewmodel {
  FullBoatData lastKnownData = FullBoatData.empty();

  late final ValueNotifier<MetricData> selectedMetricValueNotifier;

  late MetricDefinition _selectedMetricDefinition;

  final PacketRepository packetRepository;

  MetricCardViewmodel({required this.packetRepository}) {
    _selectedMetricDefinition = MetricsCatalog.bms.first;

    selectedMetricValueNotifier = ValueNotifier<MetricData>(
      MetricData(label: _selectedMetricDefinition.label, value: 0.0, unit: _selectedMetricDefinition.unit),
    );

    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  // List<String> get availableMetrics => metrics.map((m) => m.label).toList();

  void changeSelection(MetricDefinition newDefinition) {
    _selectedMetricDefinition = newDefinition;
    _updateUI(lastKnownData);
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    lastKnownData = newData;
    _updateUI(lastKnownData);
  }

  void _updateUI(FullBoatData data) {
    final double extractedValue = _selectedMetricDefinition.valueExtractor(data);

    selectedMetricValueNotifier.value = MetricData(
      label: _selectedMetricDefinition.label,
      value: extractedValue,
      unit: _selectedMetricDefinition.unit,
    );
  }
}
