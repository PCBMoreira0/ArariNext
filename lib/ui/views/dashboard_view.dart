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
      appBar: AppBar(title: Text("Dashboard"),),
      drawer: const SideMenu(),
      body: ListenableBuilder(
        listenable: widget.viewmodel,
        builder: (context, child) => ListView(
          children: [
            Text('Latitude: ${widget.viewmodel.gpsData?.latitude ?? "--"}'),
            Text('Longitude: ${widget.viewmodel.gpsData?.longitude ?? "--"}'),
            Text('Course: ${widget.viewmodel.gpsData?.course ?? "--"}'),
            Text('Speed: ${widget.viewmodel.gpsData?.speed ?? "--"}'),
          ]
        )
      ),
    );
  }
}
