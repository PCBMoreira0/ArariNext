
import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/domain/settings/mqtt_settings.dart';

abstract class IMqttDataSource implements IDataSource {
  Future<void> setConfig(MqttSettings config);
  void setTopic(String topic);
}