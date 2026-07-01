import 'package:arari_next/domain/settings/connection_settings.dart';

class AppSettings {
  final ConnectionSettings connectionSetting;

  AppSettings({
    required this.connectionSetting,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      connectionSetting: ConnectionSettings.fromJson(
        json['connectionSetting'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connectionSetting': connectionSetting.toJson(),
    };
  }
}