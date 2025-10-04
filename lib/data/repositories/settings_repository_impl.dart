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
    return await _localDataSource.loadSettings();
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await _localDataSource.saveSettings(SettingsModel.fromEntity(settings));
  }

  @override
  Future<void> resetSettings() async {
    await _localDataSource.resetSettings();
  }
}
