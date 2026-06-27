import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class SpeedometerGauge extends StatelessWidget {
  final double rpm;
  final double? start;
  final double? end;

  const SpeedometerGauge({super.key, required this.rpm, this.start, this.end});

  @override
  Widget build(BuildContext context) {
    return RadialGauge(
      track: RadialTrack(
        start: start ?? 0,
        end: end ?? 5000,
        steps: ((end ?? 5000) / 2).toInt(),
        thickness: 15,
        color: Colors.black,
        trackLabelFormater: (p0) => p0.toInt().toString(),
        trackStyle: TrackStyle(
          secondaryRulersHeight: 3,
          primaryRulerColor: Colors.black45,
          secondaryRulerColor: Colors.black45,
          primaryRulersHeight: 3,
          labelStyle: TextStyle(
            fontSize: 10,
            color: Colors.black45,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      needlePointer: [
        NeedlePointer(
          value: rpm,
          needleWidth: 5,
          tailRadius: 10,
          color: Colors.black87,
          tailColor: Colors.black,
        ),
      ],
      valueBar: [
        RadialValueBar(
          value: rpm,
          gradient: LinearGradient(
            colors: [Colors.green, Colors.yellow, Colors.red],
          ),
        ),
      ],
    );
  }
}
