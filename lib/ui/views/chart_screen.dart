import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/ui/core/widgets/dashboard_widget.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  DashboardModel _generateDefaultChartsModel() {
    return DashboardModel(
      id: 'default_charts',
      name: 'Gráficos do Sistema',
      layout: [
        LayoutItem(id: '1', x: -1, y: -1, w: 2, h: 1),
        LayoutItem(id: '2', x: -1, y: -1, w: 2, h: 1),
      ],
      cards: [
        MetricCardModel(id: '1', selectedMetric: 'Nível de bateria'),
        MetricCardModel(id: '2', selectedMetric: 'Tensão da bateria'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final factoryViewModel = DashboardViewModel(
      dashboardModel: _generateDefaultChartsModel(),
      dashboardController: DashboardController(),
      isReadOnly: true,
      dashboardRepository: context.read(),
      packetRepository: context.read(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Gráficos do Sistema")),
      body: DashboardWidget(viewmodel: factoryViewModel),
    );
  }
}
