import 'package:arari_next/ui/core/ui/group_box.dart';
import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({required this.viewmodel, super.key});

  final DashboardViewmodel viewmodel;

  @override
  State<StatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _BMSGroupBox(viewmodel: widget.viewmodel)),
                Expanded(child: _MPPTGroupBox(viewmodel: widget.viewmodel)),
                Expanded(
                  child: _InstrumentationGroupBox(viewmodel: widget.viewmodel),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(child: _MotorGroupBox(viewmodel: widget.viewmodel)),

                Expanded(
                  child: _TemperatureGroupBox(viewmodel: widget.viewmodel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BMSGroupBox extends StatelessWidget {
  const _BMSGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'Bateria',
      child: ValueListenableBuilder(
        valueListenable: viewmodel.bmsValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Tensão Total:'),
                  Text('${data.totalVoltage} V'),
                ],
              ),
              TableRow(
                children: [Text('Corrente:'), Text('${data.batteryCurrent} A')],
              ),
              TableRow(
                children: [
                  Text('Estado de carga:'),
                  Text('${data.stateOfCharge} %'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tempo Restante:'),
                  ValueListenableBuilder(
                    valueListenable: viewmodel.batteryRemainingTime,
                    builder: (context, time, child) {
                      return Text('${time.$1}h ${time.$2}m');
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MPPTGroupBox extends StatelessWidget {
  const _MPPTGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'MPPT',
      child: ValueListenableBuilder(
        valueListenable: viewmodel.mpptValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Tensão dos painel:'),
                  Text('${data.pvVoltage} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente dos paineis:'),
                  Text('${data.pvCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão da bateria:'),
                  Text('${data.batteryVoltage} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente da bateria:'),
                  Text('${data.batteryCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente do mppt:'),
                  Text('${data.mpptCurrent} A'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InstrumentationGroupBox extends StatelessWidget {
  const _InstrumentationGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'Instrumentação',
      child: ValueListenableBuilder(
        valueListenable: viewmodel.instrumentationValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Corrente Bateria:'),
                  Text('${data.batteryCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria:'),
                  Text('${data.batteryVoltage} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Bombordo:'),
                  Text('${data.motorCurrentLeft} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Boreste:'),
                  Text('${data.motorCurrentRight} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente MPPT:'),
                  Text('${data.mpptCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Bateria Auxiliar:'),
                  Text('${data.auxBatteryCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria Auxiliar:'),
                  Text('${data.auxBatteryVoltage} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Irradiância:'),
                  Text('${data.irradiance} W/m²'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MotorGroupBox extends StatelessWidget {
  const _MotorGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'Motores',
      child: Table(
        children: [
          TableRow(children: [Container(), Text('Bombordo'), Text('Boreste')]),
          TableRow(
            children: [
              Text('Tensão:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.busVoltage} V');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.busVoltage} V');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Corrente:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.busCurrent} A');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.busCurrent} A');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('RPM:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.rpm} rpm');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.rpm} rpm');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Abertura:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.acceleratorOpening} %');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.acceleratorOpening} %');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemperatureGroupBox extends StatelessWidget {
  const _TemperatureGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'Temperatura',
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: viewmodel.temperatureValueNotifier,
            builder: (context, data, child) {
              return Table(
                children: [
                  TableRow(
                    children: [
                      Text('Temp. Bateria Esquerda:'),
                      Text('${data.temperatureBatteryLeft} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. Bateria Direita:'),
                      Text('${data.temperatureBatteryRight} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. MPPT Esquerdo:'),
                      Text('${data.temperatureMPPTLeft} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. MPPT Direito:'),
                      Text('${data.temperatureMPPTRight} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. Motor:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable:
                                viewmodel.motorStateLeftValueNotifier,
                            builder: (context, motor, child) {
                              return Text('(BR) ${motor.motorTemperature} °C');
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable:
                                viewmodel.motorStateRightValueNotifier,
                            builder: (context, motor, child) {
                              return Text('(BR) ${motor.motorTemperature} °C');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. ESC:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable:
                                viewmodel.motorStateLeftValueNotifier,
                            builder: (context, motor, child) {
                              return Text(
                                '(BB) ${motor.controllerTemperature} °C',
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable:
                                viewmodel.motorStateRightValueNotifier,
                            builder: (context, motor, child) {
                              return Text(
                                '(BR) ${motor.controllerTemperature} °C',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
