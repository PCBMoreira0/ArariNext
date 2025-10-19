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
                Expanded(child: _GPSGroupBox(viewmodel: widget.viewmodel)),
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
          return Column(
            children: [
              Table(
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
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.instrumentationValueNotifier,
                builder: (context, data, child) {
                  return Table(
                    children: [
                      TableRow(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Text('String 1:'),
                                  Text('${data.panelStrings.string1}'),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text('String 2:'),
                                  Text('${data.panelStrings.string2}'),
                                ],
                              ),
                            ],
                          ),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Text('String 3:'),
                                  Text('${data.panelStrings.string3}'),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text('String 4:'),
                                  Text('${data.panelStrings.string4}'),
                                ],
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
                  Text('${data.batteryCurrent.toStringAsFixed(2)} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria:'),
                  Text('${data.batteryVoltage.toStringAsFixed(2)} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Bombordo:'),
                  Text('${data.motorCurrentLeft.toStringAsFixed(2)} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Boreste:'),
                  Text('${(data.motorCurrentRight * -1).toStringAsFixed(2)} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente MPPT:'),
                  Text('${data.mpptCurrent.toStringAsFixed(2)} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Bateria Auxiliar:'),
                  Text('${data.auxBatteryCurrent.toStringAsFixed(2)} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria Auxiliar:'),
                  Text('${data.auxBatteryVoltage.toStringAsFixed(2)} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Irradiância:'),
                  Text('${data.irradiance.toStringAsFixed(2)} W/m²'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GPSGroupBox extends StatelessWidget {
  const _GPSGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'GPS',
      child: ValueListenableBuilder(
        valueListenable: viewmodel.gpsValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Velocidade:'),
                  Text('${(data.speed * 0.0194384).toStringAsFixed(2)} Knt'),
                ],
              ),
              TableRow(
                children: [
                  Text('Satélites:'),
                  Text('${data.visibleSatellites}'),
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
          TableRow(
            children: [
              Text('Temp. Motor:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorStateLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.motorTemperature} °C');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorStateRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.motorTemperature} °C');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Temp. ESC:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorStateLeftValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.controllerTemperature} °C');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.motorStateRightValueNotifier,
                builder: (context, motor, child) {
                  return Text('${motor.controllerTemperature} °C');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Erros:'),
              SizedBox(
                height: 80, // altura mínima/fixa da célula
                child: ValueListenableBuilder(
                  valueListenable: viewmodel.motorStateLeftValueNotifier,
                  builder: (context, motor, child) {
                    return ListView.builder(
                      itemCount: motor.errorFlags.length,
                      itemBuilder: (context, index) {
                        return Text('${motor.errorFlags[index]}');
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 80, // altura mínima/fixa da célula
                child: ValueListenableBuilder(
                  valueListenable: viewmodel.motorStateRightValueNotifier,
                  builder: (context, motor, child) {
                    return ListView.builder(
                      itemCount: motor.errorFlags.length,
                      itemBuilder: (context, index) {
                        return Text('${motor.errorFlags[index]}');
                      },
                    );
                  },
                ),
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
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
