import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/domain/dashboard/propulsion_card_model.dart';
import 'package:arari_next/ui/core/widgets/cards/propulsion_card.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
import 'package:arari_next/ui/core/widgets/cards/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardWidget extends StatelessWidget {
  final DashboardViewModel viewmodel;

  const DashboardWidget({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Dashboard<CustomCard>(
      controller: viewmodel.dashboardController,
    
      itemBuilder: (context, item) {
        CardModel card = viewmodel.dashboardModel.cards.firstWhere(
          (c) => c.id == item.id,
        );
        switch (card.type) {
          case CardType.metric:
            return MetricCard(
              initialModel: card as MetricCardModel,
              boatDataListenable: viewmodel.dataValueNotifier,
              onConfigChanged: viewmodel.updateCard,
            );
          case CardType.propulsion:
            return PropulsionCard(
              boatDataListenable: viewmodel.dataValueNotifier,
              initialModel: card as PropulsionCardModel,
              onConfigChanged: viewmodel.updateCard,
            );
          case CardType.battery:
            return CustomCard(title: "title", child: Text("data"));
        }
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
      onItemsDeleted: viewmodel.deleteCardsByLayoutItem,
      trashHoverDelay: const Duration(milliseconds: 0),
    );
  }
}
