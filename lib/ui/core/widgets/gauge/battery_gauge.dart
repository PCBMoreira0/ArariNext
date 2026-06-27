import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class BatteryGauge extends StatelessWidget {
  final double level;

  const BatteryGauge({super.key, required this.level});
  
  Color _getColor() {
    if (level >= 75) return Colors.green;
    if (level >= 50) return Colors.yellow;
    if (level >= 25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return LinearGauge(
      extendLinearGauge: 2,
      rulers: RulerStyle(
        rulerPosition: RulerPosition.left,
        showSecondaryRulers: false,
        showPrimaryRulers: false,
        labelOffset: 0,
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontFamily: "Roboto",
        ),
        rulersOffset: 0,
      ),
      steps: 25,
      linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
        thickness: 20,
        borderRadius: 5,
        backgroundColor: Colors.black,
      ),
      gaugeOrientation: GaugeOrientation.vertical,
      customLabels: [
        CustomRulerLabel(text: "0%", value: 0),
        CustomRulerLabel(text: "25%", value: 25),
        CustomRulerLabel(text: "50%", value: 50),
        CustomRulerLabel(text: "75%", value: 75),
        CustomRulerLabel(text: "100%", value: 100),
      ],
      valueBar: [
        ValueBar(
          value: level,
          color: _getColor(),
          borderRadius: 3,
          valueBarThickness: 15,
        ),
      ],
    );
  }
}
