import 'dart:typed_data';

import 'package:arari_next/data/services/datasource/connection_event.dart';

abstract interface class IDataSource {
  void connect();
  void disconnect();
  void dispose();

  Stream<Uint8List> get stream;
  Stream<ConnectionEvent> get statusStream;
  ConnectionStatus get status;
}