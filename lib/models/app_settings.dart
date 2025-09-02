import 'package:flutter/foundation.dart';
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  bool _useDynamicColors;
  bool _isDarkMode;
  ThemeOption _theme;
  ColourOption _primaryColour;

  // User information fields
  DateTime? _dob;
  String? _gender;
  bool _isShiongVoc = false;
  DateTime? _ordDate;
  DateTime? _enlistmentDate;
  bool _hasCompletedOnboarding = false;

  // Flag to disable persistence for testing
  final bool _disablePersistence;

  AppSettings({
    bool useDynamicColors = true,
    bool isDarkMode = false,
    ThemeOption theme = ThemeOption.system,
    ColourOption primaryColour = ColourOption.system,
    bool disablePersistence = false,
  }) : _useDynamicColors = useDynamicColors,
       _isDarkMode = isDarkMode,
       _theme = theme,
       _primaryColour = primaryColour,
       _disablePersistence = disablePersistence;

  bool get useDynamicColors => _useDynamicColors;
  bool get isDarkMode => _isDarkMode;

  ThemeOption get theme => _theme;
  ColourOption get primaryColour => _primaryColour;

  // Getters for user information
  DateTime? get dob => _dob;
  String? get gender => _gender;
  bool get isShiongVoc => _isShiongVoc;
  DateTime? get ordDate => _ordDate;
  DateTime? get enlistmentDate => _enlistmentDate;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  // Initialize settings from shared preferences
  Future<void> loadSettings() async {
    if (_disablePersistence) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      _useDynamicColors = prefs.getBool('useDynamicColors') ?? true;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      final themeModeStr = prefs.getString('themeMode');
      if (themeModeStr != null) {
        _theme = ThemeOption.values.firstWhere(
          (e) => e.name == themeModeStr,
          orElse: () => ThemeOption.system,
        );
      } else {
        _theme = ThemeOption.system;
      }

      final primaryColourStr = prefs.getString('primaryColour');
      if (primaryColourStr != null) {
        _primaryColour = ColourOption.values.firstWhere(
          (e) => e.name == primaryColourStr,
          orElse: () => ColourOption.system,
        );
      } else {
        _primaryColour = ColourOption.system;
      }

      // Load user information
      final dobString = prefs.getString('dob');
      if (dobString != null) {
        _dob = DateTime.tryParse(dobString);
      }

      _gender = prefs.getString('gender');
      _isShiongVoc = prefs.getBool('isShiongVoc') ?? false;

      final ordDateString = prefs.getString('ordDate');
      if (ordDateString != null) {
        _ordDate = DateTime.tryParse(ordDateString);
      }

      final enlistmentDateString = prefs.getString('enlistmentDate');
      if (enlistmentDateString != null) {
        _enlistmentDate = DateTime.tryParse(enlistmentDateString);
      }

      _hasCompletedOnboarding =
          prefs.getBool('hasCompletedOnboarding') ?? false;

      notifyListeners();
    } catch (e) {
      // Handle errors gracefully, especially in test environments
      debugPrint('Error loading settings: $e');
    }
  }

  // Save settings to shared preferences
  Future<void> saveSettings() async {
    if (_disablePersistence) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('useDynamicColors', _useDynamicColors);
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setString('themeMode', _theme.name);
      await prefs.setString('primaryColour', _primaryColour.name);

      // Save user information
      if (_dob != null) {
        await prefs.setString('dob', _dob!.toIso8601String());
      } else {
        await prefs.remove('dob');
      }

      if (_gender != null) {
        await prefs.setString('gender', _gender!);
      } else {
        await prefs.remove('gender');
      }

      await prefs.setBool('isShiongVoc', _isShiongVoc);

      if (_ordDate != null) {
        await prefs.setString('ordDate', _ordDate!.toIso8601String());
      } else {
        await prefs.remove('ordDate');
      }

      if (_enlistmentDate != null) {
        await prefs.setString(
          'enlistmentDate',
          _enlistmentDate!.toIso8601String(),
        );
      } else {
        await prefs.remove('enlistmentDate');
      }

      await prefs.setBool('hasCompletedOnboarding', _hasCompletedOnboarding);
    } catch (e) {
      // Handle errors gracefully, especially in test environments
      debugPrint('Error saving settings: $e');
    }
  }

  void setUseDynamicColors(bool value) {
    if (_useDynamicColors == value) return;
    _useDynamicColors = value;
    saveSettings();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    saveSettings();
    notifyListeners();
  }

  void setTheme(ThemeOption theme) {
    if (_theme == theme) return;
    _theme = theme;
    saveSettings();
    notifyListeners();
  }

  void setPrimaryColour(ColourOption colour) {
    if (_primaryColour == colour) return;
    _primaryColour = colour;
    saveSettings();
    notifyListeners();
  }

  // Setters for user information
  void setDob(DateTime? value) {
    if (_dob == value) return;
    _dob = value;
    saveSettings();
    notifyListeners();
  }

  void setGender(String? value) {
    if (_gender == value) return;
    _gender = value;
    saveSettings();
    notifyListeners();
  }

  void setIsShiongVoc(bool value) {
    if (_isShiongVoc == value) return;
    _isShiongVoc = value;
    saveSettings();
    notifyListeners();
  }

  void setOrdDate(DateTime? value) {
    if (_ordDate == value) return;
    _ordDate = value;
    saveSettings();
    notifyListeners();
  }

  void setEnlistmentDate(DateTime? value) {
    if (_enlistmentDate == value) return;
    _enlistmentDate = value;
    saveSettings();
    notifyListeners();
  }

  void setHasCompletedOnboarding(bool value) {
    if (_hasCompletedOnboarding == value) return;
    _hasCompletedOnboarding = value;
    saveSettings();
    notifyListeners();
  }

  void resetToDefault() {
    _useDynamicColors = true;
    _isDarkMode = false;
    _dob = null;
    _gender = null;
    _isShiongVoc = false;
    _ordDate = null;
    _enlistmentDate = null;
    _hasCompletedOnboarding = false;
    saveSettings();
    notifyListeners();
  }
}
