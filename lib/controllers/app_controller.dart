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

  ThemeData buildLightTheme({ColorScheme? dynamicScheme}) {
    if (settings.useDynamicColors && dynamicScheme != null) {
      return ThemeData(useMaterial3: true, colorScheme: dynamicScheme);
    }
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData buildDarkTheme({ColorScheme? dynamicScheme}) {
    if (settings.useDynamicColors && dynamicScheme != null) {
      return ThemeData(useMaterial3: true, colorScheme: dynamicScheme);
    }
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
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

  void setOrdDate(DateTime? value) {
    settings.setOrdDate(value);
  }

  void setEnlistmentDate(DateTime? value) {
    settings.setEnlistmentDate(value);
  }

  void resetSettings() {
    settings.resetToDefault();
  }
}
