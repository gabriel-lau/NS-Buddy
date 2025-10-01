import 'dart:convert';

import 'package:ns_buddy/data/models/settings_model.dart';
import 'package:ns_buddy/data/models/user_info_model.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceDataSource {
  Future<SettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Load settings from shared preferences
    // Serialize and deserialize as needed
    final settingsJson = prefs.getString('settings');
    if (settingsJson != null) {
      return SettingsModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(settingsJson)),
      );
    } else {
      SettingsModel settingsModel = SettingsModel(
        useDynamicColors: true,
        isDarkMode: false,
        theme: ThemeOption.system,
        primaryColour: ColourOption.system,
        disablePersistence: false,
      );
      await saveSettings(settingsModel);
      return settingsModel;
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', jsonEncode(settings.toJson()));
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('settings');
  }

  Future<UserInfoModel> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString('userInfo');
    if (userInfoJson != null) {
      return UserInfoModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(userInfoJson)),
      );
    }
    UserInfoModel userInfoModel = UserInfoModel(
      dob: DateTime.now().subtract(const Duration(days: 365 * 18)),
      isShiongVoc: false,
      ordDate: DateTime.now().add(const Duration(days: 365 * 2 + 30)),
      enlistmentDate: DateTime.now().add(const Duration(days: 30)),
    );
    await saveUserInfo(userInfoModel);
    return userInfoModel;
  }

  Future<void> saveUserInfo(UserInfoModel userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(userInfo.toJson()));
  }

  Future<void> resetUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
  }
}
