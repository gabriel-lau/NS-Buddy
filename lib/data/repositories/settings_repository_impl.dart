import 'package:ns_buddy/data/datasources/shared_preference_datasource.dart';
import 'package:ns_buddy/data/models/settings_model.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  // reference to shared preferences
  final SharedPreferenceDataSource _localDataSource;
  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<SettingsEntity> retrieveSettings() async {
    try {
      return await _localDataSource.loadSettings();
    } catch (e) {
      await _localDataSource.saveSettings(
        SettingsModel.defaultSettings(),
      ); // Save default settings
      return SettingsModel.defaultSettings(); // Return default settings
    }
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    try {
      // Validate settings before saving
      if (settings.theme == null || settings.primaryColour == null) {
        throw Exception('Invalid settings data');
      }
      await _localDataSource.saveSettings(SettingsModel.fromEntity(settings));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetSettings() async {
    try {
      await _localDataSource.resetSettings();
    } catch (e) {
      rethrow;
    }
  }
}
