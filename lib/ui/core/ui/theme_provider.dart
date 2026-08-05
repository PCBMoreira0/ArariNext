import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _seedColor = Colors.white;
  ThemeMode _themeMode = ThemeMode.light;

  Color get seedColor => _seedColor;
  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );

  void changeColor(Color newColor) {
    if (_seedColor != newColor) {
      _seedColor = newColor;
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
