import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:arari_next/ui/core/utils/layout_mode.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/speedometer_gauge.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PropulsionCard extends StatefulWidget {
  final ValueListenable<FullBoatData> boatDataListenable;
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
      title: "Propulsion",
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
        icon: Icon(Icons.arrow_drop_down),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          LayoutMode layoutMode = LayoutMode(
            layouts: [
              _FullLayout(
                boatDataListenable: widget.boatDataListenable,
                selectedInstance: selectedInstance,
                minHeight: 166,
                minWidth: 318,
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
  final ValueListenable<FullBoatData> boatDataListenable;
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
                          ? value.motorEletricalDataLeft.busVoltage
                          : value.motorEletricalDataRight.busVoltage;
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
                          ? value.motorEletricalDataLeft.busCurrent
                          : value.motorEletricalDataRight.busCurrent;
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
        // Linha
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
                          ? value.motorStateDataLeft.motorTemperature
                          : value.motorStateDataRight.motorTemperature;
                      return ValueGauge(
                        unit: 'ºC',
                        value: motorTemperature.toStringAsFixed(2),
                        label: 'Temperatura Motor',
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
                          ? value.motorStateDataLeft.controllerTemperature
                          : value.motorStateDataRight.controllerTemperature;
                      return ValueGauge(
                        unit: 'ºC',
                        value: controllerTemperature.toStringAsFixed(2),
                        label: 'Temperatura ESC',
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

  final ValueListenable<FullBoatData> boatDataListenable;
  final MotorInstance selectedInstance;

  _FullLayout({
    required this.boatDataListenable,
    required this.selectedInstance,
    super.minHeight,
    super.minWidth,
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
                  ? value.motorEletricalDataLeft.rpm
                  : value.motorEletricalDataRight.rpm;
              return SpeedometerGauge(rpm: rpm.toDouble());
            },
          ),
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: boatDataListenable,
                builder: (context, value, child) {
                  final rpm = selectedInstance == MotorInstance.left
                      ? value.motorEletricalDataLeft.rpm
                      : value.motorEletricalDataRight.rpm;
                  return ValueGauge(
                    value: '$rpm',
                    unit: 'rpm',
                    label: 'Velocidade',
                    valueStyle: TextStyle(fontSize: 18),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: boatDataListenable,
                builder: (context, value, child) {
                  final acceleratorOpening =
                      selectedInstance == MotorInstance.left
                      ? value.motorEletricalDataLeft.acceleratorOpening
                      : value.motorEletricalDataRight.acceleratorOpening;
                  return ValueGauge(
                    value: acceleratorOpening.toString(),
                    unit: '%',
                    label: 'Abertura Acel.',
                    maxWidth: 100,
                    valueStyle: TextStyle(fontSize: 18),
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
