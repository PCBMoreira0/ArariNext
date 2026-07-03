import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/packet/packet_repository.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardScreenViewmodel extends ChangeNotifier {
  DashboardModel? dashboard;
  DashboardViewModel? dashboardViewmodel;

  bool isLoading = true;

  final String id = "dash";

  final DashboardRepository _dashboardRepository;
  final PacketRepository _packetRepository;

  DashboardScreenViewmodel({
    required DashboardRepository dashboardRepository,
    required PacketRepository packetRepository,
  }) : _dashboardRepository = dashboardRepository,
       _packetRepository = packetRepository;

  Future<void> init() async {
    dashboard = await _dashboardRepository.getDashboardById(id);

    dashboard ??= DashboardModel.empty(id);

    dashboardViewmodel = DashboardViewModel(
      dashboardModel: dashboard!,
      dashboardController: DashboardController(),
      dashboardRepository: _dashboardRepository,
      packetRepository: _packetRepository,
    );

    isLoading = false;
    notifyListeners();
  }
}
