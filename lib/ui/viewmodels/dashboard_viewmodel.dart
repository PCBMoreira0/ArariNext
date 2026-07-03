import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';
import 'package:arari_next/ui/core/utils/metrics_catalog.dart';
import 'package:arari_next/ui/viewmodels/metric_card_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardModel dashboardModel;
  final DashboardController dashboardController;
  final DashboardRepository _dashboardRepository;
  final PacketRepository _packetRepository;
  final bool isReadOnly;
  bool isEditing = false;

  final Map<String, dynamic> viewModelsCache = {};

  DashboardViewModel({
    required this.dashboardModel,
    required this.dashboardController,
    required DashboardRepository dashboardRepository,
    required PacketRepository packetRepository,
    this.isReadOnly = false,
  }) : _dashboardRepository = dashboardRepository,
       _packetRepository = packetRepository {
    dashboardController.importLayout(dashboardModel.toJson()['layout']);
  }

  CardModel _createCardByType(String id, CardType type) {
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

  void _createViewModelByModel(CardModel model) {
    switch (model.type) {
      case CardType.metric:
        viewModelsCache[model.id] = MetricCardViewmodel(
          packetRepository: _packetRepository,
          model: model as MetricCardModel,
          onConfigChanged: updateCard,
        );
        break;
      case CardType.propulsion:
        throw UnimplementedError();
      case CardType.battery:
        throw UnimplementedError();
    }
  }

  dynamic getViewModel(CardModel card) {
    if (!viewModelsCache.containsKey(card.id)) {
      _createViewModelByModel(card);
    }
    return viewModelsCache[card.id];
  }

  void addCard(CardType type) {
    if (isReadOnly) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newCard = _createCardByType(id, type);
    dashboardModel.cards.add(newCard);
    dashboardController.addItem(
      LayoutItem(id: newCard.id, x: -1, y: -1, w: 1, h: 1),
    );
    _createViewModelByModel(newCard);
    notifyListeners();
  }

  void toggleEditing() async {
    if (isReadOnly) return;
    if (isEditing) {
      isEditing = false;

      for (var l in dashboardController.layout.value) {
        dashboardModel.layout.add(l);
      }

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

  void deleteCard(CardModel deleteCard) async {
    if (isReadOnly) return;
    final index = dashboardModel.cards.indexWhere(
      (card) => card.id == deleteCard.id,
    );
    if (index != -1) {
      viewModelsCache.remove(deleteCard.id);
      dashboardController.removeItem(deleteCard.id);
      dashboardModel.cards.removeAt(index);
      notifyListeners();
      await _saveDashboard();
    }
  }

  Future<void> _saveDashboard() async {
    await _dashboardRepository.saveDashboard(dashboardModel);
  }
}
