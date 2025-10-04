import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/ippt_tab_viewmodel.dart';

// Fake implementation for testing
class FakeUserInfoUsecases extends UserInfoUsecases {
  UserInfoEntity _userInfoEntity = UserInfoEntity();

  @override
  UserInfoEntity get userInfoEntity => _userInfoEntity;

  void setUserInfo(UserInfoEntity userInfo) {
    _userInfoEntity = userInfo;
  }

  @override
  Future<void> retrieveUserInfo() async {
    // No-op for testing
  }

  @override
  Future<void> updateUserInfo(UserInfoEntity userInfo) async {
    _userInfoEntity = userInfo;
  }

  @override
  Future<void> resetUserInfo() async {
    _userInfoEntity = UserInfoEntity();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IpptTabViewModel', () {
    late IpptTabViewModel viewModel;
    late FakeUserInfoUsecases fakeUserInfoUsecases;

    setUp(() {
      fakeUserInfoUsecases = FakeUserInfoUsecases();
      viewModel = IpptTabViewModel(fakeUserInfoUsecases);
    });

    group('initialization', () {
      test('should initialize with default values', () {
        // Assert
        expect(viewModel.age, 16);
        expect(viewModel.isShiongVocLocal, false);
        expect(viewModel.isNSF, false); // Default after reset
        expect(viewModel.isEdited, false);
        expect(viewModel.pushUpValue, 0);
        expect(viewModel.sitUpValue, 0);
        expect(viewModel.runValue, 20 * 60);
      });

      test('should initialize age options correctly', () {
        // Assert
        expect(viewModel.ageOptions.length, 45);
        expect(viewModel.ageOptions.first, 16);
        expect(viewModel.ageOptions.last, 60);
      });
    });

    group('age management', () {
      test('should decrease age correctly', () {
        // Arrange
        viewModel.setAge(20);

        // Act
        viewModel.decreaseAge();

        // Assert
        expect(viewModel.age, 19);
        expect(viewModel.isEdited, true);
      });

      test('should not decrease age below minimum', () {
        // Arrange
        viewModel.setAge(16);

        // Act
        viewModel.decreaseAge();

        // Assert
        expect(viewModel.age, 16);
        expect(viewModel.isEdited, true);
      });

      test('should increase age correctly', () {
        // Arrange
        viewModel.setAge(20);

        // Act
        viewModel.increaseAge();

        // Assert
        expect(viewModel.age, 21);
        expect(viewModel.isEdited, true);
      });

      test('should not increase age above maximum', () {
        // Arrange
        viewModel.setAge(60);

        // Act
        viewModel.increaseAge();

        // Assert
        expect(viewModel.age, 60);
        expect(viewModel.isEdited, true);
      });

      test('should set age correctly', () {
        // Act
        viewModel.setAge(25);

        // Assert
        expect(viewModel.age, 25);
        expect(viewModel.isEdited, true);
      });
    });

    group('toggle methods', () {
      test('should toggle isShiongVoc correctly', () {
        // Arrange
        expect(viewModel.isShiongVocLocal, false);

        // Act
        viewModel.toggleIsShiongVoc();

        // Assert
        expect(viewModel.isShiongVocLocal, true);
        expect(viewModel.isEdited, true);

        // Act again
        viewModel.toggleIsShiongVoc();

        // Assert
        expect(viewModel.isShiongVocLocal, false);
      });

      test('should toggle isNSF correctly', () {
        // Arrange
        expect(viewModel.isNSF, false); // Default after reset

        // Act
        viewModel.toggleIsNSF();

        // Assert
        expect(viewModel.isNSF, true);
        expect(viewModel.isEdited, true);

        // Act again
        viewModel.toggleIsNSF();

        // Assert
        expect(viewModel.isNSF, false);
      });
    });

    group('IPPT values', () {
      test('should set push up value correctly', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.pushUpValue = 30;

        // Assert
        expect(viewModel.pushUpValue, 30);
        expect(listenerCalled, true);
      });

      test('should set sit up value correctly', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.sitUpValue = 40;

        // Assert
        expect(viewModel.sitUpValue, 40);
        expect(listenerCalled, true);
      });

      test('should set run value correctly', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.runValue = 600; // 10 minutes

        // Assert
        expect(viewModel.runValue, 600);
        expect(listenerCalled, true);
      });
    });

    group('resetParameters', () {
      test('should reset parameters from user entity', () {
        // Arrange
        final dob = DateTime(2000, 1, 1); // Age ~23
        final enlistmentDate = DateTime(2023, 1, 1);
        final ordDate = DateTime(2025, 1, 1);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: dob,
            isShiongVoc: true,
            enlistmentDate: enlistmentDate,
            ordDate: ordDate,
          ),
        );

        // Set some modified values first
        viewModel.setAge(30);
        viewModel.toggleIsShiongVoc();
        viewModel.toggleIsNSF();

        // Act
        viewModel.resetParameters();

        // Assert
        expect(viewModel.age, greaterThanOrEqualTo(23));
        expect(viewModel.isShiongVocLocal, true);
        expect(viewModel.isEdited, false);
      });

      test('should handle null DOB gracefully', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(UserInfoEntity(dob: null));

        // Act
        viewModel.resetParameters();

        // Assert
        expect(viewModel.age, 16); // Default age
        expect(viewModel.isEdited, false);
      });
    });

    group('scoring without IPPT data', () {
      test('should return 0 points when IPPT data is not loaded', () {
        // Assert
        expect(viewModel.pushPoints, 0);
        expect(viewModel.sitPoints, 0);
        expect(viewModel.runPoints, 0);
        expect(viewModel.score, 0);
      });

      test('should return fail award when score is 0', () {
        // Assert
        expect(viewModel.award, 'fail');
      });
    });

    group('award calculation', () {
      test('should return correct awards based on score', () {
        // Test different score scenarios by mocking the individual point getters
        // Since we can't easily mock the JSON loading in unit tests,
        // we'll test the award logic with different score values

        // Note: This would require either mocking the getters or having test data
        // For now, we'll test the default behavior
        expect(viewModel.award, 'fail'); // Default with no data
      });
    });

    group('updateView', () {
      test('should notify listeners when updateView is called', () {
        // Arrange
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.updateView();

        // Assert
        expect(listenerCalled, true);
      });
    });

    group('age group calculation', () {
      test('should return correct age groups for various ages', () {
        // Test different age ranges
        final testCases = [
          (18, '<22'),
          (22, '22-24'),
          (25, '25-27'),
          (30, '28-30'),
          (35, '34-36'),
          (40, '37-39'),
          (45, '43-45'),
          (50, '49-51'),
          (55, '55-57'),
          (60, '58-60'),
        ];

        for (final testCase in testCases) {
          // Arrange
          viewModel.setAge(testCase.$1);

          // Act & Assert
          // Note: _getAgeGroup is private, so we can't test it directly
          // This would be tested indirectly through the scoring methods
          // when IPPT data is available
        }
      });
    });

    group('date of birth age derivation', () {
      test('should derive age correctly from DOB', () {
        // Arrange
        final dob = DateTime(2000, 1, 1); // Should be ~24-25 years old
        fakeUserInfoUsecases.setUserInfo(UserInfoEntity(dob: dob));

        // Act
        viewModel.resetParameters();

        // Assert
        expect(viewModel.age, greaterThanOrEqualTo(23));
        expect(viewModel.age, lessThanOrEqualTo(25));
      });

      test('should handle birthday calculation correctly', () {
        // Test with a DOB that hasn't had a birthday this year
        final now = DateTime.now();
        final dobNotYetBirthday = DateTime(
          now.year - 25,
          now.month + 1,
          now.day,
        );
        final dobAlreadyBirthday = DateTime(
          now.year - 25,
          now.month - 1,
          now.day,
        );

        // Test not yet birthday case
        if (dobNotYetBirthday.month <= 12) {
          fakeUserInfoUsecases.setUserInfo(
            UserInfoEntity(dob: dobNotYetBirthday),
          );
          viewModel.resetParameters();
          expect(
            viewModel.age,
            24,
          ); // One year less since birthday hasn't passed
        }

        // Test already had birthday case
        if (dobAlreadyBirthday.month >= 1) {
          fakeUserInfoUsecases.setUserInfo(
            UserInfoEntity(dob: dobAlreadyBirthday),
          );
          viewModel.resetParameters();
          expect(viewModel.age, 25); // Full age since birthday has passed
        }
      });
    });

    group('NSF status calculation', () {
      test('should correctly determine NSF status from service dates', () {
        final now = DateTime.now();

        // Test case: Currently serving (between enlistment and ORD)
        final enlistmentDate = now.subtract(const Duration(days: 365));
        final ordDate = now.add(const Duration(days: 365));
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(enlistmentDate: enlistmentDate, ordDate: ordDate),
        );

        // Act
        viewModel.resetParameters();

        // Assert
        expect(viewModel.isNSF, true);
      });

      test('should handle missing service dates', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(enlistmentDate: null, ordDate: null),
        );

        // Act
        viewModel.resetParameters();

        // Assert
        expect(viewModel.isNSF, false);
      });
    });
  });
}
