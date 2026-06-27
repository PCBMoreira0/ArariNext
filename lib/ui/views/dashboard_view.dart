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
        valueListenable: viewmodel.fullBoatDataValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Tensão Total:'),
                  Text('${data.bmsData.totalVoltage} V'),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente:'),
                  Text('${data.bmsData.batteryCurrent} A'),
                ],
              ),
              TableRow(
                children: [
                  Text('Estado de carga:'),
                  Text('${data.bmsData.stateOfCharge} %'),
                ],
              ),
              TableRow(
                children: [
                  Text('Tempo R. c/ geracao:'),
                  Text(
                    '${data.batteryRemainingTimeEstimation.hora}h ${data.batteryRemainingTimeEstimation.minuto}m',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Tempo R. s/ geracao:'),
                  Text(
                    '${data.batteryTimeWithoutGeneration.hora}h ${data.batteryTimeWithoutGeneration.minuto}m',
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
        valueListenable: viewmodel.fullBoatDataValueNotifier,
        builder: (context, data, child) {
          return Column(
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      Text('Tensão dos painel:'),
                      Text('${data.mpptData.pvVoltage} V'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Corrente dos paineis:'),
                      Text('${data.mpptData.pvCurrent} A'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Tensão da bateria:'),
                      Text('${data.mpptData.batteryVoltage} V'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Corrente da bateria:'),
                      Text('${data.mpptData.batteryCurrent} A'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Corrente do mppt:'),
                      Text('${data.mpptData.mpptCurrent} A'),
                    ],
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
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
                                  Text(
                                    '${data.instrumentationData.panelStrings.string1}',
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text('String 2:'),
                                  Text(
                                    '${data.instrumentationData.panelStrings.string2}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Text('String 3:'),
                                  Text(
                                    '${data.instrumentationData.panelStrings.string3}',
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text('String 4:'),
                                  Text(
                                    '${data.instrumentationData.panelStrings.string4}',
                                  ),
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
        valueListenable: viewmodel.fullBoatDataValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Corrente Bateria:'),
                  Text(
                    '${data.instrumentationData.batteryCurrent.toStringAsFixed(2)} A',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria:'),
                  Text(
                    '${data.instrumentationData.batteryVoltage.toStringAsFixed(2)} V',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Bombordo:'),
                  Text(
                    '${data.instrumentationData.motorCurrentLeft.toStringAsFixed(2)} A',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Motor Boreste:'),
                  Text(
                    '${(data.instrumentationData.motorCurrentRight * -1).toStringAsFixed(2)} A',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente MPPT:'),
                  Text(
                    '${data.instrumentationData.mpptCurrent.toStringAsFixed(2)} A',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Corrente Bateria Auxiliar:'),
                  Text(
                    '${data.instrumentationData.auxBatteryCurrent.toStringAsFixed(2)} A',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Tensão Bateria Auxiliar:'),
                  Text(
                    '${data.instrumentationData.auxBatteryVoltage.toStringAsFixed(2)} V',
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text('Irradiância:'),
                  Text(
                    '${data.instrumentationData.irradiance.toStringAsFixed(2)} W/m²',
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

class _GPSGroupBox extends StatelessWidget {
  const _GPSGroupBox({required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return GroupBox(
      title: 'GPS',
      child: ValueListenableBuilder(
        valueListenable: viewmodel.fullBoatDataValueNotifier,
        builder: (context, data, child) {
          return Table(
            children: [
              TableRow(
                children: [
                  Text('Velocidade:'),
                  Text('${(data.gpsData.speed).toStringAsFixed(2)} Knt'),
                ],
              ),
              TableRow(
                children: [
                  Text('Satélites:'),
                  Text('${data.gpsData.visibleSatellites}'),
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
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataLeft.busVoltage} V');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataRight.busVoltage} V');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Corrente:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataLeft.busCurrent} A');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataRight.busCurrent} A');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('RPM:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataLeft.rpm} rpm');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorEletricalDataRight.rpm} rpm');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Abertura:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text(
                    '${data.motorEletricalDataLeft.acceleratorOpening} %',
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text(
                    '${data.motorEletricalDataRight.acceleratorOpening} %',
                  );
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Temp. Motor:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorStateDataLeft.motorTemperature} °C');
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text('${data.motorStateDataRight.motorTemperature} °C');
                },
              ),
            ],
          ),
          TableRow(
            children: [
              Text('Temp. ESC:'),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text(
                    '${data.motorStateDataLeft.controllerTemperature} °C',
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: viewmodel.fullBoatDataValueNotifier,
                builder: (context, data, child) {
                  return Text(
                    '${data.motorStateDataRight.controllerTemperature} °C',
                  );
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
                  valueListenable: viewmodel.fullBoatDataValueNotifier,
                  builder: (context, data, child) {
                    return ListView.builder(
                      itemCount: data.motorStateDataLeft.errorFlags.length,
                      itemBuilder: (context, index) {
                        return Text(data.motorStateDataLeft.errorFlags[index].name);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 80, // altura mínima/fixa da célula
                child: ValueListenableBuilder(
                  valueListenable: viewmodel.fullBoatDataValueNotifier,
                  builder: (context, data, child) {
                    return ListView.builder(
                      itemCount: data.motorStateDataRight.errorFlags.length,
                      itemBuilder: (context, index) {
                        return Text(data.motorStateDataRight.errorFlags[index].name);
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
            valueListenable: viewmodel.fullBoatDataValueNotifier,
            builder: (context, data, child) {
              return Table(
                children: [
                  TableRow(
                    children: [
                      Text('Temp. Bateria Esquerda:'),
                      Text('${data.temperatureData.temperatureBatteryLeft} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. Bateria Direita:'),
                      Text(
                        '${data.temperatureData.temperatureBatteryRight} °C',
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. MPPT Esquerdo:'),
                      Text('${data.temperatureData.temperatureMPPTLeft} °C'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Temp. MPPT Direito:'),
                      Text('${data.temperatureData.temperatureMPPTRight} °C'),
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
