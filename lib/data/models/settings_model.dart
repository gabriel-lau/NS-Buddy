import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/enums/colour_option.dart';
import 'package:ns_buddy/enums/theme_option.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel({
    required super.theme,
    required super.primaryColour,
    required super.disablePersistence,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
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
      'theme': theme.toString().split('.').last,
      'primaryColour': primaryColour.toString().split('.').last,
      'disablePersistence': disablePersistence,
    };
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      theme: entity.theme,
      primaryColour: entity.primaryColour,
      disablePersistence: entity.disablePersistence,
    );
  }

  SettingsEntity toEntity() => SettingsEntity(
    theme: theme,
    primaryColour: primaryColour,
    disablePersistence: disablePersistence,
  );

  // Default constructor with default values
  SettingsModel.defaultSettings()
    : super(
        theme: ThemeOption.system,
        primaryColour: ColourOption.blue,
        disablePersistence: false,
      );
}
