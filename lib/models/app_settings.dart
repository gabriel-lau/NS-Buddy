import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  bool _useDynamicColors;
  bool _isDarkMode;

  // User information fields
  DateTime? _dob;
  String? _gender;
  bool _isShiongVoc = false;
  bool _isNSF = false;
  DateTime? _ordDate;

  // Flag to disable persistence for testing
  final bool _disablePersistence;

  AppSettings({
    bool useDynamicColors = true,
    bool isDarkMode = false,
    bool disablePersistence = false,
  }) : _useDynamicColors = useDynamicColors,
       _isDarkMode = isDarkMode,
       _disablePersistence = disablePersistence;

  bool get useDynamicColors => _useDynamicColors;
  bool get isDarkMode => _isDarkMode;

  // Getters for user information
  DateTime? get dob => _dob;
  String? get gender => _gender;
  bool get isShiongVoc => _isShiongVoc;
  bool get isNSF => _isNSF;
  DateTime? get ordDate => _ordDate;

  // Initialize settings from shared preferences
  Future<void> loadSettings() async {
    if (_disablePersistence) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      _useDynamicColors = prefs.getBool('useDynamicColors') ?? true;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;

      // Load user information
      final dobString = prefs.getString('dob');
      if (dobString != null) {
        _dob = DateTime.tryParse(dobString);
      }

      _gender = prefs.getString('gender');
      _isShiongVoc = prefs.getBool('isShiongVoc') ?? false;
      _isNSF = prefs.getBool('isNSF') ?? false;

      final ordDateString = prefs.getString('ordDate');
      if (ordDateString != null) {
        _ordDate = DateTime.tryParse(ordDateString);
      }

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
      await prefs.setBool('isNSF', _isNSF);

      if (_ordDate != null) {
        await prefs.setString('ordDate', _ordDate!.toIso8601String());
      } else {
        await prefs.remove('ordDate');
      }
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

  void setIsNSF(bool value) {
    if (_isNSF == value) return;
    _isNSF = value;
    saveSettings();
    notifyListeners();
  }

  void setOrdDate(DateTime? value) {
    if (_ordDate == value) return;
    _ordDate = value;
    saveSettings();
    notifyListeners();
  }
}
