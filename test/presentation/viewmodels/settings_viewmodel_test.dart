import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';
import 'package:ns_buddy/presentation/viewmodels/settings_viewmodel.dart';

// Fake implementations for testing
class FakeSettingsUsecases extends SettingsUsecases {
  SettingsEntity _settingsEntity = SettingsEntity();

  @override
  SettingsEntity get settingsEntity => _settingsEntity;

  void setSettings(SettingsEntity settings) {
    _settingsEntity = settings;
  }

  @override
  Future<void> retrieveSettings() async {
    // No-op for testing
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    _settingsEntity = settings;
    notifyListeners();
  }

  @override
  Future<void> resetSettings() async {
    _settingsEntity = SettingsEntity();
    notifyListeners();
  }
}

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
    notifyListeners();
  }

  @override
  Future<void> resetUserInfo() async {
    _userInfoEntity = null;
    notifyListeners();
  }
}

void main() {
  group('SettingsViewModel', () {
    late SettingsViewModel viewModel;
    late FakeSettingsUsecases fakeSettingsUsecases;
    late FakeUserInfoUsecases fakeUserInfoUsecases;

    setUp(() {
      fakeSettingsUsecases = FakeSettingsUsecases();
      fakeUserInfoUsecases = FakeUserInfoUsecases();
      viewModel = SettingsViewModel(
        settingsUsecases: fakeSettingsUsecases,
        userInfoUsecases: fakeUserInfoUsecases,
      );
    });

    group('date of birth', () {
      test('should return DOB when user has DOB', () {
        // Arrange
        final dob = DateTime(1995, 6, 15);
        fakeUserInfoUsecases.setUserInfo(UserInfoEntity(dob: dob));

        // Act
        final result = viewModel.dob;

        // Assert
        expect(result, dob);
      });

      test('should update DOB correctly', () async {
        // Arrange
        final newDob = DateTime(1996, 8, 20);
        final originalUserInfo = UserInfoEntity(
          dob: DateTime(2000, 1, 1),
          gender: 'male',
          isShiongVoc: true,
          ordDate: DateTime(2025, 1, 1),
          enlistmentDate: DateTime(2023, 1, 1),
          hasCompletedOnboarding: true,
        );
        fakeUserInfoUsecases.setUserInfo(originalUserInfo);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setDob(newDob);

        // Assert
        expect(fakeUserInfoUsecases.userInfoEntity!.dob, newDob);
        expect(
          fakeUserInfoUsecases.userInfoEntity!.gender,
          originalUserInfo.gender,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.isShiongVoc,
          originalUserInfo.isShiongVoc,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.ordDate,
          originalUserInfo.ordDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
          originalUserInfo.enlistmentDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          originalUserInfo.hasCompletedOnboarding,
        );
        expect(listenerCalled, true);
      });
    });

    group('isShiongVoc', () {
      test('should return false when user has default isShiongVoc value', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1)),
        ); // Default isShiongVoc is false

        // Act
        final result = viewModel.isShiongVoc;

        // Assert
        expect(result, false);
      });

      test('should return isShiongVoc when user has value', () {
        // Arrange
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1), isShiongVoc: true),
        );

        // Act
        final result = viewModel.isShiongVoc;

        // Assert
        expect(result, true);
      });

      test('should update isShiongVoc correctly', () async {
        // Arrange
        final originalUserInfo = UserInfoEntity(
          dob: DateTime(1995, 6, 15),
          gender: 'male',
          isShiongVoc: false,
          ordDate: DateTime(2025, 1, 1),
          enlistmentDate: DateTime(2023, 1, 1),
          hasCompletedOnboarding: true,
        );
        fakeUserInfoUsecases.setUserInfo(originalUserInfo);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setIsShiongVoc(true);

        // Assert
        expect(fakeUserInfoUsecases.userInfoEntity!.isShiongVoc, true);
        expect(fakeUserInfoUsecases.userInfoEntity!.dob, originalUserInfo.dob);
        expect(
          fakeUserInfoUsecases.userInfoEntity!.gender,
          originalUserInfo.gender,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.ordDate,
          originalUserInfo.ordDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
          originalUserInfo.enlistmentDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          originalUserInfo.hasCompletedOnboarding,
        );
        expect(listenerCalled, true);
      });
    });

    group('enlistment date', () {
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

      test('should return enlistment date when user has value', () {
        // Arrange
        final enlistmentDate = DateTime(2023, 3, 15);
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

      test('should update enlistment date correctly', () async {
        // Arrange
        final newEnlistmentDate = DateTime(2023, 4, 20);
        final originalUserInfo = UserInfoEntity(
          dob: DateTime(1995, 6, 15),
          gender: 'male',
          isShiongVoc: true,
          ordDate: DateTime(2025, 1, 1),
          enlistmentDate: DateTime(2023, 1, 1),
          hasCompletedOnboarding: true,
        );
        fakeUserInfoUsecases.setUserInfo(originalUserInfo);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setEnlistmentDate(newEnlistmentDate);

        // Assert
        expect(
          fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
          newEnlistmentDate,
        );
        expect(fakeUserInfoUsecases.userInfoEntity!.dob, originalUserInfo.dob);
        expect(
          fakeUserInfoUsecases.userInfoEntity!.gender,
          originalUserInfo.gender,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.isShiongVoc,
          originalUserInfo.isShiongVoc,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.ordDate,
          originalUserInfo.ordDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          originalUserInfo.hasCompletedOnboarding,
        );
        expect(listenerCalled, true);
      });
    });

    group('ORD date', () {
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

      test('should return ORD date when user has value', () {
        // Arrange
        final ordDate = DateTime(2025, 3, 15);
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(dob: DateTime(2000, 1, 1), ordDate: ordDate),
        );

        // Act
        final result = viewModel.ordDate;

        // Assert
        expect(result, ordDate);
      });

      test('should update ORD date correctly', () async {
        // Arrange
        final newOrdDate = DateTime(2025, 4, 20);
        final originalUserInfo = UserInfoEntity(
          dob: DateTime(1995, 6, 15),
          gender: 'male',
          isShiongVoc: true,
          ordDate: DateTime(2025, 1, 1),
          enlistmentDate: DateTime(2023, 1, 1),
          hasCompletedOnboarding: true,
        );
        fakeUserInfoUsecases.setUserInfo(originalUserInfo);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setOrdDate(newOrdDate);

        // Assert
        expect(fakeUserInfoUsecases.userInfoEntity!.ordDate, newOrdDate);
        expect(fakeUserInfoUsecases.userInfoEntity!.dob, originalUserInfo.dob);
        expect(
          fakeUserInfoUsecases.userInfoEntity!.gender,
          originalUserInfo.gender,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.isShiongVoc,
          originalUserInfo.isShiongVoc,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
          originalUserInfo.enlistmentDate,
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          originalUserInfo.hasCompletedOnboarding,
        );
        expect(listenerCalled, true);
      });
    });

    group('theme', () {
      test('should return default theme when no theme is set', () {
        // Arrange
        fakeSettingsUsecases.setSettings(SettingsEntity());

        // Act
        final result = viewModel.theme;

        // Assert
        expect(result, ThemeOption.system); // Default theme
      });

      test('should return theme when theme is set', () {
        // Arrange
        fakeSettingsUsecases.setSettings(
          SettingsEntity(theme: ThemeOption.dark),
        );

        // Act
        final result = viewModel.theme;

        // Assert
        expect(result, ThemeOption.dark);
      });

      test('should update theme correctly', () async {
        // Arrange
        final originalSettings = SettingsEntity(
          theme: ThemeOption.light,
          primaryColour: ColourOption.blue,
        );
        fakeSettingsUsecases.setSettings(originalSettings);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setTheme(ThemeOption.dark);

        // Assert
        expect(fakeSettingsUsecases.settingsEntity.theme, ThemeOption.dark);
        expect(
          fakeSettingsUsecases.settingsEntity.primaryColour,
          originalSettings.primaryColour,
        );
        expect(listenerCalled, true);
      });
    });

    group('primary colour', () {
      test('should return default colour when no colour is set', () {
        // Arrange
        fakeSettingsUsecases.setSettings(SettingsEntity());

        // Act
        final result = viewModel.primaryColour;

        // Assert
        expect(result, ColourOption.blue); // Default colour
      });

      test('should return colour when colour is set', () {
        // Arrange
        fakeSettingsUsecases.setSettings(
          SettingsEntity(primaryColour: ColourOption.red),
        );

        // Act
        final result = viewModel.primaryColour;

        // Assert
        expect(result, ColourOption.red);
      });

      test('should update primary colour correctly', () async {
        // Arrange
        final originalSettings = SettingsEntity(
          theme: ThemeOption.dark,
          primaryColour: ColourOption.blue,
        );
        fakeSettingsUsecases.setSettings(originalSettings);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.setPrimaryColour(ColourOption.green);

        // Assert
        expect(
          fakeSettingsUsecases.settingsEntity.primaryColour,
          ColourOption.green,
        );
        expect(
          fakeSettingsUsecases.settingsEntity.theme,
          originalSettings.theme,
        );
        expect(listenerCalled, true);
      });
    });

    group('resetSettings', () {
      test('should reset both settings and user info', () async {
        // Arrange
        fakeSettingsUsecases.setSettings(
          SettingsEntity(
            theme: ThemeOption.dark,
            primaryColour: ColourOption.red,
          ),
        );
        fakeUserInfoUsecases.setUserInfo(
          UserInfoEntity(
            dob: DateTime(1995, 6, 15),
            gender: 'male',
            isShiongVoc: true,
            ordDate: DateTime(2025, 1, 1),
            enlistmentDate: DateTime(2023, 1, 1),
            hasCompletedOnboarding: true,
          ),
        );

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.resetSettings();

        // Assert
        expect(fakeSettingsUsecases.settingsEntity.theme, ThemeOption.system);
        expect(
          fakeSettingsUsecases.settingsEntity.primaryColour,
          ColourOption.blue,
        );
        expect(fakeUserInfoUsecases.userInfoEntity, isNull);
        expect(listenerCalled, true);
      });
    });

    group('data preservation', () {
      test('should preserve unmodified fields when updating DOB', () async {
        // Arrange
        final originalUserInfo = UserInfoEntity(
          dob: DateTime(1995, 1, 1),
          gender: 'female',
          isShiongVoc: false,
          ordDate: DateTime(2024, 12, 31),
          enlistmentDate: DateTime(2022, 6, 15),
          hasCompletedOnboarding: false,
        );
        fakeUserInfoUsecases.setUserInfo(originalUserInfo);

        // Act
        await viewModel.setDob(DateTime(1996, 5, 10));

        // Assert
        expect(fakeUserInfoUsecases.userInfoEntity!.dob, DateTime(1996, 5, 10));
        expect(fakeUserInfoUsecases.userInfoEntity!.gender, 'female');
        expect(fakeUserInfoUsecases.userInfoEntity!.isShiongVoc, false);
        expect(
          fakeUserInfoUsecases.userInfoEntity!.ordDate,
          DateTime(2024, 12, 31),
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
          DateTime(2022, 6, 15),
        );
        expect(
          fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
          false,
        );
      });

      test(
        'should preserve unmodified fields when updating isShiongVoc',
        () async {
          // Arrange
          final originalUserInfo = UserInfoEntity(
            dob: DateTime(1995, 1, 1),
            gender: 'female',
            isShiongVoc: false,
            ordDate: DateTime(2024, 12, 31),
            enlistmentDate: DateTime(2022, 6, 15),
            hasCompletedOnboarding: false,
          );
          fakeUserInfoUsecases.setUserInfo(originalUserInfo);

          // Act
          await viewModel.setIsShiongVoc(true);

          // Assert
          expect(
            fakeUserInfoUsecases.userInfoEntity!.dob,
            DateTime(1995, 1, 1),
          );
          expect(fakeUserInfoUsecases.userInfoEntity!.gender, 'female');
          expect(fakeUserInfoUsecases.userInfoEntity!.isShiongVoc, true);
          expect(
            fakeUserInfoUsecases.userInfoEntity!.ordDate,
            DateTime(2024, 12, 31),
          );
          expect(
            fakeUserInfoUsecases.userInfoEntity!.enlistmentDate,
            DateTime(2022, 6, 15),
          );
          expect(
            fakeUserInfoUsecases.userInfoEntity!.hasCompletedOnboarding,
            false,
          );
        },
      );

      test('should preserve unmodified settings when updating theme', () async {
        // Arrange
        final originalSettings = SettingsEntity(
          theme: ThemeOption.light,
          primaryColour: ColourOption.deepPurple,
        );
        fakeSettingsUsecases.setSettings(originalSettings);

        // Act
        await viewModel.setTheme(ThemeOption.system);

        // Assert
        expect(fakeSettingsUsecases.settingsEntity.theme, ThemeOption.system);
        expect(
          fakeSettingsUsecases.settingsEntity.primaryColour,
          ColourOption.deepPurple,
        );
      });

      test(
        'should preserve unmodified settings when updating primary colour',
        () async {
          // Arrange
          final originalSettings = SettingsEntity(
            theme: ThemeOption.light,
            primaryColour: ColourOption.deepPurple,
          );
          fakeSettingsUsecases.setSettings(originalSettings);

          // Act
          await viewModel.setPrimaryColour(ColourOption.red);

          // Assert
          expect(fakeSettingsUsecases.settingsEntity.theme, ThemeOption.light);
          expect(
            fakeSettingsUsecases.settingsEntity.primaryColour,
            ColourOption.red,
          );
        },
      );
    });
  });
}
