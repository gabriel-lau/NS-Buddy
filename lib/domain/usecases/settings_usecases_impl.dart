import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';

class SettingsUsecasesImpl extends ChangeNotifier implements SettingsUsecases {
  final SettingsRepository repository;

  SettingsUsecasesImpl(this.repository);

  late SettingsEntity _currentSettings;

  @override
  Future<SettingsEntity> retrieveSettings() async {
    _currentSettings = await repository.retrieveSettings();
    return _currentSettings;
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    _currentSettings = settings;
    notifyListeners();
    await repository.updateSettings(settings);
  }

  @override
  Future<void> resetSettings() async {
    _currentSettings = SettingsEntity(); // Reset to default values
    notifyListeners();
    await repository.resetSettings();
  }
}
