import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/counter_tab_viewmodel.dart';

// Fake implementation for testing
class FakeUserInfoUsecases extends UserInfoUsecases {
  UserInfoEntity? _userInfoEntity = UserInfoEntity(dob: DateTime(2000, 1, 1));

  @override
  UserInfoEntity? get userInfoEntity => _userInfoEntity;

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
    _userInfoEntity = null;
  }
}

void main() {
  group('CounterTabViewModel', () {
    late CounterTabViewModel viewModel;
    late FakeUserInfoUsecases fakeUserInfoUsecases;

    setUp(() {
      fakeUserInfoUsecases = FakeUserInfoUsecases();
      viewModel = CounterTabViewModel(fakeUserInfoUsecases);
    });

    group('ordDate', () {
      test('should return null when user has no ORD date', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1), ordDate: null),
        );

        // Act
        final result = viewModel.ordDate;

        // Assert
        expect(result, isNull);
      });

      test('should return ORD date when user has ORD date', () {
        // Arrange
        final ordDate = DateTime(2025, 12, 31);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1), ordDate: ordDate),
        );

        // Act
        final result = viewModel.ordDate;

        // Assert
        expect(result, ordDate);
      });
    });

    group('enlistmentDate', () {
      test('should return null when user has no enlistment date', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1), enlistmentDate: null),
        );

        // Act
        final result = viewModel.enlistmentDate;

        // Assert
        expect(result, isNull);
      });

      test('should return enlistment date when user has enlistment date', () {
        // Arrange
        final enlistmentDate = DateTime(2023, 1, 15);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: enlistmentDate,
          ),
        );

        // Act
        final result = viewModel.enlistmentDate;

        // Assert
        expect(result, enlistmentDate);
      });
    });

    group('date calculations', () {
      test('should calculate total days correctly', () {
        // Arrange
        final enlistmentDate = DateTime(2023, 1, 1);
        final ordDate = DateTime(2025, 1, 1);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: enlistmentDate,
            ordDate: ordDate,
          ),
        );

        // Act
        final result = viewModel.totalDays;

        // Assert
        expect(result, 731); // 2 years = 731 days (including leap year 2024)
      });

      test('should return null for total days when dates are missing', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: DateTime(2023, 1, 1),
            ordDate: null,
          ),
        );

        // Act
        final result = viewModel.totalDays;

        // Assert
        expect(result, isNull);
      });

      test('should calculate elapsed days correctly', () {
        // Arrange
        final enlistmentDate = DateTime(2023, 1, 1);
        final ordDate = DateTime(2025, 1, 1);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: enlistmentDate,
            ordDate: ordDate,
          ),
        );

        // Act
        final result = viewModel.elapsedDays;

        // Assert
        expect(result, isNotNull);
        expect(result! >= 0, true);
      });

      test('should calculate remaining days correctly', () {
        // Arrange
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: tomorrow,
            ordDate: dayAfterTomorrow,
          ),
        );

        // Act
        final result = viewModel.remainingDays;

        // Assert
        expect(result, 2);
      });

      test('should calculate percent elapsed correctly', () {
        // Arrange
        final enlistmentDate = DateTime(2023, 1, 1);
        final ordDate = DateTime(2023, 1, 11); // 10 days total
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: enlistmentDate,
            ordDate: ordDate,
          ),
        );

        // Act
        final result = viewModel.percentElapsed;

        // Assert
        expect(result, isNotNull);
        expect(result! >= 0, true);
        expect(result <= 1, true);
      });

      test('should return null for percent elapsed when dates are missing', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(2000, 1, 1),
            enlistmentDate: null,
            ordDate: DateTime(2025, 1, 1),
          ),
        );

        // Act
        final result = viewModel.percentElapsed;

        // Assert
        expect(result, isNull);
      });
    });

    group('formatDate', () {
      test('should format date correctly', () {
        // Arrange
        final date = DateTime(2023, 12, 25);

        // Act
        final result = viewModel.formatDate(date);

        // Assert
        expect(result, '25 Dec 2023');
      });

      test('should return "Not set" for null date', () {
        // Act
        final result = viewModel.formatDate(null);

        // Assert
        expect(result, 'Not set');
      });

      test('should handle all months correctly', () {
        final expectedMonths = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        for (int i = 1; i <= 12; i++) {
          // Arrange
          final date = DateTime(2023, i, 15);

          // Act
          final result = viewModel.formatDate(date);

          // Assert
          expect(result, '15 ${expectedMonths[i - 1]} 2023');
        }
      });
    });

    group('getMonthName', () {
      test('should return correct month names', () {
        final expectedMonths = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        for (int i = 1; i <= 12; i++) {
          // Act
          final result = viewModel.getMonthName(i);

          // Assert
          expect(result, expectedMonths[i - 1]);
        }
      });
    });

    group('calculateWeekdaysLeft', () {
      test('should calculate weekdays correctly for one week', () {
        // Arrange
        final monday = DateTime(2023, 10, 2); // Monday
        final sunday = DateTime(2023, 10, 8); // Sunday

        // Act
        final result = viewModel.calculateWeekdaysLeft(monday, sunday);

        // Assert
        expect(result, 5); // Monday to Friday
      });

      test('should handle weekend start date', () {
        // Arrange
        final saturday = DateTime(2023, 10, 7); // Saturday
        final sunday = DateTime(2023, 10, 8); // Sunday

        // Act
        final result = viewModel.calculateWeekdaysLeft(saturday, sunday);

        // Assert
        expect(result, 0); // No weekdays between Saturday and Sunday
      });

      test('should return 0 for null end date', () {
        // Arrange
        final monday = DateTime(2023, 10, 2);

        // Act
        final result = viewModel.calculateWeekdaysLeft(monday, null);

        // Assert
        expect(result, 0);
      });

      test('should handle same day correctly', () {
        // Arrange
        final monday = DateTime(2023, 10, 2); // Monday

        // Act
        final result = viewModel.calculateWeekdaysLeft(monday, monday);

        // Assert
        expect(result, 1); // Same weekday counts as 1
      });
    });

    group('calculateWeekendsLeft', () {
      test('should calculate weekends correctly for one week', () {
        // Arrange
        final monday = DateTime(2023, 10, 2); // Monday
        final sunday = DateTime(2023, 10, 8); // Sunday

        // Act
        final result = viewModel.calculateWeekendsLeft(monday, sunday);

        // Assert
        expect(result, 2); // Saturday and Sunday
      });

      test('should handle weekend start date', () {
        // Arrange
        final saturday = DateTime(2023, 10, 7); // Saturday
        final sunday = DateTime(2023, 10, 8); // Sunday

        // Act
        final result = viewModel.calculateWeekendsLeft(saturday, sunday);

        // Assert
        expect(result, 2); // Saturday and Sunday
      });

      test('should return 0 for null end date', () {
        // Arrange
        final monday = DateTime(2023, 10, 2);

        // Act
        final result = viewModel.calculateWeekendsLeft(monday, null);

        // Assert
        expect(result, 0);
      });

      test('should handle same weekend day correctly', () {
        // Arrange
        final saturday = DateTime(2023, 10, 7); // Saturday

        // Act
        final result = viewModel.calculateWeekendsLeft(saturday, saturday);

        // Assert
        expect(result, 1); // Same weekend day counts as 1
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

    group('today getter', () {
      test('should return today with time set to midnight', () {
        // Act
        final result = viewModel.today;
        final now = DateTime.now();
        final expectedToday = DateTime(now.year, now.month, now.day);

        // Assert
        expect(result, expectedToday);
      });
    });

    group('now getter', () {
      test('should return current DateTime', () {
        // Act
        final result = viewModel.now;
        final now = DateTime.now();

        // Assert
        // Allow for small time difference due to test execution time
        final difference = result.difference(now).inMilliseconds.abs();
        expect(difference < 1000, true); // Less than 1 second difference
      });
    });
  });
}
