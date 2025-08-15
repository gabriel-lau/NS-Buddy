import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter with ChangeNotifier {
  int _value;
  static const String _prefsKey = 'counter_value';

  Counter([int initialValue = 0]) : _value = initialValue;

  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
    _persist();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt(_prefsKey) ?? 0;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, _value);
  }
}
