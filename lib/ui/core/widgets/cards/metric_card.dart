import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final MetricCardViewmodel viewModel;

  const MetricCard({super.key, required this.viewModel});

  void _showMetricSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final categories = MetricsCatalog.grouped.keys.toList();

        return SafeArea(
          child: ListView.builder(
            shrinkWrap:
                true, // Garante que o modal não ocupe a tela toda se tiver poucos itens
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryName = categories[index];
              final categoryMetrics = MetricsCatalog.grouped[categoryName]!;

              return ExpansionTile(
                title: Text(
                  categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: categoryMetrics.map((metrica) {
                  return ListTile(
                    title: Text(metrica.label),
                    trailing: Text(
                      metrica.unit,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      viewModel.changeSelection(metrica);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Metrico',
      action: IconButton(
        icon: const Icon(
          Icons.tune,
          size: 20,
        ), // ou Icons.settings
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => _showMetricSelector(context),
      ),

      child: ValueListenableBuilder(
        valueListenable: viewModel.selectedMetricValueNotifier,
        builder: (context, value, child) {
          return ValueGauge(
            value: value.value.toString(),
            label: value.label,
            unit: value.unit,
          );
        },
      ),
    );
  }
}
