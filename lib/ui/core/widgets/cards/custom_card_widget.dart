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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              color: color ?? Colors.grey,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: TextStyle(
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
                      Align(alignment: Alignment.centerRight, child: action),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: padding ?? EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
