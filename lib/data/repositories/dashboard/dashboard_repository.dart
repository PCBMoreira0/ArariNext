import 'package:arari_next/domain/dashboard/dashboard_model.dart';

abstract class DashboardRepository {
  Future<List<DashboardModel>> loadDashboards();

  Future<void> saveDashboard(DashboardModel dashboard);

  Future<void> deleteDashboard(String id);
}
