import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'app_theme_test.dart' as app_theme_tests;
import 'data/models/user_info_model_test.dart' as user_info_model_tests;
import 'domain/entities/settings_entity_test.dart' as settings_entity_tests;
import 'domain/entities/user_info_entity_test.dart' as user_info_entity_tests;
import 'domain/usecases/settings_usecases_impl_test.dart'
    as settings_usecases_tests;
import 'domain/usecases/user_info_usecases_impl_test.dart'
    as user_info_usecases_tests;
import 'enums/colour_option_test.dart' as colour_option_tests;
import 'enums/theme_option_test.dart' as theme_option_tests;
import 'main_test.dart' as main_tests;

void main() {
  group('NS Buddy Test Suite', () {
    group('Enums', () {
      colour_option_tests.main();
      theme_option_tests.main();
    });

    group('Entities', () {
      settings_entity_tests.main();
      user_info_entity_tests.main();
    });

    group('Data Models', () {
      user_info_model_tests.main();
    });

    group('Use Cases', () {
      settings_usecases_tests.main();
      user_info_usecases_tests.main();
    });

    group('App Theme', () {
      app_theme_tests.main();
    });

    group('Main App', () {
      main_tests.main();
    });
  });
}
