import 'dart:async';

import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/models/gps_data.dart';
import 'package:flutter/widgets.dart';

class DashboardViewmodel extends ChangeNotifier {
  final PacketRepository _packetRepository;

  StreamSubscription? gpsStream;

  GPSData? _gpsData;

  GPSData? get gpsData => _gpsData;

  DashboardViewmodel({required PacketRepository repository}) : _packetRepository = repository {
    gpsStream = _packetRepository.gpsData.listen(updateGps);
  }

  void updateGps(GPSData gps){
    _gpsData = gps;
    notifyListeners();
  }
}