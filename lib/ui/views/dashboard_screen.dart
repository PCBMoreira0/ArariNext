import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:arari_next/ui/core/widgets/cards/battery_card.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/cards/metric_card.dart';
import 'package:arari_next/ui/core/widgets/cards/propulsion_card.dart';
import 'package:arari_next/ui/viewmodels/battery_card_viewmodel.dart';
import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';
import 'package:arari_next/ui/viewmodels/propulsion_card_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<double> count = ValueNotifier(0);

  final dashboardController = DashboardController(
    initialSlotCount: 1,
    initialLayout: [LayoutItem(id: 'a', x: -1, y: -1, w: 2, h: 2)],
  );

  Map<String, String> cards = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: Text("Dashboard Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.red),
            onPressed: () {
              // TODO: viewmodels sendo recriadas quando edita ou troca o dashboard
              dashboardController.toggleEditing();
            },
          ),
          IconButton(
            onPressed: () {
              String time = DateTime.now().microsecondsSinceEpoch.toString();
              setState(() {
                cards[time] = "metric";
              });
              dashboardController.addItem(
                LayoutItem(id: time, x: -1, y: -1, w: 2, h: 2),
              );
            },
            icon: Icon(Icons.alarm, color: Colors.blue),
          ),
          IconButton(
            onPressed: () {
              String time = DateTime.now().microsecondsSinceEpoch.toString();
              setState(() {
                cards[time] = "propulsion";
              });
              dashboardController.addItem(
                LayoutItem(id: time, x: -1, y: -1, w: 1, h: 1),
              );
            },
            icon: Icon(Icons.clear, color: Colors.green),
          ),

          IconButton(
            onPressed: () {
              if (count.value == 100.0) {
                count.value = 0.0;
              } else {
                count.value += 5.0;
              }
            },
            icon: Icon(Icons.add, color: Colors.purple),
          ),
        ],
      ),
      body: Dashboard<CustomCard>(
        controller: dashboardController,

        itemBuilder: (context, item) {
          return ValueListenableBuilder(
            valueListenable: count,
            builder: (context, value, child) {
              switch (cards[item.id]) {
                case "metric":
                  return MetricCard(
                    viewModel: MetricCardViewmodel(
                      packetRepository: context.read(),
                    ),
                  );
                case "battery":
                  return BatteryCard(
                    viewModel: BatteryCardViewmodel(
                      packetRepository: context.read(),
                    ),
                  );
                case "propulsion":
                  return PropulsionCard(
                    viewModel: PropulsionCardViewmodel(
                      packetRepository: context.read(),
                    ),
                  );
              }
              return SizedBox.shrink();
            },
          );
        },

        gridStyle: const GridStyle(
          lineColor: Colors.black12, // Color of resize handles
          lineWidth: 1,
          fillColor: Colors.black12, // Highlight color for active item slot
        ),
        // Define the aspect ratio of a single slot (1x1)
        slotAspectRatio: 1,
        // Spacing between items
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,

        breakpoints: {0: 4, 600: 8, 1200: 12},

        padding: const EdgeInsets.all(10),
        trashBuilder: (context, isHovered, isArmed, activeItemId) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isArmed
                    ? Colors.red
                    : (isHovered ? Colors.orange : Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(isArmed ? Icons.delete_forever : Icons.delete),
            ),
          );
        },
        trashHoverDelay: const Duration(milliseconds: 0),
      ),
    );
  }
}
