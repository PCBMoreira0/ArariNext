import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:arari_next/ui/core/utils/layout_mode.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/battery_gauge.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  final ValueListenable<TelemetryModel> boatDataListenable;

  const BatteryCard({super.key, required this.boatDataListenable});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "Bateria",
      child: LayoutBuilder(
        builder: (context, constraints) {
          LayoutMode layoutMode = LayoutMode(
            layouts: [
              _FullLayout(boatDataListenable: boatDataListenable),
              _CompactLayout(boatDataListenable: boatDataListenable),
            ],
          );

          return layoutMode.buildLayout(constraints);
        },
      ),
    );
  }
}

class _CompactLayout extends LayoutConstraint {
  @override
  double get minHeight => 105;
  @override
  double get minWidth => 54;

  final ValueListenable<TelemetryModel> boatDataListenable;

  _CompactLayout({required this.boatDataListenable});

  @override
  Widget build() {
    return ValueListenableBuilder<TelemetryModel>(
      valueListenable: boatDataListenable,
      builder: (context, value, child) {
        final stateOfCharge = value.bmsData?.stateOfCharge ?? 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: BatteryGauge(level: stateOfCharge)),
            ValueGauge(
              value: stateOfCharge.toStringAsFixed(1),
              unit: '%',
              valueStyle: const TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}

class _FullLayout extends LayoutConstraint {
  final double valueTextSize = 16;

  @override
  double get minHeight => 124;
  @override
  double get minWidth => 232;

  final ValueListenable<TelemetryModel> boatDataListenable;

  _FullLayout({required this.boatDataListenable});

  @override
  Widget build() {
    return Row(
      children: [
        _CompactLayout(boatDataListenable: boatDataListenable).build(),
        const SizedBox(width: 15),
        Expanded(
          child: ValueListenableBuilder<TelemetryModel>(
            valueListenable: boatDataListenable,
            builder: (context, value, child) {
              final bms = value.bmsData;

              // Extração de variáveis
              final totalVoltage = bms?.totalVoltage ?? 0.0;
              final batteryCurrent = bms?.batteryCurrent ?? 0.0;

              final remHour = value.batteryRemainingTimeEstimation?.hora ?? 0;
              final remMin = value.batteryRemainingTimeEstimation?.minuto ?? 0;

              final noGenHour = value.batteryTimeWithoutGeneration?.hora ?? 0;
              final noGenMin = value.batteryTimeWithoutGeneration?.minuto ?? 0;

              final temp1 = (bms != null && bms.temperatures.isNotEmpty)
                  ? bms.temperatures[0]
                  : 0.0;
              final temp2 = (bms != null && bms.temperatures.length > 1)
                  ? bms.temperatures[1]
                  : 0.0;

              return Column(
                children: [
                  // Linha 1
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              value: totalVoltage.toStringAsFixed(2),
                              label: 'Tensão',
                              unit: 'V',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              value: batteryCurrent.toStringAsFixed(2),
                              label: 'Corrente',
                              unit: 'A',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Linha 2
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              unit: 'h',
                              value:
                                  '${remHour.toString().padLeft(2, '0')}:${remMin.toString().padLeft(2, '0')}',
                              label: 'Tempo Restante',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              value:
                                  '${noGenHour.toString().padLeft(2, '0')}:${noGenMin.toString().padLeft(2, '0')}',
                              label: 'Tempo s/ geração',
                              unit: 'h',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Linha 3
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              unit: 'ºC',
                              value: temp1.toString(),
                              label: 'Temperatura 1',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ValueGauge(
                              unit: 'ºC',
                              value: temp2.toString(),
                              label: 'Temperatura 2',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
