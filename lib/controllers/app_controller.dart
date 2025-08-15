import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class AppController {
  final AppSettings settings;

  AppController({required this.settings});

  ThemeMode get themeMode =>
      settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeData buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: settings.useDynamicColors
          ? null
          : ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
      colorSchemeSeed: settings.useDynamicColors ? Colors.deepPurple : null,
    );
  }

  ThemeData buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: settings.useDynamicColors
          ? null
          : ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
      colorSchemeSeed: settings.useDynamicColors ? Colors.deepPurple : null,
    );
  }

  void toggleThemeMode() {
    settings.setDarkMode(!settings.isDarkMode);
  }

  void setDynamicColors(bool value) {
    settings.setUseDynamicColors(value);
  }
}
