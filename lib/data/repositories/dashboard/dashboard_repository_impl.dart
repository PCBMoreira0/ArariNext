import 'dart:convert';

import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  static const _fileName = 'dashboards.json';

  final FileStorageService _fileStorageService;

  DashboardRepositoryImpl({required FileStorageService fileStorageService})
    : _fileStorageService = fileStorageService;

  @override
  Future<List<DashboardModel>> loadDashboards() async {
    final json = jsonDecode(await _fileStorageService.read(_fileName) ?? "[]");

    return (json as List).map((e) => DashboardModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveDashboard(DashboardModel dashboard) async {
    final dashboards = await loadDashboards();

    final index = dashboards.indexWhere((d) => d.id == dashboard.id);

    if (index == -1) {
      dashboards.add(dashboard);
    } else {
      dashboards[index] = dashboard;
    }

    await _fileStorageService.write(
      _fileName,
      jsonEncode(dashboards.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteDashboard(String id) async {
    final dashboards = await loadDashboards();
    dashboards.removeWhere((d) => d.id == id);

    await _fileStorageService.write(
      _fileName,
      jsonEncode(dashboards.map((e) => e.toJson()).toList()),
    );
  }
}
