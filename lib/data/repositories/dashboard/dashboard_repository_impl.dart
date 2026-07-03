import 'dart:convert';

import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  static const _fileName = 'dashboards.json';

  final FileStorageService _fileStorageService;

  List<DashboardModel> _dashboardsCache = [];
  bool _isInitialized = false;

  DashboardRepositoryImpl({required FileStorageService fileStorageService})
    : _fileStorageService = fileStorageService;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      String? content = await _fileStorageService.read(_fileName);
      if (content != null && content.isNotEmpty) {
        final json = jsonDecode(content);
        _dashboardsCache = (json as List)
            .map((e) => DashboardModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      _dashboardsCache = [];
    } finally {
      _isInitialized = true;
    }
  }

  @override
  Future<List<DashboardModel>> loadDashboards() async {
    if (!_isInitialized) {
      await initialize();
    }

    return List.unmodifiable(_dashboardsCache);
  }

  @override
  Future<DashboardModel?> getDashboardById(String id) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return _dashboardsCache.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveDashboard(DashboardModel dashboard) async {
    final index = _dashboardsCache.indexWhere((d) => d.id == dashboard.id);

    if (index == -1) {
      _dashboardsCache.add(dashboard);
    } else {
      _dashboardsCache[index] = dashboard;
    }

    await _saveCacheToDisk();
  }

  @override
  Future<void> deleteDashboard(String id) async {
    _dashboardsCache.removeWhere((d) => d.id == id);
    await _saveCacheToDisk();
  }

  Future<void> _saveCacheToDisk() async {
    final jsonString = jsonEncode(
      _dashboardsCache.map((e) => e.toJson()).toList(),
    );
    await _fileStorageService.write(_fileName, jsonString);
  }
}
