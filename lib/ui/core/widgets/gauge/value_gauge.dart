import 'package:flutter/material.dart';

class ValueGauge extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final String value;
  final String? label;
  final String? unit;
  final IconData? icon;
  final TextStyle? valueStyle;
  final double? maxWidth;

  final defaultValueStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final _textSizeRatio = 0.58;

  const ValueGauge({
    super.key,
    required this.value,
    this.label,
    this.unit,
    this.icon,
    this.color,
    this.padding,
    this.valueStyle,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final mergedValueStyle = defaultValueStyle.merge(valueStyle);
    final detailsTextSize = mergedValueStyle.fontSize! * _textSizeRatio;

    return Container(
      padding: padding ?? const EdgeInsetsGeometry.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: color ?? Colors.transparent,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label != null) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth ?? 80),
                child: Text(
                  label!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: detailsTextSize,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 3.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.black26,
                    height: 2,
                  ),
                ),
              ),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(icon, size: detailsTextSize),
                  ),

                Text(value, style: mergedValueStyle),

                if (unit != null) ...[
                  const SizedBox(width: 3),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: detailsTextSize,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
