import 'package:arari_next/domain/telemetry/telemetry_model_interface.dart';

final class GpsModel extends ITelemetryModel {
  final double latitude;
  final double longitude;
  final double speed;
  final int course;
  final int heading;
  final int visibleSatellites;
  final double hdop;

  GpsModel({required this.latitude, required this.longitude, required this.speed, required this.course, required this.heading, required this.visibleSatellites, required this.hdop, required super.timestamp});

  factory GpsModel.empty() {
    return GpsModel(latitude: 0, longitude: 0, speed: 0, course: 0, heading: 0, visibleSatellites: 0, hdop: 0, timestamp: 0);
  }
}