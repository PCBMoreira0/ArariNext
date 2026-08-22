import 'dart:async';

import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/telemetry/telemetry_model.dart';
import 'package:arari_next/ui/core/history_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardViewModel {
  final bool isReadOnly;

  final ValueNotifier<bool> isEditingValueNotifier = ValueNotifier(false);
  final ValueNotifier<TelemetryModel> dataValueNotifier = ValueNotifier(
    TelemetryModel.empty(),
  );

  late StreamSubscription _packetSubscription;
  late final void Function() _slotCountUnsubscribe;

  final DashboardModel dashboardModel;
  final DashboardController dashboardController = DashboardController();
  final DashboardRepository _dashboardRepository;
  final ITelemetryRepository _packetRepository;
  final HistoryStore _historyStore;
  HistoryStore get historyStore => _historyStore;

  DashboardViewModel({
    required this.dashboardModel,
    required DashboardRepository dashboardRepository,
    required ITelemetryRepository packetRepository,
    required HistoryStore historyStore,
    this.isReadOnly = false,
  }) : _dashboardRepository = dashboardRepository,
       _packetRepository = packetRepository,
       _historyStore = historyStore {
    dashboardController.slotCount.subscribe(importDashboardBySlotCount);

    _packetSubscription = _packetRepository.data.listen(onNewDataReceived);
  }

  void onNewDataReceived(TelemetryModel? newData) {
    if (newData == null) return;
    dataValueNotifier.value = newData;
  }

  void addCard(CardType type) {
    if (isReadOnly) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newCard = type.createModel(id: id);
    dashboardModel.cards.add(newCard);
    final layoutItem = LayoutItem(
      id: newCard.id,
      x: 0,
      y: 0,
      w: newCard.defaultW,
      h: newCard.defaultH,
      minH: newCard.minH,
      minW: newCard.minW,
      maxH: newCard.maxH,
      maxW: newCard.maxW,
    );

    for (var entry in dashboardModel.layouts.entries) {
      entry.value.add(layoutItem);
    }

    dashboardController.addItem(layoutItem);
  }

  void toggleEditing() async {
    if (isReadOnly) return;
    if (isEditingValueNotifier.value) {
      isEditingValueNotifier.value = false;

      final int currentSlotCount = dashboardController.slotCount.value;
      dashboardModel.layouts[currentSlotCount] ??= [];
      dashboardModel.layouts[currentSlotCount]!.clear();
      dashboardModel.layouts[currentSlotCount]!.addAll(
        dashboardController.layout.value,
      );

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
      dashboardModel.layouts.forEach((slotCount, layoutItems) {
        layoutItems.removeWhere((item) => item.id == deleteCard.id);
      });
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

  void importDashboardBySlotCount(int slotCount) async {
    final List<LayoutItem> layoutItems =
        dashboardModel.layouts[slotCount] ?? [];

    if (layoutItems.isEmpty) {
      dashboardController.layout.value = dashboardModel.cards.map((card) {
        return LayoutItem(
          id: card.id,
          x: 0,
          y: 0,
          w: card.defaultW,
          h: card.defaultH,
          minH: card.minH,
          minW: card.minW,
          maxH: card.maxH,
          maxW: card.maxW,
        );
      }).toList();

      dashboardModel.layouts[slotCount] = dashboardController.layout.value;
      await _saveDashboard();
    } else {
      final jsonLayout = layoutItems.map((item) => item.toMap()).toList();
      dashboardController.importLayout(jsonLayout);
    }

    // for (var card in dashboardModel.cards) {
    //   bool found = false;
    //   for (var layout in layoutItems) {
    //     if (layout.id == card.id) {
    //       found = true;
    //       break;
    //     }
    //   }

    //   if (found == false) {
    //     dashboardController.addItem(
    //       LayoutItem(
    //         id: card.id,
    //         x: -1,
    //         y: -1,
    //         w: card.defaultW,
    //         h: card.defaultH,
    //         minH: card.minH,
    //         minW: card.minW,
    //         maxH: card.maxH,
    //         maxW: card.maxW,
    //       ),
    //     );
    //   }
    // }

    // dashboardModel.layouts[slotCount] ??= [];
    // dashboardModel.layouts[slotCount]!.clear();
    // dashboardModel.layouts[slotCount]!.addAll(dashboardController.layout.value);

    // await _saveDashboard();
  }

  void dispose() {
    _packetSubscription.cancel();
    _slotCountUnsubscribe();
    dashboardController.dispose();
    dataValueNotifier.dispose();
    isEditingValueNotifier.dispose();
  }
}
