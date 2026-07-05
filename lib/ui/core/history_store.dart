import 'dart:async';
import 'dart:collection';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:flutter/foundation.dart'; 

class HistoryStore {
  final PacketRepository _packetRepository;
  late final StreamSubscription<FullBoatData?> _subscription;
  final Queue<({DateTime time, FullBoatData data})> _buffer = Queue();
  static const Duration _maxHistory = Duration(minutes: 5);

  DateTime? _lastSavedTime; 
  static const Duration _sampleRate = Duration(milliseconds: 500); 

  final ValueNotifier<int> onThrottledUpdate = ValueNotifier(0);

  HistoryStore({required PacketRepository packetRepository}) 
      : _packetRepository = packetRepository {
    _subscription = _packetRepository.data.listen(_onNewData);
  }

  void _onNewData(FullBoatData? newData) {
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

  List<({DateTime time, FullBoatData data})> getHistory(Duration interval) {
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