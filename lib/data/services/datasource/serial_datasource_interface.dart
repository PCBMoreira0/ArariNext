
import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/domain/settings/serial_settings.dart';

abstract class ISerialDatasource implements IDataSource {
  void setConfig(SerialSettings config);
  List<String> availablePorts();
}