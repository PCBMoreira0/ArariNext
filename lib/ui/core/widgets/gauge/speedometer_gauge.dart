import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class SpeedometerGauge extends StatelessWidget {
  final double rpm;
  final double? start;
  final double? end;

  const SpeedometerGauge({super.key, required this.rpm, this.start, this.end});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final safeColor = isDark ? Colors.green.shade400 : Colors.green.shade600;
    final warningColor = isDark ? Colors.amber.shade400 : Colors.amber.shade500;
    final dangerColor = colorScheme.error;

    return RadialGauge(
      track: RadialTrack(
        start: start ?? 0,
        end: end ?? 5000,
        steps: ((end ?? 5000) / 2).toInt(),
        thickness: 15,
        color: colorScheme.surfaceContainerHighest,
        trackLabelFormater: (p0) => p0.toInt().toString(),
        trackStyle: TrackStyle(
          secondaryRulersHeight: 3,
          primaryRulersHeight: 3,
          primaryRulerColor: colorScheme.outline,
          secondaryRulerColor: colorScheme.outlineVariant,
          labelStyle:
              theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ) ??
              TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      needlePointer: [
        NeedlePointer(
          value: rpm,
          needleWidth: 5,
          tailRadius: 10,
          color: colorScheme.onSurface,
          tailColor: colorScheme.onSurfaceVariant,
        ),
      ],
      valueBar: [
        RadialValueBar(
          value: rpm,
          gradient: LinearGradient(
            colors: [safeColor, warningColor, dangerColor],
          ),
        ),
      ],
    );
  }
}
