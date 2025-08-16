import 'dart:typed_data';

abstract class ISerialService {
  bool open();
  void close();
  bool write(Uint8List bytes);
  Stream<Uint8List> read();
}