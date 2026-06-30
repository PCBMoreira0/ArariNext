import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/viewmodels/chart_card_viewmodel.dart';
import 'package:cristalyse/cristalyse.dart';
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
    final List<int> intervalOptions = [1, 2, 5];
    Duration tempInterval = viewModel.selectedInterval;

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

                    // --- DROPDOWN DE INTERVALO DE TEMPO ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Janela de tempo:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<Duration>(
                            value: tempInterval,
                            items: intervalOptions.map((mins) {
                              return DropdownMenuItem(
                                value: Duration(minutes: mins),
                                child: Text(
                                  '$mins Minuto${mins > 1 ? 's' : ''}',
                                ),
                              );
                            }).toList(),
                            onChanged: (Duration? newValue) {
                              if (newValue != null) {
                                setModalState(() => tempInterval = newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),

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
                                viewModel.updateSettings(
                                  tempSelected,
                                  tempInterval,
                                );
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
    return ListenableBuilder(
      listenable: viewmodel,
      builder: (context, child) {
        final hasData = viewmodel.chartData.isNotEmpty;
        final now = DateTime.now().millisecondsSinceEpoch;

        final double minTime = (now - viewmodel.selectedInterval.inMilliseconds)
            .toDouble();
        final double maxTime = now.toDouble();

        var dataToShow = hasData
            ? viewmodel.chartData
            : [
                {
                  'timestamp': DateTime.now().millisecondsSinceEpoch - 60000,
                  'value': 0.0,
                  'category': 'ghost',
                },
              ];

        return CustomCard(
          title: "Gráfico",
          action: IconButton(
            icon: const Icon(Icons.tune, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _showMultiMetricSelector(context, viewmodel),
          ),
          child: CristalyseChart()
              .data(dataToShow)
              .mapping(x: 'timestamp', y: 'value', color: 'category')
              .geomLine(strokeWidth: 2.0, alpha: hasData ? 0.8 : 0.0)
              .scaleXContinuous(
                tickConfig: TickConfig(simpleLinear: true),
                labels: (value) => formatTimeLabel(value),
                min: minTime,
                max: maxTime,
              )
              .scaleYContinuous(
                min: hasData ? null : 0,
                max: hasData ? null : 100,
              )
              .animate(duration: const Duration(milliseconds: 0))
              .build(),
        );
      },
    );
  }

  String formatTimeLabel(num x) {
    final date = DateTime.fromMillisecondsSinceEpoch(x.toInt());
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');
    return "$h:$m:$s";
  }
}
