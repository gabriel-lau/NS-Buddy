import 'package:ns_buddy/data/datasources/shared_preference_data_source.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository_interface.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class SettingsRepository implements SettingsRepositoryInterface {
  // reference to shared preferences
  final SharedPreferenceDataSource dataSource = SharedPreferenceDataSource();
  // @override
  // Future<void> loadSettings() async {
  //   try {
  //     _useDynamicColors = prefs.getBool('useDynamicColors') ?? true;
  //     _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  //     final themeModeStr = prefs.getString('themeMode');
  //     if (themeModeStr != null) {
  //       _theme = ThemeOption.values.firstWhere(
  //         (e) => e.name == themeModeStr,
  //         orElse: () => ThemeOption.system,
  //       );
  //     } else {
  //       _theme = ThemeOption.system;
  //     }

  //     final primaryColourStr = prefs.getString('primaryColour');
  //     if (primaryColourStr != null) {
  //       _primaryColour = ColourOption.values.firstWhere(
  //         (e) => e.name == primaryColourStr,
  //         orElse: () => ColourOption.system,
  //       );
  //     } else {
  //       _primaryColour = ColourOption.system;
  //     }

  //     // Load user information
  //     final dobString = prefs.getString('dob');
  //     if (dobString != null) {
  //       _dob = DateTime.tryParse(dobString);
  //     }

  //     _gender = prefs.getString('gender');
  //     _isShiongVoc = prefs.getBool('isShiongVoc') ?? false;

  //     final ordDateString = prefs.getString('ordDate');
  //     if (ordDateString != null) {
  //       _ordDate = DateTime.tryParse(ordDateString);
  //     }

  //     final enlistmentDateString = prefs.getString('enlistmentDate');
  //     if (enlistmentDateString != null) {
  //       _enlistmentDate = DateTime.tryParse(enlistmentDateString);
  //     }

  //     _hasCompletedOnboarding =
  //         prefs.getBool('hasCompletedOnboarding') ?? false;
  //   } catch (e) {
  //     // Handle errors gracefully, especially in test environments
  //     debugPrint('Error loading settings: $e');
  //   }
  // }

  @override
  Future<void> setUseDynamicColors(bool value) async {
    return await (await dataSource.prefs).setBool('useDynamicColors', value);
  }

  @override
  Future<void> setDarkMode(bool value) async {
    return await (await dataSource.prefs).setBool('isDarkMode', value);
  }

  @override
  Future<void> setTheme(ThemeOption theme) async {}

  @override
  Future<void> setPrimaryColour(ColourOption colour) async {}

  // Setters for user information
  @override
  Future<void> setDob(DateTime? value) async {
    return await (await dataSource.prefs).setString(
      'dob',
      value?.toIso8601String() ?? '',
    );
  }

  @override
  Future<void> setGender(String? value) async {}

  @override
  Future<void> setIsShiongVoc(bool value) async {}

  @override
  Future<void> setOrdDate(DateTime? value) async {}

  @override
  Future<void> setEnlistmentDate(DateTime? value) async {}

  @override
  Future<void> setHasCompletedOnboarding(bool value) async {}
  @override
  Future<void> resetSettings() async {}
}
