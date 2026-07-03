import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/viewmodels/dashboard_screen_viewmodel.dart';
import 'package:arari_next/ui/core/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardScreenViewmodel viewmodel;

  const DashboardScreen({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
        actions: [
          ListenableBuilder(
            listenable: viewmodel,
            builder: (context, child) {
              final dashboardVM = viewmodel.dashboardViewmodel;

              if (viewmodel.isLoading || dashboardVM == null) {
                return const SizedBox.shrink();
              }

              return ListenableBuilder(
                listenable: dashboardVM,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          color: dashboardVM.isEditing
                              ? Colors.green
                              : Colors.red,
                        ),
                        onPressed: () => dashboardVM.toggleEditing(),
                      ),
                      if (dashboardVM.isEditing)
                        IconButton(
                          onPressed: () => dashboardVM.addCard(CardType.metric),
                          icon: const Icon(Icons.add, color: Colors.purple),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewmodel,
        builder: (context, child) {
          final dashboardVM = viewmodel.dashboardViewmodel;

          if (viewmodel.isLoading || dashboardVM == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return DashboardWidget(viewmodel: dashboardVM);
        },
      ),
    );
  }
}
