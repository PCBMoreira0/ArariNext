import 'package:flutter/material.dart';

abstract class LayoutConstraint {
  double get minHeight => 0;
  double get minWidth => 0;
  Widget build();
}