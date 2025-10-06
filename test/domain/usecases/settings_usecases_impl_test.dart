import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';
import 'package:ns_buddy/domain/usecases/settings_usecases_impl.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

// Fake implementation for testing
class FakeSettingsRepository implements SettingsRepository {
  SettingsEntity? _storedSettings;
  bool shouldThrow = false;
  String? errorMessage;

  @override
  Future<SettingsEntity> retrieveSettings() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    return _storedSettings ?? SettingsEntity();
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    _storedSettings = settings;
  }

  @override
  Future<void> resetSettings() async {
    if (shouldThrow) throw Exception(errorMessage ?? 'Test error');
    _storedSettings = SettingsEntity();
  }

  void setStoredSettings(SettingsEntity settings) {
    _storedSettings = settings;
  }

  void reset() {
    _storedSettings = null;
    shouldThrow = false;
    errorMessage = null;
  }
}

void main() {
  group('SettingsUsecasesImpl', () {
    late SettingsUsecasesImpl settingsUsecases;
    late FakeSettingsRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeSettingsRepository();
      settingsUsecases = SettingsUsecasesImpl(fakeRepository);
    });

    tearDown(() {
      fakeRepository.reset();
    });

    group('retrieveSettings', () {
      test('should retrieve settings from repository', () async {
        // Arrange
        final expectedSettings = SettingsEntity(
          useDynamicColors: false,
          isDarkMode: true,
          theme: ThemeOption.dark,
          primaryColour: ColourOption.red,
        );
        fakeRepository.setStoredSettings(expectedSettings);

        // Act
        await settingsUsecases.retrieveSettings();

        // Assert
        expect(
          settingsUsecases.settingsEntity.useDynamicColors,
          expectedSettings.useDynamicColors,
        );
        expect(
          settingsUsecases.settingsEntity.isDarkMode,
          expectedSettings.isDarkMode,
        );
        expect(settingsUsecases.settingsEntity.theme, expectedSettings.theme);
        expect(
          settingsUsecases.settingsEntity.primaryColour,
          expectedSettings.primaryColour,
        );
      });

      test('should handle repository errors', () async {
        // Arrange
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Database error';

        // Act & Assert
        expect(() => settingsUsecases.retrieveSettings(), throwsException);
      });
    });

    group('updateSettings', () {
      test('should update settings and notify listeners', () async {
        // Arrange
        final settings = SettingsEntity(
          useDynamicColors: true,
          isDarkMode: false,
          theme: ThemeOption.light,
          primaryColour: ColourOption.blue,
        );

        bool notificationReceived = false;
        settingsUsecases.addListener(() {
          notificationReceived = true;
        });

        // Act
        await settingsUsecases.updateSettings(settings);

        // Assert
        expect(
          settingsUsecases.settingsEntity.useDynamicColors,
          settings.useDynamicColors,
        );
        expect(settingsUsecases.settingsEntity.isDarkMode, settings.isDarkMode);
        expect(settingsUsecases.settingsEntity.theme, settings.theme);
        expect(
          settingsUsecases.settingsEntity.primaryColour,
          settings.primaryColour,
        );
        expect(notificationReceived, true);
      });

      test('should handle repository update errors', () async {
        // Arrange
        final settings = SettingsEntity(theme: ThemeOption.dark);
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Update failed';

        // Act & Assert
        expect(
          () => settingsUsecases.updateSettings(settings),
          throwsException,
        );
      });

      test('should update local state even if repository fails', () async {
        // Arrange
        final settings = SettingsEntity(
          isDarkMode: true,
          primaryColour: ColourOption.green,
        );
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Network error';

        bool notificationReceived = false;
        settingsUsecases.addListener(() {
          notificationReceived = true;
        });

        // Act & Assert
        expect(
          () => settingsUsecases.updateSettings(settings),
          throwsException,
        );

        // Local state should still be updated
        expect(settingsUsecases.settingsEntity.isDarkMode, settings.isDarkMode);
        expect(
          settingsUsecases.settingsEntity.primaryColour,
          settings.primaryColour,
        );
        expect(notificationReceived, true);
      });
    });

    group('resetSettings', () {
      test(
        'should reset settings to default values and notify listeners',
        () async {
          // Arrange
          // First set some non-default values
          final initialSettings = SettingsEntity(
            useDynamicColors: false,
            isDarkMode: true,
            theme: ThemeOption.dark,
            primaryColour: ColourOption.red,
          );
          await settingsUsecases.updateSettings(initialSettings);

          bool notificationReceived = false;
          settingsUsecases.addListener(() {
            notificationReceived = true;
          });

          // Act
          await settingsUsecases.resetSettings();

          // Assert
          expect(settingsUsecases.settingsEntity.useDynamicColors, true);
          expect(settingsUsecases.settingsEntity.isDarkMode, false);
          expect(settingsUsecases.settingsEntity.theme, ThemeOption.system);
          expect(
            settingsUsecases.settingsEntity.primaryColour,
            ColourOption.blue,
          );
          expect(settingsUsecases.settingsEntity.disablePersistence, false);
          expect(notificationReceived, true);
        },
      );

      test('should handle repository reset errors', () async {
        // Arrange
        fakeRepository.shouldThrow = true;
        fakeRepository.errorMessage = 'Reset failed';

        // Act & Assert
        expect(() => settingsUsecases.resetSettings(), throwsException);
      });
    });

    group('ChangeNotifier behavior', () {
      test('should notify listeners on updateSettings', () async {
        // Arrange
        final settings1 = SettingsEntity(theme: ThemeOption.light);
        final settings2 = SettingsEntity(theme: ThemeOption.dark);

        int notificationCount = 0;
        settingsUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await settingsUsecases.updateSettings(settings1);
        await settingsUsecases.updateSettings(settings2);

        // Assert
        expect(notificationCount, 2);
      });

      test('should notify listeners on resetSettings', () async {
        // Arrange
        int notificationCount = 0;
        settingsUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await settingsUsecases.resetSettings();

        // Assert
        expect(notificationCount, 1);
      });

      test('should not notify listeners on retrieveSettings', () async {
        // Arrange
        final settings = SettingsEntity(theme: ThemeOption.light);
        fakeRepository.setStoredSettings(settings);

        int notificationCount = 0;
        settingsUsecases.addListener(() {
          notificationCount++;
        });

        // Act
        await settingsUsecases.retrieveSettings();

        // Assert
        expect(notificationCount, 0);
      });
    });

    group('settingsEntity getter', () {
      test('should return current settings entity', () async {
        // Arrange
        final expectedSettings = SettingsEntity(
          useDynamicColors: false,
          theme: ThemeOption.light,
          primaryColour: ColourOption.deepPurple,
        );
        fakeRepository.setStoredSettings(expectedSettings);

        // Act
        await settingsUsecases.retrieveSettings();
        final result = settingsUsecases.settingsEntity;

        // Assert
        expect(result.useDynamicColors, expectedSettings.useDynamicColors);
        expect(result.theme, expectedSettings.theme);
        expect(result.primaryColour, expectedSettings.primaryColour);
      });
    });

    group('Settings combinations', () {
      test('should handle various theme and color combinations', () async {
        // Test different combinations
        final testCases = [
          {
            'settings': SettingsEntity(
              theme: ThemeOption.system,
              primaryColour: ColourOption.system,
            ),
            'description': 'system theme with system color',
          },
          {
            'settings': SettingsEntity(
              theme: ThemeOption.light,
              primaryColour: ColourOption.blue,
            ),
            'description': 'light theme with blue color',
          },
          {
            'settings': SettingsEntity(
              theme: ThemeOption.dark,
              primaryColour: ColourOption.red,
              useDynamicColors: false,
            ),
            'description': 'dark theme with red color and no dynamic colors',
          },
        ];

        for (final testCase in testCases) {
          final settings = testCase['settings'] as SettingsEntity;

          // Act
          await settingsUsecases.updateSettings(settings);

          // Assert
          expect(
            settingsUsecases.settingsEntity.theme,
            settings.theme,
            reason: 'Failed for ${testCase['description']}',
          );
          expect(
            settingsUsecases.settingsEntity.primaryColour,
            settings.primaryColour,
            reason: 'Failed for ${testCase['description']}',
          );
          expect(
            settingsUsecases.settingsEntity.useDynamicColors,
            settings.useDynamicColors,
            reason: 'Failed for ${testCase['description']}',
          );
        }
      });
    });
  });
}
