import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';

class SettingsUsecasesImpl implements SettingsUsecases {
  final SettingsRepository repository;

  SettingsUsecasesImpl(this.repository);

  @override
  Future<SettingsEntity> retrieveSettings() async {
    return await repository.retrieveSettings();
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await repository.updateSettings(settings);
  }

  @override
  Future<void> resetSettings() async {
    await repository.resetSettings();
  }
}
