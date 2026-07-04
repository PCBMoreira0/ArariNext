import 'dart:async';

import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardViewModel {
  final bool isReadOnly;

  final ValueNotifier<bool> isEditingValueNotifier = ValueNotifier(false);
  final ValueNotifier<FullBoatData> dataValueNotifier = ValueNotifier(
    FullBoatData.empty(),
  );

  late StreamSubscription _packetSubscription;

  final DashboardModel dashboardModel;
  final DashboardController dashboardController;
  final DashboardRepository _dashboardRepository;
  final PacketRepository _packetRepository;

  DashboardViewModel({
    required this.dashboardModel,
    required this.dashboardController,
    required DashboardRepository dashboardRepository,
    required PacketRepository packetRepository,
    this.isReadOnly = false,
  }) : _dashboardRepository = dashboardRepository,
       _packetRepository = packetRepository {
    dashboardController.importLayout(dashboardModel.toJson()['layout']);

    _packetSubscription = _packetRepository.data.listen(onNewDataReceived);
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    dataValueNotifier.value = newData;
  }

  void addCard(CardType type) {
    if (isReadOnly) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newCard = type.createModel(id);
    dashboardModel.cards.add(newCard);
    dashboardController.addItem(
      LayoutItem(
        id: newCard.id,
        x: -1,
        y: -1,
        w: newCard.defaultW,
        h: newCard.defaultH,
        minH: newCard.minH,
        minW: newCard.minW,
        maxH: newCard.maxH,
        maxW: newCard.maxW,
      ),
    );
  }

  void toggleEditing() async {
    if (isReadOnly) return;
    if (isEditingValueNotifier.value) {
      isEditingValueNotifier.value = false;

      dashboardModel.layout.clear();
      dashboardModel.layout.addAll(dashboardController.layout.value);

      dashboardController.toggleEditing();
      await _saveDashboard();
    } else {
      isEditingValueNotifier.value = true;
      dashboardController.toggleEditing();
    }
  }

  void updateCard(CardModel updatedCard) async {
    final index = dashboardModel.cards.indexWhere(
      (card) => card.id == updatedCard.id,
    );
    if (index != -1) {
      dashboardModel.cards[index] = updatedCard;
      await _saveDashboard();
    }
  }

  void deleteCard(CardModel deleteCard) async {
    if (isReadOnly) return;
    final index = dashboardModel.cards.indexWhere(
      (card) => card.id == deleteCard.id,
    );

    if (index != -1) {
      dashboardController.removeItem(deleteCard.id);
      dashboardModel.cards.removeAt(index);
      await _saveDashboard();
    }
  }

  void deleteCards(List<CardModel> cards) {
    for (var card in cards) {
      deleteCard(card);
    }
  }

  void deleteCardsByLayoutItem(List<LayoutItem> items) {
    for (var item in items) {
      deleteCards(dashboardModel.cards.where((c) => c.id == item.id).toList());
    }
  }

  Future<void> _saveDashboard() async {
    await _dashboardRepository.saveDashboard(dashboardModel);
  }

  void dispose() {
    _packetSubscription.cancel();
    dashboardController.dispose();
    dataValueNotifier.dispose();
    isEditingValueNotifier.dispose();
  }
}
