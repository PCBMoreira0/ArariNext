import 'package:arari_next/domain/settings/mqtt_settings.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';

class ConnectionSettings {
  final SerialSettings serialSetting;
  final MqttSettings mqttSetting;

  const ConnectionSettings({
    this.serialSetting = const SerialSettings(),
    this.mqttSetting = const MqttSettings(),
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

  ConnectionSettings copyWith({
    SerialSettings? serialSetting,
    MqttSettings? mqttSetting,
  }) {
    return ConnectionSettings(
      serialSetting: serialSetting ?? this.serialSetting,
      mqttSetting: mqttSetting ?? this.mqttSetting,
    );
  }
}
