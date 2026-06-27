import 'package:arari_next/domain/models/motor_eletrical_data.dart';
import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:arari_next/ui/core/utils/layout_mode.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/gauge/speedometer_gauge.dart';
import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
import 'package:arari_next/ui/viewmodels/propulsion_card_viewmodel.dart';
import 'package:flutter/material.dart';

enum LayoutType { ultraCompact, compact, vertical, horizontal, minimum, full }

abstract class LayoutConstraints {
  double get minHeight;
  double get minWidth;
  Widget build();
}

class PropulsionCard extends StatelessWidget {
  final double valueTextSize = 16;

  final PropulsionCardViewmodel viewModel;

  const PropulsionCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "Propulsão",
      action: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            child: Text('Inverter posição'),
            onPressed: () {
              viewModel.toggleInstance();
            },
          ),
        ],
        builder: (context, controller, child) {
          return IconButton(
            icon: Icon(Icons.settings),
            iconSize: 15,
            padding: EdgeInsets.all(2),
            constraints: const BoxConstraints(),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
          );
        },
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          LayoutMode layoutMode = LayoutMode(
            layouts: [
              _FullLayout(viewModel: viewModel, minHeight: 166, minWidth: 318),
              _MinimumLayout(
                viewModel: viewModel,
                minHeight: 160,
                minWidth: 124,
              ),
              _VerticalLayout(
                viewModel: viewModel,
                minHeight: 122,
                minWidth: 100,
              ),
              _HorizontalLayout(
                viewModel: viewModel,
                minHeight: 56,
                minWidth: 184,
              ),
              _UltraCompactLayout(viewModel: viewModel),
            ],
          );
          // return _FullLayout(rpm: widget.rpm).build();
          return layoutMode.buildLayout(constraints);
        },
      ),
    );
  }
}

class _UltraCompactLayout extends LayoutConstraint {
  final PropulsionCardViewmodel viewModel;

  _UltraCompactLayout({required this.viewModel});

  @override
  Widget build() {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: ValueListenableBuilder(
          valueListenable: viewModel.motorEletricalDataValueNotifier,
          builder: (context, value, child) {
            return ValueGauge(
              value: value.rpm.toString(),
              unit: 'rpm',
              label: 'Velocidade',
            );
          },
        ),
      ),
    );
  }
}

class _CompactLayout extends LayoutConstraint {
  final double _valueTextSize;
  final PropulsionCardViewmodel viewModel;

  _CompactLayout({required this.viewModel, double valueTextSize = 16})
    : _valueTextSize = valueTextSize;

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
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.busVoltage.toString(),
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
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.busCurrent.toString(),
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
                    valueListenable: viewModel.motorStateDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        unit: 'ºC',
                        value: value.motorTemperature.toString(),
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
                    valueListenable: viewModel.motorStateDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        unit: 'ºC',
                        value: value.controllerTemperature.toString(),
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

class _MinimumLayout extends LayoutConstraint {
  final PropulsionCardViewmodel viewModel;
  final double _valueTextSize;

  _MinimumLayout({
    required this.viewModel,
    super.minHeight,
    super.minWidth,
    double valueTextSize = 16,
  }) : _valueTextSize = valueTextSize;

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
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.busVoltage.toString(),
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
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.busCurrent.toString(),
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
                    valueListenable: viewModel.motorStateDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        unit: 'ºC',
                        value: value.motorTemperature.toString(),
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
                    valueListenable: viewModel.motorStateDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.controllerTemperature.toString(),
                        label: 'Temperatura ESC',
                        unit: 'ºC',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
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
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        unit: 'rpm',
                        value: value.rpm.toString(),
                        label: 'Velocidade',
                        valueStyle: TextStyle(fontSize: _valueTextSize),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: viewModel.motorEletricalDataValueNotifier,
                    builder: (context, value, child) {
                      return ValueGauge(
                        value: value.acceleratorOpening.toString(),
                        label: 'Abertura Acel.',
                        unit: '%',
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

class _AxisWidgets {
  static List<Widget> getWidgets(
    PropulsionCardViewmodel viewModel,
    double valueTextSize,
  ) {
    return [
      Expanded(
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: viewModel.motorEletricalDataValueNotifier,
            builder: (context, value, child) {
              return ValueGauge(
                value: value.rpm.toString(),
                label: 'Velocidade',
                unit: 'rpm',
                valueStyle: TextStyle(fontSize: valueTextSize),
              );
            },
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: viewModel.motorEletricalDataValueNotifier,
            builder: (context, value, child) {
              return ValueGauge(
                value: value.busCurrent.toString(),
                label: 'Corrente',
                unit: 'A',
                valueStyle: TextStyle(fontSize: valueTextSize),
              );
            },
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: viewModel.motorStateDataValueNotifier,
            builder: (context, value, child) {
              return ValueGauge(
                value: value.controllerTemperature.toString(),
                label: 'Temperatura ESC',
                unit: 'ºC',
                valueStyle: TextStyle(fontSize: valueTextSize),
              );
            },
          ),
        ),
      ),
    ];
  }
}

class _VerticalLayout extends LayoutConstraint {
  final PropulsionCardViewmodel viewModel;
  final double _valueTextSize;

  _VerticalLayout({
    required this.viewModel,
    super.minHeight,
    super.minWidth,
    double valueTextSize = 16,
  }) : _valueTextSize = valueTextSize;

  @override
  Widget build() {
    return Column(children: _AxisWidgets.getWidgets(viewModel, _valueTextSize));
  }
}

class _HorizontalLayout extends LayoutConstraint {
  final PropulsionCardViewmodel viewModel;
  final double _valueTextSize;

  _HorizontalLayout({
    required this.viewModel,
    super.minHeight,
    super.minWidth,
    double valueTextSize = 16,
  }) : _valueTextSize = valueTextSize;

  @override
  Widget build() {
    return Row(children: _AxisWidgets.getWidgets(viewModel, _valueTextSize));
  }
}

class _FullLayout extends LayoutConstraint {
  final PropulsionCardViewmodel viewModel;
  final double valueTextSize;

  _FullLayout({
    required this.viewModel,
    super.minHeight,
    super.minWidth,
    this.valueTextSize = 16,
  });

  @override
  Widget build() {
    final Widget compactLayout = _CompactLayout(
      valueTextSize: valueTextSize,
      viewModel: viewModel,
    ).build();

    return ValueListenableBuilder(
      valueListenable: viewModel.currentInstanceNotifier,
      builder: (context, value, child) {
        if (value == MotorInstance.right) {
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
            valueListenable: viewModel.motorEletricalDataValueNotifier,
            builder: (context, value, child) {
              return SpeedometerGauge(rpm: value.rpm.toDouble());
            },
          ),
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: viewModel.motorEletricalDataValueNotifier,
                builder: (context, value, child) {
                  return ValueGauge(
                    value: '${value.rpm}',
                    unit: 'rpm',
                    label: 'Velocidade',
                    valueStyle: TextStyle(fontSize: 18),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewModel.motorEletricalDataValueNotifier,
                builder: (context, value, child) {
                  return ValueGauge(
                    value: value.acceleratorOpening.toString(),
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
