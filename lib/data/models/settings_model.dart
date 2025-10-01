import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel({
    required bool useDynamicColors,
    required bool isDarkMode,
    required ThemeOption theme,
    required ColourOption primaryColour,
    required bool disablePersistence,
  }) : super(
         useDynamicColors: useDynamicColors,
         isDarkMode: isDarkMode,
         theme: theme,
         primaryColour: primaryColour,
         disablePersistence: disablePersistence,
       );

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      useDynamicColors: json['useDynamicColors'] ?? true,
      isDarkMode: json['isDarkMode'] ?? false,
      theme: ThemeOption.values.firstWhere(
        (e) => e.toString() == 'ThemeOption.${json['theme']}',
        orElse: () => ThemeOption.system,
      ),
      primaryColour: ColourOption.values.firstWhere(
        (e) => e.toString() == 'ColourOption.${json['primaryColour']}',
        orElse: () => ColourOption.system,
      ),
      disablePersistence: json['disablePersistence'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'useDynamicColors': useDynamicColors,
      'isDarkMode': isDarkMode,
      'theme': theme.toString().split('.').last,
      'primaryColour': primaryColour.toString().split('.').last,
      'disablePersistence': disablePersistence,
    };
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      useDynamicColors: entity.useDynamicColors,
      isDarkMode: entity.isDarkMode,
      theme: entity.theme,
      primaryColour: entity.primaryColour,
      disablePersistence: entity.disablePersistence,
    );
  }

  SettingsEntity toEntity() => SettingsEntity(
    useDynamicColors: useDynamicColors,
    isDarkMode: isDarkMode,
    theme: theme,
    primaryColour: primaryColour,
    disablePersistence: disablePersistence,
  );
}
