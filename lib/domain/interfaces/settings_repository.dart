import 'package:ns_buddy/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> retrieveSettings();
  Future<void> updateSettings(SettingsEntity settings);
  Future<void> resetSettings();
}
