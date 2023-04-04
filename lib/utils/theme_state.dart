import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unione/unisphere_theme.dart';

class ThemeState extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: !isDarkMode ? Colors.grey.shade200 : Colors.grey.shade900,
          systemNavigationBarColor: !isDarkMode ? Colors.white : const Color.fromARGB(255, 26, 26, 26),
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
    );
    notifyListeners();
  }

  ThemeData getTheme() {
    return isDarkMode ? UnisphereTheme.dark() : UnisphereTheme.light();
  }
}
