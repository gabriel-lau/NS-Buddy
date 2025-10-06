import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_repository.dart';
import 'package:ns_buddy/domain/usecases/user_info_usecases_impl.dart';

// Fake implementation for testing
class FakeUserInfoRepository implements UserInfoRepository {
  UserInfoEntity? _storedUserInfo;
  bool shouldThrow = false;
  String? errorMessage;

  @override
  Future<UserInfoEntity> retrieveUserInfo() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    return _storedUserInfo ?? UserInfoEntity();
  }

  @override
  Future<void> updateUserInfo(UserInfoEntity userInfo) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    _storedUserInfo = userInfo;
  }

  @override
  Future<void> resetUserInfo() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    _storedUserInfo = UserInfoEntity();
  }

  void setStoredUserInfo(UserInfoEntity userInfo) {
    _storedUserInfo = userInfo;
  }

  void reset() {
    _storedUserInfo = null;
    shouldThrow = false;
    errorMessage = null;
  }
}

void main() {
  group('UserInfoUsecasesImpl', () {
    late UserInfoUsecasesImpl userInfoUsecases;
    late FakeUserInfoRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeUserInfoRepository();
      userInfoUsecases = UserInfoUsecasesImpl(fakeRepository);
    });

    tearDown(() {
      fakeRepository.reset();
    });

    group('retrieveUserInfo', () {
      test('should retrieve user info from repository', () async {
        // Arrange
        final expectedUserInfo = UserInfoEntity(
          dob: DateTime(2000, 1, 1),
          gender: 'Male',
          isShiongVoc: true,
          hasCompletedOnboarding: true,
        );
        fakeRepository.setStoredUserInfo(expectedUserInfo);

        // Act
        await userInfoUsecases.retrieveUserInfo();

        // Assert
        expect(userInfoUsecases.userInfoEntity!.dob, expectedUserInfo.dob);
        expect(
          userInfoUsecases.userInfoEntity!.gender,
          expectedUserInfo.gender,
        );
        expect(
          userInfoUsecases.userInfoEntity!.isShiongVoc,
          expectedUserInfo.isShiongVoc,
        );
        expect(
          userInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          expectedUserInfo.hasCompletedOnboarding,
        );
      });

      test('should handle repository errors', () async {
        // Arrange
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Database error';

        // Act & Assert
        expect(() => userInfoUsecases.retrieveUserInfo(), throwsException);
      });
    });

    group('updateUserInfo', () {
      test('should update user info and notify listeners', () async {
        // Arrange
        final userInfo = UserInfoEntity(
          dob: DateTime(1995, 5, 15),
          gender: 'Female',
          isShiongVoc: false,
          hasCompletedOnboarding: true,
        );

        bool notificationReceived = false;
        userInfoUsecases.addListener(() {
          notificationReceived = true;
        });

        // Act
        await userInfoUsecases.updateUserInfo(userInfo);

        // Assert
        expect(userInfoUsecases.userInfoEntity!.dob, userInfo.dob);
        expect(userInfoUsecases.userInfoEntity!.gender, userInfo.gender);
        expect(
          userInfoUsecases.userInfoEntity!.isShiongVoc,
          userInfo.isShiongVoc,
        );
        expect(
          userInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          userInfo.hasCompletedOnboarding,
        );
        expect(notificationReceived, true);
      });

      test('should handle repository update errors', () async {
        // Arrange
        final userInfo = UserInfoEntity(gender: 'Male');
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Update failed';

        // Act & Assert
        expect(
          () => userInfoUsecases.updateUserInfo(userInfo),
          throwsException,
        );
      });

      test('should update local state even if repository fails', () async {
        // Arrange
        final userInfo = UserInfoEntity(
          gender: 'Other',
          hasCompletedOnboarding: true,
        );
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Network error';

        bool notificationReceived = false;
        userInfoUsecases.addListener(() {
          notificationReceived = true;
        });

        // Act & Assert
        expect(
          () => userInfoUsecases.updateUserInfo(userInfo),
          throwsException,
        );

        // Local state should still be updated
        expect(userInfoUsecases.userInfoEntity!.gender, userInfo.gender);
        expect(
          userInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          userInfo.hasCompletedOnboarding,
        );
        expect(notificationReceived, true);
      });
    });

    group('resetUserInfo', () {
      test(
        'should reset user info to default values and notify listeners',
        () async {
          // Arrange
          // First set some non-default values
          final initialUserInfo = UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            gender: 'Male',
            isShiongVoc: true,
            hasCompletedOnboarding: true,
          );
          await userInfoUsecases.updateUserInfo(initialUserInfo);

          bool notificationReceived = false;
          userInfoUsecases.addListener(() {
            notificationReceived = true;
          });

          // Act
          await userInfoUsecases.resetUserInfo();

          // Assert
          expect(userInfoUsecases.userInfoEntity!.dob, isNull);
          expect(userInfoUsecases.userInfoEntity!.gender, isNull);
          expect(userInfoUsecases.userInfoEntity!.isShiongVoc, false);
          expect(userInfoUsecases.userInfoEntity!.ordDate, isNull);
          expect(userInfoUsecases.userInfoEntity!.enlistmentDate, isNull);
          expect(
            userInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
            false,
          );
          expect(notificationReceived, true);
        },
      );

      test('should handle repository reset errors', () async {
        // Arrange
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Reset failed';

        // Act & Assert
        expect(() => userInfoUsecases.resetUserInfo(), throwsException);
      });
    });

    group('ChangeNotifier behavior', () {
      test('should notify listeners on updateUserInfo', () async {
        // Arrange
        final userInfo1 = UserInfoEntity(gender: 'Male');
        final userInfo2 = UserInfoEntity(gender: 'Female');

        int notificationCount = 0;
        userInfoUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await userInfoUsecases.updateUserInfo(userInfo1);
        await userInfoUsecases.updateUserInfo(userInfo2);

        // Assert
        expect(notificationCount, 2);
      });

      test('should notify listeners on resetUserInfo', () async {
        // Arrange
        int notificationCount = 0;
        userInfoUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await userInfoUsecases.resetUserInfo();

        // Assert
        expect(notificationCount, 1);
      });

      test('should not notify listeners on retrieveUserInfo', () async {
        // Arrange
        final userInfo = UserInfoEntity(gender: 'Male');
        fakeRepository.setStoredUserInfo(userInfo);

        int notificationCount = 0;
        userInfoUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await userInfoUsecases.retrieveUserInfo();

        // Assert
        expect(notificationCount, 0);
      });
    });

    group('userInfoEntity getter', () {
      test('should return current user info entity', () async {
        // Arrange
        final expectedUserInfo = UserInfoEntity(
          dob: DateTime(1990, 12, 25),
          gender: 'Female',
        );
        fakeRepository.setStoredUserInfo(expectedUserInfo);

        // Act
        await userInfoUsecases.retrieveUserInfo();
        final result = userInfoUsecases.userInfoEntity;

        // Assert
        expect(result!.dob, expectedUserInfo.dob);
        expect(result.gender, expectedUserInfo.gender);
      });
    });
  });
}
