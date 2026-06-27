import 'package:arari_next/ui/core/utils/layout_constraint.dart';
import 'package:flutter/material.dart';

class LayoutMode {
  final List<LayoutConstraint> layouts;

  LayoutMode({required this.layouts, bool autoOrder = false}) {
    if (autoOrder) {
      layouts.sort((a, b) => _compareLayout(a, b));
    }
  }

  int _compareLayout(LayoutConstraint l1, LayoutConstraint l2) {
    if (l1.minHeight * l1.minWidth < l2.minHeight * l2.minWidth) return 1;
    if (l1.minHeight * l1.minWidth > l2.minHeight * l2.minWidth) return -1;
    return 0;
  }

  Widget buildLayout(BoxConstraints constraints) {
    for (final layout in layouts) {
      if (constraints.maxHeight >= layout.minHeight &&
          constraints.maxWidth >= layout.minWidth) {
        return layout.build();
      }
    }

    return layouts.last.build();
  }
}
