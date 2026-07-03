import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardState extends ChangeNotifier {
  final DashboardController dashboardController;

  DashboardModel dashboardModel;

  bool isEditing = false;

  final DashboardRepository _dashboardRepository;

  DashboardState({
    DashboardModel? initialModel,
    DashboardController? dashboardController,
    required DashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository,
       dashboardModel =
           initialModel ??
           DashboardModel(
             id: DateTime.now().microsecondsSinceEpoch.toString(),
             name: "My Dashboard",
             layout: [],
             cards: [],
           ),
       dashboardController = dashboardController ?? DashboardController();

  static Future<DashboardState> create(
    String? id,
    DashboardRepository dashboardRepository,
  ) async {
    final dashboards = await dashboardRepository.loadDashboards();
    final index = dashboards.indexWhere((d) => d.id == id);

    if (index == -1) {
      return DashboardState(
        initialModel: id != null
            ? DashboardModel(
                id: id,
                name: 'My Dashboard',
                layout: [],
                cards: [],
              )
            : null,
        dashboardRepository: dashboardRepository,
      );
    }

    final dashboardModel = dashboards[index];
    final dashboardController = DashboardController();
    dashboardController.importLayout(dashboardModel.toJson()['layout']);

    return DashboardState(
      dashboardRepository: dashboardRepository,
      dashboardController: dashboardController,
      initialModel: dashboardModel,
    );
  }

  CardModel _createCardByType(CardType type) {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();

    switch (type) {
      case CardType.metric:
        return MetricCardModel(
          id: id,
          type: type,
          selectedMetric: MetricsCatalog.bms.first.label,
        );
      case CardType.propulsion:
        return MetricCardModel(
          id: id,
          type: type,
          selectedMetric: MetricsCatalog.motor.first.label,
        );
      case CardType.battery:
        return MetricCardModel(
          id: id,
          type: type,
          selectedMetric: MetricsCatalog.bms.first.label,
        );
    }
  }

  void addCard(CardType type) {
    final newCard = _createCardByType(type);
    dashboardModel.cards.add(newCard);
    dashboardController.addItem(
      LayoutItem(id: newCard.id, x: -1, y: -1, w: 1, h: 1),
    );
    notifyListeners();
  }

  void toggleEditing() async {
    if (isEditing) {
      isEditing = false;
      dashboardModel = dashboardModel.copyWith(
        layout: dashboardController.layout.value,
      );
      await _saveDashboard();
      dashboardController.toggleEditing();
      notifyListeners();
    } else {
      isEditing = true;
      dashboardController.toggleEditing();
    }
  }

  void updateCard(CardModel updatedCard) async {
    final index = dashboardModel.cards.indexWhere(
      (card) => card.id == updatedCard.id,
    );
    if (index != -1) {
      dashboardModel.cards[index] = updatedCard;
      notifyListeners();
      await _saveDashboard();
    }
  }

  Future<void> _saveDashboard() async {
    await _dashboardRepository.saveDashboard(dashboardModel);
  }
}
