import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatefulWidget {
  final MetricCardModel model;

  final ValueListenable<FullBoatData> boatDataListenable;

  final ValueChanged<MetricCardModel> onConfigChanged;

  const MetricCard({
    super.key,
    required MetricCardModel initialModel,
    required this.boatDataListenable,
    required this.onConfigChanged,
  }) : model = initialModel;

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  late MetricDefinition _selectedMetric;

  @override
  void initState() {
    super.initState();
    _selectedMetric =
        MetricsCatalog.findMetricDefinitionById(widget.model.selectedMetric) ??
        MetricsCatalog.bms.first;
  }

  void _changeSelection(MetricDefinition newMetric) {
    setState(() {
      _selectedMetric = newMetric;
    });

    final updatedModel = widget.model.copyWith(selectedMetric: newMetric.id);

    widget.onConfigChanged(updatedModel);
  }

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
                      _changeSelection(metrica);
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
      title: _selectedMetric.label,
      action: IconButton(
        icon: const Icon(Icons.tune),
        onPressed: () => _showMetricSelector(context),
      ),

      child: ValueListenableBuilder<FullBoatData>(
        valueListenable: widget.boatDataListenable,
        builder: (context, data, child) {
          final double extractedValue = _selectedMetric.valueExtractor(data);

          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: ValueGauge(
              value: extractedValue.toStringAsFixed(1),
              unit: _selectedMetric.unit,
            ),
          );
        },
      ),
    );
  }
}
