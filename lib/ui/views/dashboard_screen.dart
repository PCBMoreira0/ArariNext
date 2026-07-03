import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/core/utils/dashboard_state.dart';
import 'package:arari_next/ui/core/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardState dashboardState;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    init(context);
  }

  Future<void> init(BuildContext context) async {
    dashboardState = await DashboardState.create('l1', context.read());

    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: Text("Dashboard Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.red),
            onPressed: () {
              dashboardState.toggleEditing();
            },
          ),
          IconButton(
            onPressed: () async {
              final state = await DashboardState.create('l1', context.read());
              setState(() {
                dashboardState = state;
              });
            },
            icon: Icon(Icons.table_chart_outlined, color: Colors.blue),
          ),
          IconButton(
            onPressed: () async {
              final state = await DashboardState.create('l2', context.read());
              setState(() {
                dashboardState = state;
              });
            },
            icon: Icon(Icons.clear, color: Colors.green),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                dashboardState.addCard(CardType.metric);
              });
            },
            icon: Icon(Icons.add, color: Colors.purple),
          ),
        ],
      ),
      body: DashboardWidget(state: dashboardState),
    );
  }
}
