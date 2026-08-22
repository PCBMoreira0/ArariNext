import 'dart:async';

import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/chart_card_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:arari_next/ui/core/history_store.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/chart_card.dart';
import 'package:flutter/material.dart';

class ChartCardWrapper extends StatefulWidget {
  final ChartCardModel initialModel;
  final HistoryStore historyStore;
  final Function(CardModel) onConfigChanged;

  const ChartCardWrapper({
    super.key,
    required this.initialModel,
    required this.historyStore,
    required this.onConfigChanged,
  });

  @override
  State<ChartCardWrapper> createState() => _ChartCardWrapperState();
}

class _ChartCardWrapperState extends State<ChartCardWrapper> {
  late List<({DateTime time, TelemetryModel data})> _localDataPoints;
  late Duration _currentInterval;
  late ChartCardModel _model;

  late Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _model = widget.initialModel;
    _currentInterval = _model.selectedInterval;
    _localDataPoints = widget.historyStore.getHistory(_currentInterval);

    widget.historyStore.onThrottledUpdate.addListener(_onHistoryUpdated);

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _localDataPoints = widget.historyStore.getHistory(_currentInterval);
      });
    });
  }

  void _onHistoryUpdated() {
    setState(() {
      _localDataPoints = widget.historyStore.getHistory(_currentInterval);
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    widget.historyStore.onThrottledUpdate.removeListener(_onHistoryUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      historyData: _localDataPoints,
      selectedMetrics: _model.selectedMetrics
          .map((id) => MetricsCatalog.findMetricDefinitionById(id))
          .whereType<MetricDefinition>() // remove os nulls
          .toList(),
      selectedInterval: _currentInterval,
      onConfigChanged: (newMetrics, newInterval) {
        setState(() {
          _currentInterval = newInterval;
          _localDataPoints = widget.historyStore.getHistory(newInterval);
        });

        final updatedModel = _model.copyWith(
          selectedMetrics: newMetrics.map((metric) => metric.id).toList(),
          selectedInterval: newInterval,
        );
        _model = updatedModel;
        widget.onConfigChanged(updatedModel);
      },
    );
  }
}
