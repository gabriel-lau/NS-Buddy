import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;

class TempViewModel extends ChangeNotifier {
  final SettingsUsecases settingsUsecases;
  final UserInfoUsecases userInfoUsecases;

  TempViewModel({
    required this.settingsUsecases,
    required this.userInfoUsecases,
  });

  late SettingsEntity settings;
  late UserInfoEntity userInfo;

  // Initialize settings from shared preferences
  Future<void> initializeSettings() async {
    settings = await settingsUsecases.retrieveSettings();
    userInfo = await userInfoUsecases.retrieveUserInfo();
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
    settingsUsecases.updateSettings(
      SettingsEntity(
        theme: settings.theme,
        primaryColour: settings.primaryColour,
        useDynamicColors: settings.useDynamicColors,
        isDarkMode: !settings.isDarkMode,
      ),
    );
  }

  Future<void> setDynamicColors(bool value) async {
    settingsUsecases.updateSettings(
      SettingsEntity(
        theme: settings.theme,
        primaryColour: settings.primaryColour,
        useDynamicColors: value,
        isDarkMode: settings.isDarkMode,
      ),
    );
    settings = await settingsUsecases.retrieveSettings();
    notifyListeners();
  }

  Future<void> setTheme(ThemeOption theme) async {
    settingsUsecases.updateSettings(
      SettingsEntity(
        theme: theme,
        primaryColour: settings.primaryColour,
        useDynamicColors: settings.useDynamicColors,
        isDarkMode: settings.isDarkMode,
      ),
    );
    settings = await settingsUsecases.retrieveSettings();
    notifyListeners();
  }

  Future<void> setPrimaryColour(ColourOption colour) async {
    settingsUsecases.updateSettings(
      SettingsEntity(
        theme: settings.theme,
        primaryColour: colour,
        useDynamicColors: settings.useDynamicColors,
        isDarkMode: settings.isDarkMode,
      ),
    );
    settings = await settingsUsecases.retrieveSettings();
    notifyListeners();
  }

  // User information methods
  Future<void> setDob(DateTime? value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: value,
        gender: userInfo.gender,
        isShiongVoc: userInfo.isShiongVoc,
        ordDate: userInfo.ordDate,
        enlistmentDate: userInfo.enlistmentDate,
        hasCompletedOnboarding: userInfo.hasCompletedOnboarding,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> setGender(String? value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: userInfo.dob,
        gender: value,
        isShiongVoc: userInfo.isShiongVoc,
        ordDate: userInfo.ordDate,
        enlistmentDate: userInfo.enlistmentDate,
        hasCompletedOnboarding: userInfo.hasCompletedOnboarding,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> setIsShiongVoc(bool value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: userInfo.dob,
        gender: userInfo.gender,
        isShiongVoc: value,
        ordDate: userInfo.ordDate,
        enlistmentDate: userInfo.enlistmentDate,
        hasCompletedOnboarding: userInfo.hasCompletedOnboarding,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> setOrdDate(DateTime? value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: userInfo.dob,
        gender: userInfo.gender,
        isShiongVoc: userInfo.isShiongVoc,
        ordDate: value,
        enlistmentDate: userInfo.enlistmentDate,
        hasCompletedOnboarding: userInfo.hasCompletedOnboarding,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> setEnlistmentDate(DateTime? value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: userInfo.dob,
        gender: userInfo.gender,
        isShiongVoc: userInfo.isShiongVoc,
        ordDate: userInfo.ordDate,
        enlistmentDate: value,
        hasCompletedOnboarding: userInfo.hasCompletedOnboarding,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> setHasCompletedOnboarding(bool value) async {
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: userInfo.dob,
        gender: userInfo.gender,
        isShiongVoc: userInfo.isShiongVoc,
        ordDate: userInfo.ordDate,
        enlistmentDate: userInfo.enlistmentDate,
        hasCompletedOnboarding: value,
      ),
    );
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }

  Future<void> resetSettings() async {
    settingsUsecases.resetSettings();
    userInfoUsecases.resetUserInfo();
    settings = await settingsUsecases.retrieveSettings();
    userInfo = await userInfoUsecases.retrieveUserInfo();
    notifyListeners();
  }
}
