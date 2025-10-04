import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/views/home_view.dart';

class OnboardingViewModel extends ChangeNotifier {
  final UserInfoUsecases userInfoUsecases;

  OnboardingViewModel(this.userInfoUsecases);

  DateTime? _dob;
  // String? _gender; // temporarily disabled
  bool _isShiongVoc = false;
  DateTime? _ordDate;
  DateTime? _enlistmentDate;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? get dob => _dob;
  set dob(DateTime? value) {
    _dob = value;
    notifyListeners();
  }

  bool get isShiongVoc => _isShiongVoc;
  set isShiongVoc(bool value) {
    _isShiongVoc = value;
    notifyListeners();
  }

  DateTime? get ordDate => _ordDate;
  set ordDate(DateTime? value) {
    _ordDate = value;
    notifyListeners();
  }

  DateTime? get enlistmentDate => _enlistmentDate;
  set enlistmentDate(DateTime? value) {
    _enlistmentDate = value;
    notifyListeners();
  }

  void submit(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    final List<String> missing = [];
    if (_dob == null) missing.add('Date of Birth');
    // if (_gender == null) missing.add('Gender'); // disabled
    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete: ${missing.join(', ')}')),
      );
      return;
    }
    userInfoUsecases.updateUserInfo(
      UserInfoEntity(
        dob: _dob,
        // gender: _gender, // disabled
        isShiongVoc: _isShiongVoc,
        ordDate: _ordDate,
        enlistmentDate: _enlistmentDate,
        hasCompletedOnboarding: true,
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeView()),
      (route) => false,
    );
  }
}
