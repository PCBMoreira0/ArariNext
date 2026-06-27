
import 'package:arari_next/ui/core/utils/chart_point.dart';

class CircularChartBuffer {
  final int capacity;
  late List<ChartPoint?> _buffer;
  int _head = 0;
  bool _filled = false;

  CircularChartBuffer(this.capacity) {
    _buffer = List<ChartPoint?>.filled(capacity, null);
  }

  void add(ChartPoint point) {
    _buffer[_head] = point;
    _head = (_head + 1) % capacity;

    if (_head == 0) {
      _filled = true;
    }
  }

  List<ChartPoint> toList() {
    if (!_filled) {
      return _buffer.take(_head).whereType<ChartPoint>().toList();
    }

    return [
      ..._buffer.skip(_head).whereType<ChartPoint>(),
      ..._buffer.take(_head).whereType<ChartPoint>(),
    ];
  }

  int get length => _filled ? capacity : _head;
}
