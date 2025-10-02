import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';

class SettingsUsecasesImpl extends ChangeNotifier implements SettingsUsecases {
  final SettingsRepository repository;

  SettingsUsecasesImpl(this.repository);

  @override
  late SettingsEntity settingsEntity;

  @override
  Future<void> retrieveSettings() async {
    settingsEntity = await repository.retrieveSettings();
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    settingsEntity = settings;
    notifyListeners();
    await repository.updateSettings(settings);
  }

  @override
  Future<void> resetSettings() async {
    settingsEntity = SettingsEntity(); // Reset to default values
    notifyListeners();
    await repository.resetSettings();
  }
}
