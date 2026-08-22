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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: boatDataListenable,
            builder: (context, value, child) {
              return BatteryGauge(level: value.bmsData?.stateOfCharge ?? 0.0);
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: boatDataListenable,
          builder: (context, value, child) {
            return ValueGauge(
              value: (value.bmsData?.stateOfCharge ?? 0.0).toStringAsFixed(2),
              unit: '%',
              valueStyle: const TextStyle(fontSize: 16),
            );
          },
        ),
      ],
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
          child: Column(
            children: [
              // Linha 1
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            return ValueGauge(
                              value: (value.bmsData?.totalVoltage ?? 0.0)
                                  .toStringAsFixed(2),
                              label: 'Tensão',
                              unit: 'V',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            return ValueGauge(
                              value: (value.bmsData?.batteryCurrent ?? 0.0)
                                  .toStringAsFixed(2),
                              label: 'Corrente',
                              unit: 'A',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
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
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            final hora =
                                value.batteryRemainingTimeEstimation?.hora ?? 0;
                            final minuto =
                                value.batteryRemainingTimeEstimation?.minuto ??
                                0;
                            return ValueGauge(
                              unit: 'h',
                              value: '$hora:$minuto',
                              label: 'Tempo Restante',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            final hora =
                                value.batteryTimeWithoutGeneration?.hora ?? 0;
                            final minuto =
                                value.batteryTimeWithoutGeneration?.minuto ?? 0;
                            return ValueGauge(
                              value: '$hora:$minuto',
                              label: 'Tempo s/ geração',
                              unit: 'h',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
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
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            final hasTemp1 = value.bmsData != null &&
                                value.bmsData!.temperatures.isNotEmpty;
                            final temp1 = hasTemp1
                                ? value.bmsData!.temperatures[0]
                                : 0.0;
                            return ValueGauge(
                              unit: 'ºC',
                              value: temp1.toStringAsFixed(2),
                              label: 'Temperatura 1',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            final hasTemp2 = value.bmsData != null &&
                                value.bmsData!.temperatures.length > 1;
                            final temp2 = hasTemp2
                                ? value.bmsData!.temperatures[1]
                                : 0.0;
                            return ValueGauge(
                              unit: 'ºC',
                              value: temp2.toStringAsFixed(2),
                              label: 'Temperatura 2',
                              valueStyle: TextStyle(fontSize: valueTextSize),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}