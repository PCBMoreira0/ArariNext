import 'dart:convert';

import 'package:arari_next/data/repositories/settings_repository.dart';
import 'package:arari_next/data/services/file_storage_service.dart';
import 'package:arari_next/domain/settings/app_settings.dart';

class LocalSettingsRepository implements SettingsRepository {
  static const _fileName = 'settings.json';

  AppSettings _settings = const AppSettings();

  final FileStorageService _fileStorageService;

  AppSettings get settings => _settings;

  LocalSettingsRepository({required FileStorageService fileStorageService})
    : _fileStorageService = fileStorageService;

  @override
  Future<void> initialize() async {
    final content = await _fileStorageService.read(_fileName);

    if (content == null) {
      return;
    }

    _settings = AppSettings.fromJson(jsonDecode(content));
  }

  @override
  Future<void> save(AppSettings setting) async {
    _settings = setting;

    await _fileStorageService.write(_fileName, jsonEncode(setting.toJson()));
  }
}
