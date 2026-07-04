// custom_card_widget.dart
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

  final borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: color ?? Colors.blueGrey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              color: color ?? Colors.grey,
            ),
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
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
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
                        data: Theme.of(context).copyWith(
                          iconButtonTheme: IconButtonThemeData(
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              iconSize: 20,
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
