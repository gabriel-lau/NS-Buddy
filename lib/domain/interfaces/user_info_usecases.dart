import 'package:ns_buddy/domain/entities/user_info_entity.dart';

abstract class UserInfoUsecases {
  Future<UserInfoEntity> retrieveUserInfo();
  Future<void> updateUserInfo(UserInfoEntity userInfo);
  Future<void> resetUserInfo();
}
