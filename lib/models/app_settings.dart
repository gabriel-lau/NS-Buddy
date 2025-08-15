import 'package:flutter/foundation.dart';

class AppSettings with ChangeNotifier {
  bool _useDynamicColors;
  bool _isDarkMode;

  AppSettings({bool useDynamicColors = true, bool isDarkMode = false})
    : _useDynamicColors = useDynamicColors,
      _isDarkMode = isDarkMode;

  bool get useDynamicColors => _useDynamicColors;
  bool get isDarkMode => _isDarkMode;

  void setUseDynamicColors(bool value) {
    if (_useDynamicColors == value) return;
    _useDynamicColors = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
  }
}
