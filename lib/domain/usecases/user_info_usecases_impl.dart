import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_repository.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class UserInfoUsecasesImpl extends ChangeNotifier implements UserInfoUsecases {
  final UserInfoRepository repository;

  UserInfoUsecasesImpl(this.repository);
  late UserInfoEntity? _currentUserInfo;

  @override
  UserInfoEntity? get userInfoEntity => _currentUserInfo;

  @override
  Future<void> retrieveUserInfo() async {
    _currentUserInfo = await repository.retrieveUserInfo();
    // notifyListeners();
  }

  @override
  Future<void> updateUserInfo(UserInfoEntity userInfo) async {
    _currentUserInfo = userInfo;
    notifyListeners();
    await repository.updateUserInfo(userInfo);
  }

  @override
  Future<void> resetUserInfo() async {
    _currentUserInfo = null; // Reset to default values
    notifyListeners();
    await repository.resetUserInfo();
  }
}
