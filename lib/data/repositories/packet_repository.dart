import 'dart:async';

import 'package:arari_next/domain/models/iboat_data.dart';

abstract class PacketRepository {
  Stream<IBoatData?> get data;
}