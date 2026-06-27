import 'package:flutter/material.dart';

abstract class LayoutConstraint {
  final double minHeight;
  final double minWidth;
  Widget build();

  LayoutConstraint({this.minHeight = 0, this.minWidth = 0});
}