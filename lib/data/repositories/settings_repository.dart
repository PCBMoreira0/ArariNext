import 'package:arari_next/domain/settings/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings get settings;
  Future<void> save(AppSettings setting);
  Future<void> initialize();
}
