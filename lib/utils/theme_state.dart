import 'package:flutter/material.dart';
import 'package:unione/unisphere_theme.dart';

class ThemeState extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData getTheme() {
    return isDarkMode ? UnisphereTheme.dark() : UnisphereTheme.light();
  }
}
