import 'dart:async';
import 'dart:collection';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:flutter/foundation.dart'; 

class HistoryStore {
  final ITelemetryRepository _packetRepository;
  late final StreamSubscription<TelemetryModel?> _subscription;
  final Queue<({DateTime time, TelemetryModel data})> _buffer = Queue();
  static const Duration _maxHistory = Duration(minutes: 5);

  DateTime? _lastSavedTime; 
  static const Duration _sampleRate = Duration(milliseconds: 500); 

  final ValueNotifier<int> onThrottledUpdate = ValueNotifier(0);

  HistoryStore({required ITelemetryRepository packetRepository}) 
      : _packetRepository = packetRepository {
    _subscription = _packetRepository.data.listen(_onNewData);
  }

  void _onNewData(TelemetryModel? newData) {
    if (newData == null) return;
    final now = DateTime.now();

    if (_lastSavedTime != null && now.difference(_lastSavedTime!) < _sampleRate) {
      return; 
    }
    _lastSavedTime = now;

    _buffer.add((time: now, data: newData));

    final cutoffTime = now.subtract(_maxHistory);
    while (_buffer.isNotEmpty && _buffer.first.time.isBefore(cutoffTime)) {
      _buffer.removeFirst();
    }

    onThrottledUpdate.value++; 
  }

  List<({DateTime time, TelemetryModel data})> getHistory(Duration interval) {
    final safeInterval = interval > _maxHistory ? _maxHistory : interval;
    final cutoffTime = DateTime.now().subtract(safeInterval);

    return _buffer
        .where((item) => item.time.isAfter(cutoffTime))
        .toList();
  }

  void dispose() {
    _subscription.cancel();
    onThrottledUpdate.dispose();
  }
}