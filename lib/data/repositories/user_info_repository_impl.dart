import 'package:ns_buddy/data/datasources/shared_preference_datasource.dart';
import 'package:ns_buddy/data/models/user_info_model.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_repository.dart';

class UserInfoRepositoryImpl implements UserInfoRepository {
  // reference to shared preferences
  final SharedPreferenceDataSource _localDataSource;
  UserInfoRepositoryImpl(this._localDataSource);

  @override
  Future<UserInfoEntity?> retrieveUserInfo() async {
    try {
      return await _localDataSource.loadUserInfo();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserInfo(UserInfoEntity userInfo) async {
    try {
      await _localDataSource.saveUserInfo(UserInfoModel.fromEntity(userInfo));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetUserInfo() async {
    try {
      await _localDataSource.resetUserInfo();
    } catch (e) {
      rethrow;
    }
  }
}
