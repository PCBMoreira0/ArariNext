import 'dart:typed_data';

abstract interface class ISerialService {
  Stream<Uint8List> read();
}