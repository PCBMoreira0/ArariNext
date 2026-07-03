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
    if (widget.viewmodel.isLoading) {
      return Scaffold(
        drawer: const SideMenu(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final dashboardViewmodel = widget.viewmodel.dashboardViewmodel!;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
        actions: [
          ListenableBuilder(
            listenable: dashboardViewmodel,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: dashboardViewmodel.isEditing
                          ? Colors.green
                          : Colors.red,
                    ),
                    onPressed: () => dashboardViewmodel.toggleEditing(),
                  ),

                  if (dashboardViewmodel.isEditing)
                    IconButton(
                      onPressed: () =>
                          dashboardViewmodel.addCard(CardType.metric),
                      icon: const Icon(Icons.add, color: Colors.purple),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: DashboardWidget(viewmodel: dashboardViewmodel),
    );
  }
}
