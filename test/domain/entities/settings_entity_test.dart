import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

void main() {
  group('SettingsEntity', () {
    test('should create SettingsEntity with default values', () {
      // Act
      final settings = SettingsEntity();

      // Assert
      expect(settings.useDynamicColors, true);
      expect(settings.isDarkMode, false);
      expect(settings.theme, ThemeOption.system);
      expect(settings.primaryColour, ColourOption.system);
      expect(settings.disablePersistence, false);
    });

    test('should create SettingsEntity with custom values', () {
      // Act
      final settings = SettingsEntity(
        useDynamicColors: false,
        isDarkMode: true,
        theme: ThemeOption.dark,
        primaryColour: ColourOption.red,
        disablePersistence: true,
      );

      // Assert
      expect(settings.useDynamicColors, false);
      expect(settings.isDarkMode, true);
      expect(settings.theme, ThemeOption.dark);
      expect(settings.primaryColour, ColourOption.red);
      expect(settings.disablePersistence, true);
    });

    test('should handle all theme options', () {
      final systemTheme = SettingsEntity(theme: ThemeOption.system);
      final lightTheme = SettingsEntity(theme: ThemeOption.light);
      final darkTheme = SettingsEntity(theme: ThemeOption.dark);

      expect(systemTheme.theme, ThemeOption.system);
      expect(lightTheme.theme, ThemeOption.light);
      expect(darkTheme.theme, ThemeOption.dark);
    });

    test('should handle all colour options', () {
      final systemColour = SettingsEntity(primaryColour: ColourOption.system);
      final redColour = SettingsEntity(primaryColour: ColourOption.red);
      final greenColour = SettingsEntity(primaryColour: ColourOption.green);
      final blueColour = SettingsEntity(primaryColour: ColourOption.blue);
      final deepPurpleColour = SettingsEntity(
        primaryColour: ColourOption.deepPurple,
      );

      expect(systemColour.primaryColour, ColourOption.system);
      expect(redColour.primaryColour, ColourOption.red);
      expect(greenColour.primaryColour, ColourOption.green);
      expect(blueColour.primaryColour, ColourOption.blue);
      expect(deepPurpleColour.primaryColour, ColourOption.deepPurple);
    });

    test('should handle mixed settings configurations', () {
      final config1 = SettingsEntity(
        useDynamicColors: true,
        isDarkMode: false,
        theme: ThemeOption.light,
        primaryColour: ColourOption.blue,
      );

      final config2 = SettingsEntity(
        useDynamicColors: false,
        isDarkMode: true,
        theme: ThemeOption.system,
        primaryColour: ColourOption.deepPurple,
      );

      // Test config1
      expect(config1.useDynamicColors, true);
      expect(config1.isDarkMode, false);
      expect(config1.theme, ThemeOption.light);
      expect(config1.primaryColour, ColourOption.blue);

      // Test config2
      expect(config2.useDynamicColors, false);
      expect(config2.isDarkMode, true);
      expect(config2.theme, ThemeOption.system);
      expect(config2.primaryColour, ColourOption.deepPurple);
    });

    test('should handle persistence flag correctly', () {
      final persistentSettings = SettingsEntity(disablePersistence: false);
      final nonPersistentSettings = SettingsEntity(disablePersistence: true);

      expect(persistentSettings.disablePersistence, false);
      expect(nonPersistentSettings.disablePersistence, true);
    });
  });
}
