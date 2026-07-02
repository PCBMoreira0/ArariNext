import 'dart:async';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:flutter/material.dart';

class ChartCardViewmodel extends ChangeNotifier {
  final PacketRepository packetRepository;
  StreamSubscription? _subscription;

  Duration selectedInterval = const Duration(minutes: 1);
  final Duration maxHistory = const Duration(minutes: 5);
  final int maxPointsLimit = 1500;

  List<MetricDefinition> selectedMetrics = [];

  final Map<String, List<Map<String, dynamic>>> _seriesData = {};

  List<Map<String, dynamic>> get chartData {
    final now = DateTime.now().millisecondsSinceEpoch;
    final int viewportCutoff = now - selectedInterval.inMilliseconds;

    return _seriesData.values
        .expand((pontos) => pontos)
        .where((ponto) => ponto['timestamp'] >= viewportCutoff)
        .toList();
  }

  ChartCardViewmodel({required this.packetRepository}) {
    _subscription = packetRepository.data.listen(
      (data) => onNewDataReceived(data),
    );
  }

  void onNewDataReceived(FullBoatData? data) {
    if (data == null || selectedMetrics.isEmpty) return;

    bool hasUpdates = false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final int cutoffTimeMemory = now - maxHistory.inMilliseconds;

    for (var metric in selectedMetrics) {
      final double newValue = metric.valueExtractor(data);
      final int newTimestamp = metric.timeExtractor(data);

      _seriesData.putIfAbsent(metric.label, () => []);
      final currentList = _seriesData[metric.label]!;

      if (currentList.isEmpty ||
          currentList.last['timestamp'] != newTimestamp) {
        currentList.add({
          'timestamp': newTimestamp,
          'value': newValue,
          'category': metric.label,
        });

        while (currentList.isNotEmpty &&
            currentList.first['timestamp'] < cutoffTimeMemory) {
          currentList.removeAt(0);
        }

        if (currentList.length > maxPointsLimit) {
          currentList.removeRange(0, currentList.length - maxPointsLimit);
        }

        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      notifyListeners();
    }
  }

  void updateSettings(
    List<MetricDefinition> newSelection,
    Duration newInterval,
  ) {
    selectedMetrics = newSelection;
    selectedInterval = newInterval;

    _seriesData.removeWhere(
      (key, _) => !selectedMetrics.any((m) => m.label == key),
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
