import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsUsecases settingsUsecases;
  final UserInfoUsecases userInfoUsecases;

  SettingsViewModel({
    required this.settingsUsecases,
    required this.userInfoUsecases,
  });

  UserInfoEntity get _userInfoEntity => userInfoUsecases.userInfoEntity;
  SettingsEntity get _settingsEntity => settingsUsecases.settingsEntity;

  DateTime? get dob => _userInfoEntity.dob;
  Future<void> setDob(DateTime? value) async {
    await userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: value,
        gender: _userInfoEntity.gender,
        isShiongVoc: _userInfoEntity.isShiongVoc,
        ordDate: _userInfoEntity.ordDate,
        enlistmentDate: _userInfoEntity.enlistmentDate,
        hasCompletedOnboarding: _userInfoEntity.hasCompletedOnboarding,
      ),
    );
    notifyListeners();
  }

  bool? get isShiongVoc => _userInfoEntity.isShiongVoc;
  Future<void> setIsShiongVoc(bool value) async {
    await userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: _userInfoEntity.dob,
        gender: _userInfoEntity.gender,
        isShiongVoc: value,
        ordDate: _userInfoEntity.ordDate,
        enlistmentDate: _userInfoEntity.enlistmentDate,
        hasCompletedOnboarding: _userInfoEntity.hasCompletedOnboarding,
      ),
    );
    notifyListeners();
  }

  DateTime? get ordDate => _userInfoEntity.ordDate;
  Future<void> setEnlistmentDate(DateTime? value) async {
    await userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: _userInfoEntity.dob,
        gender: _userInfoEntity.gender,
        isShiongVoc: _userInfoEntity.isShiongVoc,
        ordDate: _userInfoEntity.ordDate,
        enlistmentDate: value,
        hasCompletedOnboarding: _userInfoEntity.hasCompletedOnboarding,
      ),
    );
    notifyListeners();
  }

  DateTime? get enlistmentDate => _userInfoEntity.enlistmentDate;
  Future<void> setOrdDate(DateTime? value) async {
    await userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: _userInfoEntity.dob,
        gender: _userInfoEntity.gender,
        isShiongVoc: _userInfoEntity.isShiongVoc,
        ordDate: value,
        enlistmentDate: _userInfoEntity.enlistmentDate,
        hasCompletedOnboarding: _userInfoEntity.hasCompletedOnboarding,
      ),
    );
    notifyListeners();
  }

  ThemeOption get theme => _settingsEntity.theme;
  Future<void> setTheme(ThemeOption theme) async {
    await settingsUsecases.updateSettings(
      SettingsEntity(
        theme: theme,
        primaryColour: _settingsEntity.primaryColour,
        useDynamicColors: _settingsEntity.useDynamicColors,
        isDarkMode: _settingsEntity.isDarkMode,
      ),
    );
    notifyListeners();
  }

  ColourOption get primaryColour => _settingsEntity.primaryColour;
  Future<void> setPrimaryColour(ColourOption colour) async {
    await settingsUsecases.updateSettings(
      SettingsEntity(
        theme: _settingsEntity.theme,
        primaryColour: colour,
        useDynamicColors: _settingsEntity.useDynamicColors,
        isDarkMode: _settingsEntity.isDarkMode,
      ),
    );
    notifyListeners();
  }

  Future<void> resetSettings() async {
    await settingsUsecases.resetSettings();
    await userInfoUsecases.resetUserInfo();
    notifyListeners();
  }

  // Future<void> updateThemeMode(ThemeMode mode) async {
  //   await settingsUsecases.updateSettings(
  //     SettingsEntity(
  //       themeMode: mode,
  //       notificationsEnabled: settings.notificationsEnabled,
  //       fontSize: settings.fontSize,
  //     ),
  //   );
  //   settings = settingsUsecases.settingsEntity;
  //   notifyListeners();
  // }
}
