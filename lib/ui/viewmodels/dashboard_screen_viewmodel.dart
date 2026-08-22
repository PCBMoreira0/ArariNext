import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/ui/core/history_store.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';

class DashboardScreenViewmodel extends ChangeNotifier {
  DashboardModel? dashboard;
  DashboardViewModel? dashboardViewmodel;

  bool isLoading = true;

  final String id = "dash";

  final DashboardRepository _dashboardRepository;
  final ITelemetryRepository _packetRepository;
  final HistoryStore _historyStore;

  DashboardScreenViewmodel({
    required DashboardRepository dashboardRepository,
    required ITelemetryRepository packetRepository,
    required HistoryStore historyStore,
  }) : _dashboardRepository = dashboardRepository,
       _packetRepository = packetRepository,
       _historyStore = historyStore {
    init();
  }

  Future<void> init() async {
    isLoading = true;

    dashboard = await _dashboardRepository.getDashboardById(id);

    dashboard ??= DashboardModel.empty(id);

    dashboardViewmodel = DashboardViewModel(
      historyStore: _historyStore,
      dashboardModel: dashboard!,
      dashboardRepository: _dashboardRepository,
      packetRepository: _packetRepository,
    );

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    dashboardViewmodel?.dispose();
    super.dispose();
  }
}
