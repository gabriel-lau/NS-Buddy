import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';

abstract class SettingsUsecases extends ChangeNotifier {
  Future<SettingsEntity> retrieveSettings();
  Future<void> updateSettings(SettingsEntity settings);
  Future<void> resetSettings();
}
