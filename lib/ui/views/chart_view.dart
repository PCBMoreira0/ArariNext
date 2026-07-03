import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/viewmodels/chart_viewmodel.dart';
import 'package:flutter/material.dart';

class ChartView extends StatelessWidget {
  final ChartViewmodel viewModel;

  const ChartView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Charts")),
      drawer: const SideMenu(),
      body: Text("Chart View"),
    );
  }
}
