import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class SettingsEntity {
  bool useDynamicColors;
  bool isDarkMode;
  ThemeOption theme;
  ColourOption primaryColour;
  // Flag to disable persistence for testing
  final bool disablePersistence;

  SettingsEntity({
    this.useDynamicColors = true,
    this.isDarkMode = false,
    this.theme = ThemeOption.system,
    this.primaryColour = ColourOption.system,
    this.disablePersistence = false,
  });
}
