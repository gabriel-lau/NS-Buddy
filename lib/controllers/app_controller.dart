import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class AppController {
  final AppSettings settings;

  AppController({required this.settings});

  // Initialize settings from shared preferences
  Future<void> initializeSettings() async {
    await settings.loadSettings();
  }

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

  // User information methods
  void setDob(DateTime? value) {
    settings.setDob(value);
  }

  void setGender(String? value) {
    settings.setGender(value);
  }

  void setIsShiongVoc(bool value) {
    settings.setIsShiongVoc(value);
  }

  void setIsNSF(bool value) {
    settings.setIsNSF(value);
  }

  void setOrdDate(DateTime? value) {
    settings.setOrdDate(value);
  }
}
