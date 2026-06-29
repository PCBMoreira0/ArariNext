import 'dart:async';
import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:flutter/material.dart';

class ChartCardViewmodel extends ChangeNotifier {
  final PacketRepository packetRepository;
  StreamSubscription? _subscription;

  final int maxPontos = 60;

  List<MetricDefinition> selectedMetrics = [];

  final Map<String, List<Map<String, dynamic>>> _seriesData = {};

  List<Map<String, dynamic>> get chartData {
    return _seriesData.values.expand((pontos) => pontos).toList();
  }

  ChartCardViewmodel({required this.packetRepository}) {
    _subscription = packetRepository.data.listen(
      (data) => onNewDataReceived(data),
    );
  }

  void onNewDataReceived(FullBoatData? data) {
    if (data == null || selectedMetrics.isEmpty) return;

    bool hasUpdates = false;

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

        if (currentList.length > maxPontos) {
          currentList.removeAt(0);
        }

        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      notifyListeners();
    }
  }

  void updateSelectedMetrics(List<MetricDefinition> newSelection) {
    selectedMetrics = newSelection;
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
