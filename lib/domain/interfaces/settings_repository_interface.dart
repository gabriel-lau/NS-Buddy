import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

abstract class SettingsRepositoryInterface {
  // Future<void> loadSettings();
  Future<void> setUseDynamicColors(bool value);
  Future<void> setDarkMode(bool value);
  Future<void> setTheme(ThemeOption theme);
  Future<void> setPrimaryColour(ColourOption colour);
  Future<void> setDob(DateTime? value);
  Future<void> setGender(String? value);
  Future<void> setIsShiongVoc(bool value);
  Future<void> setOrdDate(DateTime? value);
  Future<void> setEnlistmentDate(DateTime? value);
  Future<void> setHasCompletedOnboarding(bool value);
  Future<void> resetSettings();
}
