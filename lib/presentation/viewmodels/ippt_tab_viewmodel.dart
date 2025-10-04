import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class IpptTabViewModel extends ChangeNotifier {
  final UserInfoUsecases userInfoUsecases;

  IpptTabViewModel(this.userInfoUsecases) {
    resetParameters();
    loadIpptJson();
  }

  UserInfoEntity get _userInfoEntity => userInfoUsecases.userInfoEntity;
  Map<String, dynamic>? _ipptData;

  // Local copies of user parameters for IPPT calculation
  late int age = 16;
  final List<int> ageOptions = List<int>.generate(45, (i) => 16 + i); // 16..60
  // late String _genderLocal = 'male';
  late bool isShiongVocLocal = false;
  late bool isNSF = true;

  // Tracks if any parameter in the collapsible card was edited by the user
  bool _isEdited = false;
  bool get isEdited => _isEdited;

  // IPPT input values
  double _pushUpValue = 0;
  double _sitUpValue = 0;
  double _runValue = 20 * 60;

  void decreaseAge() {
    final minAge = ageOptions.first;
    age = (age - 1).clamp(minAge, ageOptions.last);
    _isEdited = true;
    notifyListeners(); // Trigger UI rebuild
  }

  void increaseAge() {
    final maxAge = ageOptions.last;
    age = (age + 1).clamp(ageOptions.first, maxAge);
    _isEdited = true;
    notifyListeners();
  }

  void setAge(int newAge) {
    age = newAge;
    _isEdited = true;
    notifyListeners();
  }

  void toggleIsShiongVoc() {
    isShiongVocLocal = !isShiongVocLocal;
    _isEdited = true;
    notifyListeners();
  }

  void toggleIsNSF() {
    isNSF = !isNSF;
    _isEdited = true;
    notifyListeners();
  }

  void resetParameters() {
    age = _deriveAgeFromDob(_userInfoEntity.dob) ?? 16;
    // _genderLocal = (widget.settings.gender == 'female') ? 'female' : 'male';
    isShiongVocLocal = _userInfoEntity.isShiongVoc;
    // If DateTime.now() is still between enlistment date and ORD date, assume NSF
    isNSF =
        _userInfoEntity.enlistmentDate != null &&
        _userInfoEntity.ordDate != null &&
        DateTime.now().isAfter(_userInfoEntity.enlistmentDate!) &&
        DateTime.now().isBefore(_userInfoEntity.ordDate!);
    _isEdited = false;
    notifyListeners();
  }

  // TODO refactor to repository
  Future<void> loadIpptJson() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'lib/assets/ippt_score_chart.json',
      );
      final Map<String, dynamic> data = convert.jsonDecode(jsonStr);
      _ipptData = data;
    } catch (e) {
      // If asset missing or malformed, keep score at 0
      debugPrint('Failed to load IPPT JSON: $e');
    }
  }

  double get pushUpValue => _pushUpValue;
  set pushUpValue(double value) {
    _pushUpValue = value;
    notifyListeners();
  }

  double get sitUpValue => _sitUpValue;
  set sitUpValue(double value) {
    _sitUpValue = value;
    notifyListeners();
  }

  double get runValue => _runValue;
  set runValue(double value) {
    _runValue = value;
    notifyListeners();
  }

  int get pushPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(age);
    final int pushUps = _pushUpValue.round().clamp(0, 60);
    return _pointsForReps('push_up', pushUps, ageGroup);
  }

  int get sitPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(age);
    final int sitUps = _sitUpValue.round().clamp(0, 60);
    return _pointsForReps('sit_up', sitUps, ageGroup);
  }

  int get runPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(age);
    final int runSeconds = _runValue.round().clamp(8 * 60, 18 * 60 + 30);
    return _pointsForRun(runSeconds, ageGroup);
  }

  int get score => pushPoints + sitPoints + runPoints;

  String get award {
    if (score < 50) return 'fail';
    if (score < 60) return 'pass';
    if (score < 75 && !isNSF) return 'pass (incentive)';
    if (score < 75 && isNSF) return 'pass';
    if (score < 85 && !isShiongVocLocal) return 'silver';
    if (score < 90 && isShiongVocLocal) return 'silver';
    return 'gold';
  }

  String _getAgeGroup(int age) {
    if (age < 22) return '<22';
    if (age <= 24) return '22-24';
    if (age <= 27) return '25-27';
    if (age <= 30) return '28-30';
    if (age <= 33) return '31-33';
    if (age <= 36) return '34-36';
    if (age <= 39) return '37-39';
    if (age <= 42) return '40-42';
    if (age <= 45) return '43-45';
    if (age <= 48) return '46-48';
    if (age <= 51) return '49-51';
    if (age <= 54) return '52-54';
    if (age <= 57) return '55-57';
    return '58-60';
  }

  int _pointsForReps(String category, int reps, String ageGroup) {
    final Map<String, dynamic>? scoring =
        _ipptData?['ippt']?[category]?['scoring'] as Map<String, dynamic>?;
    if (scoring == null) return 0;
    final Map<String, dynamic>? row = scoring['$reps'] as Map<String, dynamic>?;
    if (row == null) return 0;
    final dynamic value = row[ageGroup];
    if (value is int) return value;
    return 0;
  }

  int _pointsForRun(int runSeconds, String ageGroup) {
    final Map<String, dynamic>? runTable =
        _ipptData?['ippt']?['run_2_4km']?['scoring'] as Map<String, dynamic>?;
    if (runTable == null) return 0;

    int parseTimeToSeconds(String mmss) {
      final parts = mmss.split(':');
      if (parts.length != 2) return 0;
      final int m = int.tryParse(parts[0]) ?? 0;
      final int s = int.tryParse(parts[1]) ?? 0;
      return m * 60 + s;
    }

    // Build sorted list of bucket seconds
    final List<int> buckets =
        runTable.keys.map((k) => parseTimeToSeconds(k)).toList()..sort();

    // Choose the smallest bucket that is >= user's time (conservative rounding)
    int chosen = buckets.last;
    for (final b in buckets) {
      if (runSeconds <= b) {
        chosen = b;
        break;
      }
    }

    String formatSeconds(int secs) {
      final int m = secs ~/ 60;
      final int s = secs % 60;
      final String ss = s.toString().padLeft(2, '0');
      return '$m:$ss';
    }

    final Map<String, dynamic>? row =
        runTable[formatSeconds(chosen)] as Map<String, dynamic>?;
    if (row == null) return 0;
    final dynamic value = row[ageGroup];
    if (value is int) return value;
    return 0;
  }

  int? _deriveAgeFromDob(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    int years = now.year - dob.year;
    final hadBirthdayThisYear =
        (now.month > dob.month) ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hadBirthdayThisYear) years -= 1;
    return years.clamp(0, 120);
  }

  void updateView() {
    notifyListeners();
  }
}
