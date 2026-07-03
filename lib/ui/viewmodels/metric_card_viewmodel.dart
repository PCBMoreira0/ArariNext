import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metric_selection_menu_anchor.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:flutter/material.dart';

class MetricCardViewmodel {
  FullBoatData lastKnownData = FullBoatData.empty();

  late final ValueNotifier<MetricData> selectedMetricValueNotifier;

  late MetricDefinition _selectedMetricDefinition;
  MetricCardModel _model;
  MetricCardModel get model => _model;

  final PacketRepository packetRepository;

  final Function(MetricCardModel) onConfigChanged;

  MetricCardViewmodel({
    required this.packetRepository,
    required MetricCardModel model,
    required this.onConfigChanged,
  }) : _model = model {
    for (var key in MetricsCatalog.grouped.keys) {
      for (var metric in MetricsCatalog.grouped[key]!) {
        if (metric.label == _model.selectedMetric) {
          _selectedMetricDefinition = metric;
        }
      }
    }

    selectedMetricValueNotifier = ValueNotifier<MetricData>(
      MetricData(
        label: _selectedMetricDefinition.label,
        value: 0.0,
        unit: _selectedMetricDefinition.unit,
      ),
    );

    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  void changeSelection(MetricDefinition newDefinition) {
    _selectedMetricDefinition = newDefinition;
    _model = _model.copyWith(selectedMetric: newDefinition.label);
    onConfigChanged(_model);
    _updateUI(lastKnownData);
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    lastKnownData = newData;
    _updateUI(lastKnownData);
  }

  void _updateUI(FullBoatData data) {
    final double extractedValue = _selectedMetricDefinition.valueExtractor(
      data,
    );

    selectedMetricValueNotifier.value = MetricData(
      label: _selectedMetricDefinition.label,
      value: extractedValue,
      unit: _selectedMetricDefinition.unit,
    );
  }
}
