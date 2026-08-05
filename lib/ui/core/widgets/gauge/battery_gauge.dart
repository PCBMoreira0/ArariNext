import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class BatteryGauge extends StatelessWidget {
  final double level;

  const BatteryGauge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Color getBatteryColor() {
      if (level >= 75) {
        return isDark ? Colors.green.shade400 : Colors.green.shade600;
      }
      if (level >= 50) {
        return isDark ? Colors.amber.shade400 : Colors.amber.shade500;
      }
      if (level >= 25) {
        return isDark ? Colors.orange.shade400 : Colors.orange.shade600;
      }
      return colorScheme.error;
    }

    return LinearGauge(
      extendLinearGauge: 2,
      rulers: RulerStyle(
        rulerPosition: RulerPosition.left,
        showSecondaryRulers: false,
        showPrimaryRulers: false,
        labelOffset: 0,
        textStyle:
            theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ) ??
            TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
        rulersOffset: 0,
      ),
      steps: 25,
      linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
        thickness: 20,
        borderRadius: 5,
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      gaugeOrientation: GaugeOrientation.vertical,
      customLabels: const [
        CustomRulerLabel(text: "0%", value: 0),
        CustomRulerLabel(text: "25%", value: 25),
        CustomRulerLabel(text: "50%", value: 50),
        CustomRulerLabel(text: "75%", value: 75),
        CustomRulerLabel(text: "100%", value: 100),
      ],
      valueBar: [
        ValueBar(
          value: level,
          color: getBatteryColor(),
          borderRadius: 3,
          valueBarThickness: 15,
        ),
      ],
    );
  }
}
