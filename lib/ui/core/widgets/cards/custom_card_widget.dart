import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final String title;
  final EdgeInsetsGeometry? padding;
  final Widget? action;

  const CustomCard({
    super.key,
    required this.title,
    this.color,
    this.padding,
    this.action,
    required this.child,
  });

  final double borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final headerBackgroundColor = color != null 
        ? Color.lerp(color, isDark ? Colors.white : Colors.black, 0.08)
        : colorScheme.surfaceContainerHighest;

    final textColor = color != null
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    return Card.outlined(
      color: color,
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: !isDark
            ? BorderSide.none
            : BorderSide(color: colorScheme.outlineVariant),
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Container(
            constraints: const BoxConstraints(maxHeight: 32),
            color: headerBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Tooltip(
                      message: title,
                      waitDuration: const Duration(milliseconds: 400),
                      child: Text(
                        title,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (action != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Theme(
                        data: theme.copyWith(
                          iconButtonTheme: IconButtonThemeData(
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              iconSize: 20,
                              foregroundColor: textColor,
                            ),
                          ),
                        ),
                        child: action!,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Corpo do Card
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
