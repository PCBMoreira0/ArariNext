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

              return ValueListenableBuilder(
                valueListenable: dashboardVM.isEditingValueNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (value)
                        IconButton(
                          onPressed: () => dashboardVM.addCard(CardType.metric),
                          icon: const Icon(Icons.add, color: Colors.purple),
                        ),
                      if (value)
                        IconButton(
                          onPressed: () =>
                              dashboardVM.addCard(CardType.propulsion),
                          icon: const Icon(
                            Icons.rotate_90_degrees_cw_sharp,
                            color: Colors.purple,
                          ),
                        ),
                      if (value)
                        IconButton(
                          onPressed: () =>
                              dashboardVM.addCard(CardType.battery),
                          icon: const Icon(
                            Icons.battery_0_bar,
                            color: Colors.yellow,
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          color: value ? Colors.green : Colors.red,
                        ),
                        onPressed: () => dashboardVM.toggleEditing(),
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
