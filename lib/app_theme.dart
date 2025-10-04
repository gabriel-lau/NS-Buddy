import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class AppTheme {
  SettingsUsecases settingsUsecases;
  AppTheme(this.settingsUsecases);

  ThemeMode get themeMode =>
      ThemeOption.system == settingsUsecases.settingsEntity.theme
      ? ThemeMode.system
      : settingsUsecases.settingsEntity.theme == ThemeOption.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  MaterialColor get primarySwatch {
    switch (settingsUsecases.settingsEntity.primaryColour) {
      case ColourOption.red:
        return Colors.red;
      case ColourOption.green:
        return Colors.green;
      case ColourOption.deepPurple:
        return Colors.deepPurple;
      default:
        return Colors.blue; // Default fallback
    }
  }

  ThemeData buildLightTheme({ColorScheme? dynamicScheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          settingsUsecases.settingsEntity.primaryColour == ColourOption.system
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
      colorScheme:
          settingsUsecases.settingsEntity.primaryColour == ColourOption.system
          ? dynamicScheme
          : ColorScheme.fromSeed(
              seedColor: primarySwatch,
              brightness: Brightness.dark,
            ),
    );
  }
}
