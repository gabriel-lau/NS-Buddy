import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_repository.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class UserInfoUsecasesImpl implements UserInfoUsecases {
  final UserInfoRepository repository;

  UserInfoUsecasesImpl(this.repository);

  @override
  Future<UserInfoEntity> retrieveUserInfo() async {
    return await repository.retrieveUserInfo();
  }

  @override
  Future<void> updateUserInfo(UserInfoEntity userInfo) async {
    await repository.updateUserInfo(userInfo);
  }

  @override
  Future<void> resetUserInfo() async {
    await repository.resetUserInfo();
  }
}
