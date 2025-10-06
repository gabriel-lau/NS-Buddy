import 'dart:convert';

import 'package:ns_buddy/data/models/settings_model.dart';
import 'package:ns_buddy/data/models/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceDataSource {
  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      rethrow;
    }
  }

  Future<SettingsModel> loadSettings() async {
    try {
      // Attempt to load existing settings
      final prefs = await _getSharedPreferencesInstance();
      final settingsJson = prefs.getString('settings');
      if (settingsJson != null) {
        return SettingsModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(settingsJson)),
        );
      }
      throw Exception('No settings found');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final prefs = await _getSharedPreferencesInstance();
      await prefs.setString('settings', jsonEncode(settings.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetSettings() async {
    try {
      final prefs = await _getSharedPreferencesInstance();
      await prefs.remove('settings');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserInfoModel?> loadUserInfo() async {
    try {
      final prefs = await _getSharedPreferencesInstance();
      final userInfoJson = prefs.getString('userInfo');
      if (userInfoJson != null) {
        return UserInfoModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(userInfoJson)),
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserInfo(UserInfoModel userInfo) async {
    try {
      final prefs = await _getSharedPreferencesInstance();
      await prefs.setString('userInfo', jsonEncode(userInfo.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetUserInfo() async {
    try {
      final prefs = await _getSharedPreferencesInstance();
      await prefs.remove('userInfo');
    } catch (e) {
      rethrow;
    }
  }
}
