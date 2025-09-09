import 'package:flutter/material.dart';
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;
import '../models/app_settings.dart';

class AppController {
  final AppSettings settings;

  AppController({required this.settings});

  // Initialize settings from shared preferences
  Future<void> initializeSettings() async {
    await settings.loadSettings();
  }

  ThemeMode get themeMode => ThemeOption.system == settings.theme
      ? ThemeMode.system
      : settings.theme == ThemeOption.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  MaterialColor get primarySwatch {
    switch (settings.primaryColour) {
      case ColourOption.red:
        return Colors.red;
      case ColourOption.green:
        return Colors.green;
      case ColourOption.blue:
        return Colors.blue;
      default:
        return Colors.deepPurple; // Default fallback
    }
  }

  ThemeData buildLightTheme({ColorScheme? dynamicScheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: settings.primaryColour == ColourOption.system
          ? dynamicScheme
          : ColorScheme.fromSeed(
              seedColor: primarySwatch,
              brightness: Brightness.light,
            ),
    );
  }

  ThemeData buildDarkTheme({ColorScheme? dynamicScheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: settings.primaryColour == ColourOption.system
          ? dynamicScheme
          : ColorScheme.fromSeed(
              seedColor: primarySwatch,
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

  void setTheme(ThemeOption theme) {
    settings.setTheme(theme);
  }

  void setPrimaryColour(ColourOption colour) {
    settings.setPrimaryColour(colour);
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
