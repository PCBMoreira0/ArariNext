import 'dart:async';

import 'package:arari_next/domain/models/iboat_data.dart';
import 'package:flutter/material.dart';

abstract class PacketRepository {
  Stream<IBoatData?> get data;
}