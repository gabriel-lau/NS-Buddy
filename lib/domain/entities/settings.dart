import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class Settings {
  bool useDynamicColors;
  bool isDarkMode;
  ThemeOption theme;
  ColourOption primaryColour;

  // User information fields
  DateTime? dob;
  String? gender;
  bool isShiongVoc = false;
  DateTime? ordDate;
  DateTime? enlistmentDate;
  bool hasCompletedOnboarding = false;

  // Flag to disable persistence for testing
  final bool disablePersistence;

  Settings({
    this.useDynamicColors = true,
    this.isDarkMode = false,
    this.theme = ThemeOption.system,
    this.primaryColour = ColourOption.system,
    this.disablePersistence = false,
  });
}
