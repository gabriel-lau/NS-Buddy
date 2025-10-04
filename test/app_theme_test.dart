import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/app_theme.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

// Fake implementation for testing
class FakeSettingsUsecases extends ChangeNotifier implements SettingsUsecases {
  SettingsEntity _settings = SettingsEntity();

  @override
  SettingsEntity get settingsEntity => _settings;

  void setSettings(SettingsEntity settings) {
    _settings = settings;
  }

  @override
  Future<void> retrieveSettings() async {
    // No-op for testing
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    _settings = settings;
    notifyListeners();
  }

  @override
  Future<void> resetSettings() async {
    _settings = SettingsEntity();
    notifyListeners();
  }
}

void main() {
  group('AppTheme', () {
    late AppTheme appTheme;
    late FakeSettingsUsecases fakeSettingsUsecases;

    setUp(() {
      fakeSettingsUsecases = FakeSettingsUsecases();
      appTheme = AppTheme(fakeSettingsUsecases);
    });

    group('themeMode', () {
      test('should return ThemeMode.system when theme is system', () {
        // Arrange
        final settings = SettingsEntity(theme: ThemeOption.system);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.themeMode;

        // Assert
        expect(result, ThemeMode.system);
      });

      test('should return ThemeMode.light when theme is light', () {
        // Arrange
        final settings = SettingsEntity(theme: ThemeOption.light);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.themeMode;

        // Assert
        expect(result, ThemeMode.light);
      });

      test('should return ThemeMode.dark when theme is dark', () {
        // Arrange
        final settings = SettingsEntity(theme: ThemeOption.dark);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.themeMode;

        // Assert
        expect(result, ThemeMode.dark);
      });
    });

    group('primarySwatch', () {
      test('should return Colors.red when color is red', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.red);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.primarySwatch;

        // Assert
        expect(result, Colors.red);
      });

      test('should return Colors.green when color is green', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.green);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.primarySwatch;

        // Assert
        expect(result, Colors.green);
      });

      test('should return Colors.deepPurple when color is deepPurple', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.deepPurple);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.primarySwatch;

        // Assert
        expect(result, Colors.deepPurple);
      });

      test('should return Colors.blue when color is blue', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.blue);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.primarySwatch;

        // Assert
        expect(result, Colors.blue);
      });

      test('should return Colors.blue when color is system (default)', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.system);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.primarySwatch;

        // Assert
        expect(result, Colors.blue);
      });
    });

    group('buildLightTheme', () {
      test(
        'should use dynamic scheme when color is system and dynamic scheme provided',
        () {
          // Arrange
          final settings = SettingsEntity(primaryColour: ColourOption.system);
          fakeSettingsUsecases.setSettings(settings);
          final dynamicScheme = ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.light,
          );

          // Act
          final result = appTheme.buildLightTheme(dynamicScheme: dynamicScheme);

          // Assert
          expect(result.useMaterial3, true);
          expect(result.colorScheme, dynamicScheme);
        },
      );

      test('should use custom color scheme when color is not system', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.red);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.buildLightTheme();

        // Assert
        expect(result.useMaterial3, true);
        expect(result.colorScheme.brightness, Brightness.light);
      });

      test('should handle null dynamic scheme with system color', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.system);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.buildLightTheme(dynamicScheme: null);

        // Assert
        expect(result.useMaterial3, true);
        // When colorScheme is null, Flutter creates a default colorScheme
        expect(result.colorScheme, isNotNull);
      });
    });

    group('buildDarkTheme', () {
      test(
        'should use dynamic scheme when color is system and dynamic scheme provided',
        () {
          // Arrange
          final settings = SettingsEntity(primaryColour: ColourOption.system);
          fakeSettingsUsecases.setSettings(settings);
          final dynamicScheme = ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.dark,
          );

          // Act
          final result = appTheme.buildDarkTheme(dynamicScheme: dynamicScheme);

          // Assert
          expect(result.useMaterial3, true);
          expect(result.colorScheme, dynamicScheme);
        },
      );

      test('should use custom color scheme when color is not system', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.deepPurple);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.buildDarkTheme();

        // Assert
        expect(result.useMaterial3, true);
        expect(result.colorScheme.brightness, Brightness.dark);
      });

      test('should handle null dynamic scheme with system color', () {
        // Arrange
        final settings = SettingsEntity(primaryColour: ColourOption.system);
        fakeSettingsUsecases.setSettings(settings);

        // Act
        final result = appTheme.buildDarkTheme(dynamicScheme: null);

        // Assert
        expect(result.useMaterial3, true);
        // When colorScheme is null, Flutter creates a default colorScheme
        expect(result.colorScheme, isNotNull);
      });
    });

    group('theme consistency', () {
      test(
        'should maintain consistent color scheme between light and dark themes',
        () {
          // Arrange
          final settings = SettingsEntity(primaryColour: ColourOption.red);
          fakeSettingsUsecases.setSettings(settings);

          // Act
          final lightTheme = appTheme.buildLightTheme();
          final darkTheme = appTheme.buildDarkTheme();

          // Assert
          expect(lightTheme.colorScheme.brightness, Brightness.light);
          expect(darkTheme.colorScheme.brightness, Brightness.dark);
          expect(lightTheme.useMaterial3, darkTheme.useMaterial3);
        },
      );

      test('should handle all color options correctly', () {
        final colorOptions = ColourOption.values;

        for (final colorOption in colorOptions) {
          // Arrange
          final settings = SettingsEntity(primaryColour: colorOption);
          fakeSettingsUsecases.setSettings(settings);

          // Act
          final primarySwatch = appTheme.primarySwatch;
          final lightTheme = appTheme.buildLightTheme();
          final darkTheme = appTheme.buildDarkTheme();

          // Assert
          expect(
            primarySwatch,
            isA<MaterialColor>(),
            reason: 'Failed for color option: $colorOption',
          );
          expect(
            lightTheme.useMaterial3,
            true,
            reason: 'Failed for color option: $colorOption',
          );
          expect(
            darkTheme.useMaterial3,
            true,
            reason: 'Failed for color option: $colorOption',
          );
        }
      });

      test('should handle all theme options correctly', () {
        final themeOptions = ThemeOption.values;

        for (final themeOption in themeOptions) {
          // Arrange
          final settings = SettingsEntity(theme: themeOption);
          fakeSettingsUsecases.setSettings(settings);

          // Act
          final themeMode = appTheme.themeMode;

          // Assert
          expect(
            themeMode,
            isA<ThemeMode>(),
            reason: 'Failed for theme option: $themeOption',
          );

          switch (themeOption) {
            case ThemeOption.system:
              expect(themeMode, ThemeMode.system);
              break;
            case ThemeOption.light:
              expect(themeMode, ThemeMode.light);
              break;
            case ThemeOption.dark:
              expect(themeMode, ThemeMode.dark);
              break;
          }
        }
      });
    });
  });
}
