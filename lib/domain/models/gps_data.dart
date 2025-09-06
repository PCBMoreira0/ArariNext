import 'package:arari_next/domain/models/iboat_data.dart';

final class GPSData implements IBoatData {
  final double latitude;
  final double longitude;
  final double speed;
  final int course;
  final int heading;
  final int visibleSatellites;
  final double hdop;

  GPSData({required this.latitude, required this.longitude, required this.speed, required this.course, required this.heading, required this.visibleSatellites, required this.hdop});

  factory GPSData.empty() {
    return GPSData(latitude: 0, longitude: 0, speed: 0, course: 0, heading: 0, visibleSatellites: 0, hdop: 0);
  }
}