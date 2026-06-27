import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget{
  final MetricCardViewmodel viewModel;

  const MetricCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Metrico',
      action: DropdownMenu(
        dropdownMenuEntries: List.generate(viewModel.availableMetrics.length, (index) {
          return DropdownMenuEntry(
            value: index,
            label: viewModel.availableMetrics[index],
          );
        }),
        initialSelection: viewModel.selectedIndex,
        onSelected: (value) {
          if (value != null) {
            viewModel.changeSelection(value);
          }
        },
      ),

      child: ValueListenableBuilder(
        valueListenable: viewModel.currentMetricNotifier,
        builder: (context, value, child) {
          return ValueGauge(
            value: value.value.toString(),
            label: value.label,
            unit: value.unit,
          );
        }
      ),
    );
  }
}
