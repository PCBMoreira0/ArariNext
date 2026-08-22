import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_model.dart';
import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:arari_next/ui/core/utils/layout_mode.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/speedometer_gauge.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PropulsionCard extends StatefulWidget {
  final ValueListenable<TelemetryModel> boatDataListenable;
  final PropulsionCardModel model;
  final ValueChanged<PropulsionCardModel> onConfigChanged;

  const PropulsionCard({
    super.key,
    required PropulsionCardModel initialModel,
    required this.boatDataListenable,
    required this.onConfigChanged,
  }) : model = initialModel;

  @override
  State<StatefulWidget> createState() => _PropulsionCardState();
}

class _PropulsionCardState extends State<PropulsionCard> {
  late MotorInstance selectedInstance;

  @override
  void initState() {
    selectedInstance = widget.model.selectedInstance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "Propulsão",
      action: IconButton(
        onPressed: () {
          setState(() {
            if (selectedInstance == MotorInstance.left) {
              selectedInstance = MotorInstance.right;
            } else {
              selectedInstance = MotorInstance.left;
            }
          });
          final updatedModel = widget.model.copyWith(
            selectedInstance: selectedInstance,
          );
          widget.onConfigChanged(updatedModel);
        },
        icon: const Icon(Icons.tune),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          LayoutMode layoutMode = LayoutMode(
            layouts: [
              _FullLayout(
                boatDataListenable: widget.boatDataListenable,
                selectedInstance: selectedInstance,
              ),
              _CompactLayout(
                boatDataListenable: widget.boatDataListenable,
                selectedInstance: selectedInstance,
              ),
            ],
          );
          return layoutMode.buildLayout(constraints);
        },
      ),
    );
  }
}

class _CompactLayout extends LayoutConstraint {
  final double _valueTextSize = 16;
  final ValueListenable<TelemetryModel> boatDataListenable;
  final MotorInstance selectedInstance;

  _CompactLayout({
    required this.boatDataListenable,
    required this.selectedInstance,
  });

  @override
  Widget build() {
    return Column(
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
                      final busVoltage = selectedInstance == MotorInstance.left
                          ? value.motorLeft.eletrical?.busVoltage ?? 0.0
                          : value.motorRight.eletrical?.busVoltage ?? 0.0;
                      return ValueGauge(
                        value: busVoltage.toStringAsFixed(2),
                        label: 'Tensão',
                        unit: 'V',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
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
                      final busCurrent = selectedInstance == MotorInstance.left
                          ? value.motorLeft.eletrical?.busCurrent ?? 0.0
                          : value.motorRight.eletrical?.busCurrent ?? 0.0;
                      return ValueGauge(
                        value: busCurrent.toStringAsFixed(2),
                        label: 'Corrente',
                        unit: 'A',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
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
                      final motorTemperature =
                          selectedInstance == MotorInstance.left
                          ? value.motorLeft.state?.motorTemperature ?? 0.0
                          : value.motorRight.state?.motorTemperature ?? 0.0;
                      return ValueGauge(
                        unit: 'ºC',
                        value: motorTemperature.toString(),
                        label: 'Temp. Motor',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
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
                      final controllerTemperature =
                          selectedInstance == MotorInstance.left
                          ? value.motorLeft.state?.controllerTemperature ?? 0.0
                          : value.motorRight.state?.controllerTemperature ??
                                0.0;
                      return ValueGauge(
                        unit: 'ºC',
                        value: controllerTemperature.toString(),
                        label: 'Temp. ESC',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FullLayout extends LayoutConstraint {
  final double valueTextSize = 16;

  final ValueListenable<TelemetryModel> boatDataListenable;
  final MotorInstance selectedInstance;

  @override
  double get minHeight => 166;
  @override
  double get minWidth => 318;

  _FullLayout({
    required this.boatDataListenable,
    required this.selectedInstance,
  });

  @override
  Widget build() {
    final Widget compactLayout = _CompactLayout(
      boatDataListenable: boatDataListenable,
      selectedInstance: selectedInstance,
    ).build();

    return ValueListenableBuilder(
      valueListenable: boatDataListenable,
      builder: (context, value, child) {
        if (selectedInstance == MotorInstance.right) {
          return Row(
            children: [
              _buildSpeedometer(),
              const SizedBox(width: 15),
              Expanded(child: compactLayout),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(child: compactLayout),
              const SizedBox(width: 15),
              _buildSpeedometer(),
            ],
          );
        }
      },
    );
  }

  Widget _buildSpeedometer() {
    return Flexible(
      child: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          ValueListenableBuilder(
            valueListenable: boatDataListenable,
            builder: (context, value, child) {
              final rpm = selectedInstance == MotorInstance.left
                  ? value.motorLeft.eletrical?.rpm ?? 0
                  : value.motorRight.eletrical?.rpm ?? 0;
              return SpeedometerGauge(rpm: rpm.toDouble());
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: boatDataListenable,
                builder: (context, value, child) {
                  final rpm = selectedInstance == MotorInstance.left
                      ? value.motorLeft.eletrical?.rpm ?? 0
                      : value.motorRight.eletrical?.rpm ?? 0;
                  return ValueGauge(
                    value: '$rpm',
                    unit: 'rpm',
                    label: 'Velocidade',
                    valueStyle: const TextStyle(fontSize: 18),
                  );
                },
              ),
              const SizedBox(width: 10),
              ValueListenableBuilder(
                valueListenable: boatDataListenable,
                builder: (context, value, child) {
                  final acceleratorOpening =
                      selectedInstance == MotorInstance.left
                      ? value.motorLeft.eletrical?.acceleratorOpening ?? 0
                      : value.motorRight.eletrical?.acceleratorOpening ?? 0;
                  return ValueGauge(
                    value: acceleratorOpening.toString(),
                    unit: '%',
                    label: 'Abertura Acel.',
                    maxWidth: 100,
                    valueStyle: const TextStyle(fontSize: 18),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
