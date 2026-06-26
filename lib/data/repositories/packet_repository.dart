import 'dart:async';

import 'package:arari_next/domain/models/full_boat_data.dart';

abstract class PacketRepository {
  Stream<FullBoatData?> get data;
}