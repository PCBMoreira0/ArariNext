import 'package:arari_next/domain/settings/mqtt_settings.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';

class ConnectionSettings {
  final SerialSettings serialSetting;
  final MqttSettings mqttSetting;

  ConnectionSettings({
    required this.serialSetting,
    required this.mqttSetting,
  });

  factory ConnectionSettings.fromJson(Map<String, dynamic> json) {
    return ConnectionSettings(
      serialSetting: SerialSettings.fromJson(json['serialSetting']),
      mqttSetting: MqttSettings.fromJson(json['mqttSetting']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serialSetting': serialSetting.toJson(),
      'mqttSetting': mqttSetting.toJson(),
    };
  }
}