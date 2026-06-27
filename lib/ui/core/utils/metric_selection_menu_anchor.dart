import 'package:flutter/material.dart';

class MetricData {
  final String label;
  final double value;
  final String unit;

  MetricData({required this.label, required this.value, required this.unit});
}

class MetricSelectionMenuAnchor extends StatelessWidget {
  final List<MetricData> metrics;
  final void Function(int index)? onSelected;
  final int? initialSelection;

  const MetricSelectionMenuAnchor({
    super.key,
    required this.metrics,
    this.onSelected,
    this.initialSelection,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: List.generate(metrics.length, (index) {
        return DropdownMenuEntry(value: index, label: metrics[index].label);
      }),
      initialSelection: initialSelection,
      onSelected: (value) {
        if (value != null) {
          if (onSelected != null) {
            onSelected!(value);
          }
        }
      },
    );
  }
}
