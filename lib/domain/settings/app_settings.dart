import 'package:arari_next/domain/settings/connection_settings.dart';
import 'package:arari_next/domain/settings/log_settings.dart';

class AppSettings {
  final ConnectionSettings connectionSetting;
  final LogSettings logSettings;

  const AppSettings({
    this.connectionSetting = const ConnectionSettings(),
    this.logSettings = const LogSettings(),
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      connectionSetting: ConnectionSettings.fromJson(json['connectionSetting']),
      logSettings: LogSettings.fromJson(json['logSettings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connectionSetting': connectionSetting.toJson(),
      'logSettings': logSettings.toJson(),
    };
  }

  AppSettings copyWith({
    ConnectionSettings? connectionSetting,
    LogSettings? logSettings,
  }) {
    return AppSettings(
      connectionSetting: connectionSetting ?? this.connectionSetting,
      logSettings: logSettings ?? this.logSettings,
    );
  }
}
