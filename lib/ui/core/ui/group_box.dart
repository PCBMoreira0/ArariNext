import 'package:flutter/material.dart';

class GroupBox extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? sideWidget;

  GroupBox({super.key, required this.title, required this.child, this.sideWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                if(sideWidget != null)
                  sideWidget!
              ],
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
