import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/viewmodels/dashboard_screen_viewmodel.dart';
import 'package:arari_next/ui/core/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardScreenViewmodel viewmodel;

  const DashboardScreen({super.key, required this.viewmodel});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await widget.viewmodel.init();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.red),
            onPressed: () {
              widget.viewmodel.dashboardViewmodel?.toggleEditing();
            },
          ),
          IconButton(
            onPressed: () {
              widget.viewmodel.dashboardViewmodel?.addCard(CardType.metric);
            },
            icon: const Icon(Icons.add, color: Colors.purple),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DashboardWidget(viewmodel: widget.viewmodel.dashboardViewmodel!),
    );
  }
}
