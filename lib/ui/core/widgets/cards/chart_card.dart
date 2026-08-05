import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  final List<({DateTime time, FullBoatData data})> historyData;

  final List<MetricDefinition> selectedMetrics;
  final Duration selectedInterval;

  final void Function(List<MetricDefinition> newMetrics, Duration newInterval)
  onConfigChanged;

  const ChartCard({
    super.key,
    required this.historyData,
    required this.selectedMetrics,
    required this.selectedInterval,
    required this.onConfigChanged,
  });

  List<Map<String, dynamic>> _mapDataToChart() {
    if (historyData.isEmpty || selectedMetrics.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> chartData = [];

    for (var point in historyData) {
      final timeMs = point.time.millisecondsSinceEpoch;

      for (var metric in selectedMetrics) {
        final value = metric.valueExtractor(point.data);

        chartData.add({
          'timestamp': timeMs,
          'value': value,
          'category': metric.label,
        });
      }
    }
    return chartData;
  }

  void _showMultiMetricSelector(BuildContext context) {
    List<MetricDefinition> tempSelected = List.from(selectedMetrics);
    const int maxSelections = 4;
    final List<int> intervalOptions = [1, 2, 5];
    Duration tempInterval = selectedInterval;

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
                heightFactor: 0.8,
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

                    // --- CHIPS DAS MÉTRICAS SELECIONADAS NO TOPO ---
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

                    // --- LISTA CATEGORIZADA COM CHECKBOX ---
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
                                // Dispara o callback informando as novas escolhas do usuário
                                onConfigChanged(tempSelected, tempInterval);
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
    final appTheme = getTheme(context);

    final dataToShow = _mapDataToChart();
    final hasData = dataToShow.isNotEmpty;
    final now = DateTime.now().millisecondsSinceEpoch;

    final double minTime = (now - selectedInterval.inMilliseconds).toDouble();
    final double maxTime = now.toDouble();

    final finalData = hasData
        ? dataToShow
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
        onPressed: () => _showMultiMetricSelector(context),
      ),
      child: CristalyseChart()
          .data(finalData)
          .mapping(x: 'timestamp', y: 'value', color: 'category')
          .geomLine(strokeWidth: 2.0, alpha: hasData ? 0.8 : 0.0)
          .scaleXContinuous(
            tickConfig: TickConfig(simpleLinear: true),
            labels: (value) => formatTimeLabel(value, minTime),
            min: minTime,
            max: maxTime,
          )
          .scaleYContinuous(min: hasData ? null : 0, max: hasData ? null : 100)
          .animate(duration: const Duration(milliseconds: 0))
          .theme(appTheme)
          .build(),
    );
  }

  String formatTimeLabel(num tickValue, double minTime) {
    final differenceMs = tickValue - minTime;

    if (differenceMs < 0) return "00:00";

    final duration = Duration(milliseconds: differenceMs.toInt());
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return "$m:$s";
  }

  ChartTheme getTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultChartTheme = ChartTheme.defaultTheme();

    final appTheme = defaultChartTheme.copyWith(
      backgroundColor: Colors.transparent,
      plotBackgroundColor: Colors.transparent,

      padding: EdgeInsets.only(right: 20, left: 8),
      primaryColor: colorScheme.primary,
      borderColor: Colors.transparent,
      gridColor: colorScheme.surfaceContainerHighest,
      axisColor: colorScheme.onSurfaceVariant,

      colorPalette: [
        colorScheme.primary,
        colorScheme.secondary,
        colorScheme.tertiary,
        colorScheme.error,
        colorScheme.primaryContainer,
        colorScheme.secondaryContainer,
        colorScheme.tertiaryContainer,
      ],
      axisTextStyle:
          theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ) ??
          defaultChartTheme.axisTextStyle.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
      axisLabelStyle:
          theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ) ??
          defaultChartTheme.axisLabelStyle?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
    );

    return appTheme;
  }
}
