import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:arari_next/ui/core/utils/layout_mode.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/battery_gauge.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  final ValueListenable<FullBoatData> boatDataListenable;

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

  final ValueListenable<FullBoatData> boatDataListenable;

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
              return BatteryGauge(level: value.bmsData.stateOfCharge);
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: boatDataListenable,
          builder: (context, value, child) {
            return ValueGauge(
              value: value.bmsData.stateOfCharge.toStringAsFixed(2),
              unit: '%',
              valueStyle: TextStyle(fontSize: 16),
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

  final ValueListenable<FullBoatData> boatDataListenable;

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
                              value: value.bmsData.totalVoltage.toStringAsFixed(
                                2,
                              ),
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
                              value: value.bmsData.batteryCurrent
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
                            return ValueGauge(
                              unit: 'h',
                              value:
                                  '${value.batteryRemainingTimeEstimation.hora.toString().padLeft(2, '0')}:${value.batteryRemainingTimeEstimation.minuto.toString().padLeft(2, '0')}',
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
                            return ValueGauge(
                              value:
                                  '${value.batteryTimeWithoutGeneration.hora.toString().padLeft(2, '0')}:${value.batteryTimeWithoutGeneration.minuto.toString().padLeft(2, '0')}',
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

              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: boatDataListenable,
                          builder: (context, value, child) {
                            return ValueGauge(
                              unit: 'ºC',
                              value:
                                  '${value.bmsData.temperatures.isNotEmpty ? value.bmsData.temperatures[0].toString() : 0}',
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
                            return ValueGauge(
                              unit: 'ºC',
                              value:
                                  '${value.bmsData.temperatures.isNotEmpty ? value.bmsData.temperatures[1].toString() : 0}',
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
