import 'dart:async';

import 'package:arari_next/data/repositories/settings/settings_repository.dart';
import 'package:arari_next/domain/settings/app_settings.dart';
import 'package:arari_next/domain/settings/log_settings.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';

class SettingsManager {
  final SettingsRepository _settingsRepository;

  SettingsManager({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  SerialSettings get serial {
    return _settingsRepository.settings.connectionSetting.serialSetting;
  }

  Future<void> setSerial(SerialSettings serial) async {
    final AppSettings oldSettings = _settingsRepository.settings;
    final AppSettings newSettings = oldSettings.copyWith(
      connectionSetting: oldSettings.connectionSetting.copyWith(
        serialSetting: serial,
      ),
    );
    _settingsRepository.save(newSettings);
  }

  LogSettings get log => _settingsRepository.settings.logSettings;

  Future<void> setLog(LogSettings log) async {
    final AppSettings oldSettings = _settingsRepository.settings;
    final AppSettings newSettings = oldSettings.copyWith(logSettings: log);
    _settingsRepository.save(newSettings);
  }
}
