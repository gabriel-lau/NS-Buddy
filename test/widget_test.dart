// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/models/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AppSettings can set and get user information', () {
    // Create a new AppSettings instance with persistence disabled for testing
    final settings = AppSettings(disablePersistence: true);

    // Set some test values
    final testDob = DateTime(1995, 5, 15);
    final testOrdDate = DateTime(2023, 12, 31);

    settings.setDob(testDob);
    settings.setGender('male');
    settings.setIsShiongVoc(true);
    settings.setIsNSF(false);
    settings.setOrdDate(testOrdDate);

    // Verify that the values were set correctly
    expect(settings.dob, equals(testDob));
    expect(settings.gender, equals('male'));
    expect(settings.isShiongVoc, isTrue);
    expect(settings.isNSF, isFalse);
    expect(settings.ordDate, equals(testOrdDate));
  });

  test('AppSettings handles null values correctly', () {
    // Create a new AppSettings instance with persistence disabled for testing
    final settings = AppSettings(disablePersistence: true);

    // Set some values to null
    settings.setDob(null);
    settings.setGender(null);
    settings.setIsShiongVoc(false);
    settings.setIsNSF(true);
    settings.setOrdDate(null);

    // Verify that null values are handled correctly
    expect(settings.dob, isNull);
    expect(settings.gender, isNull);
    expect(settings.isShiongVoc, isFalse);
    expect(settings.isNSF, isTrue);
    expect(settings.ordDate, isNull);
  });

  test('AppSettings notifies listeners when values change', () {
    // Create a new AppSettings instance with persistence disabled for testing
    final settings = AppSettings(disablePersistence: true);
    bool listenerCalled = false;

    // Add a listener
    settings.addListener(() {
      listenerCalled = true;
    });

    // Change a value
    settings.setDob(DateTime(1990, 1, 1));

    // Verify that the listener was called
    expect(listenerCalled, isTrue);
  });

  test('AppSettings has correct default values', () {
    // Create a new AppSettings instance with persistence disabled for testing
    final settings = AppSettings(disablePersistence: true);

    // Verify default values
    expect(settings.useDynamicColors, isTrue);
    expect(settings.isDarkMode, isFalse);
    expect(settings.dob, isNull);
    expect(settings.gender, isNull);
    expect(settings.isShiongVoc, isFalse);
    expect(settings.isNSF, isFalse);
    expect(settings.ordDate, isNull);
  });
}
