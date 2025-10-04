import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';

abstract class UserInfoUsecases extends ChangeNotifier {
  UserInfoEntity get userInfoEntity;
  Future<void> retrieveUserInfo();
  Future<void> updateUserInfo(UserInfoEntity userInfo);
  Future<void> resetUserInfo();
}
