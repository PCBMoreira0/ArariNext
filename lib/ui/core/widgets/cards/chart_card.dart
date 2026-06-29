import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/viewmodels/chart_card_viewmodel.dart';
import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  final ChartCardViewmodel viewmodel;

  const ChartCard({super.key, required this.viewmodel});

  void _showMultiMetricSelector(
    BuildContext context,
    ChartCardViewmodel viewModel,
  ) {
    List<MetricDefinition> tempSelected = List.from(viewModel.selectedMetrics);
    const int maxSelections = 4;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            bool limitReached = tempSelected.length >= maxSelections;

            return SafeArea(
              child: FractionallySizedBox(
                heightFactor: 0.8, // Ocupa até 80% da tela
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- CABEÇALHO ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Métricas do Gráfico (${tempSelected.length}/$maxSelections)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // --- UX 3: CHIPS DAS MÉTRICAS SELECIONADAS NO TOPO ---
                    if (tempSelected.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: tempSelected.map((metric) {
                            return InputChip(
                              label: Text(
                                metric.label,
                                style: const TextStyle(fontSize: 12),
                              ),
                              deleteIcon: const Icon(Icons.cancel, size: 18),
                              onDeleted: () {
                                setModalState(() {
                                  tempSelected.remove(metric);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                    const Divider(),

                    // --- UX 1 & 2: LISTA CATEGORIZADA COM CHECKBOX ---
                    Expanded(
                      child: ListView.builder(
                        itemCount: MetricsCatalog.grouped.keys.length,
                        itemBuilder: (context, index) {
                          final categoryName = MetricsCatalog.grouped.keys
                              .elementAt(index);
                          final categoryMetrics =
                              MetricsCatalog.grouped[categoryName]!;

                          return ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              categoryName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: categoryMetrics.map((metric) {
                              final isSelected = tempSelected.contains(metric);

                              // Desabilita visualmente se chegou no limite E o item atual não está selecionado
                              final isDisabled = limitReached && !isSelected;

                              return CheckboxListTile(
                                title: Text(
                                  metric.label,
                                  style: TextStyle(
                                    color: isDisabled
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(metric.unit),
                                value: isSelected,
                                // Se estiver desabilitado, o onChanged fica nulo (não clicável)
                                onChanged: isDisabled
                                    ? null
                                    : (bool? value) {
                                        setModalState(() {
                                          if (value == true) {
                                            tempSelected.add(metric);
                                          } else {
                                            tempSelected.remove(metric);
                                          }
                                        });
                                      },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),

                    // --- BOTÃO DE APLICAR ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: tempSelected.isEmpty
                            ? null
                            : () {
                                viewModel.updateSelectedMetrics(tempSelected);
                                Navigator.pop(context);
                              },
                        child: const Text('Aplicar no Gráfico'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "Gráfico",
      action: IconButton(
        icon: const Icon(Icons.tune, size: 20), // ou Icons.settings
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => _showMultiMetricSelector(context, viewmodel),
      ),
      child: Text("Oi"),
    );
  }
}
