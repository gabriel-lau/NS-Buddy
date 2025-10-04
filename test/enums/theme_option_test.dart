import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/enums/theme_option.dart';

void main() {
  group('ThemeOption', () {
    test('should have correct enum values', () {
      expect(ThemeOption.values.length, 3);
      expect(ThemeOption.values, contains(ThemeOption.system));
      expect(ThemeOption.values, contains(ThemeOption.light));
      expect(ThemeOption.values, contains(ThemeOption.dark));
    });

    test('should have correct string representation', () {
      expect(ThemeOption.system.name, 'system');
      expect(ThemeOption.light.name, 'light');
      expect(ThemeOption.dark.name, 'dark');
    });

    test('should be comparable', () {
      expect(ThemeOption.system == ThemeOption.system, true);
      expect(ThemeOption.light == ThemeOption.light, true);
      expect(ThemeOption.dark == ThemeOption.dark, true);
      expect(ThemeOption.system == ThemeOption.light, false);
      expect(ThemeOption.light == ThemeOption.dark, false);
    });

    test('should have correct index values', () {
      expect(ThemeOption.system.index, 0);
      expect(ThemeOption.light.index, 1);
      expect(ThemeOption.dark.index, 2);
    });
  });
}
