import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/enums/colour_option.dart';

void main() {
  group('ColourOption', () {
    test('should have correct enum values', () {
      expect(ColourOption.values.length, 5);
      expect(ColourOption.values, contains(ColourOption.system));
      expect(ColourOption.values, contains(ColourOption.deepPurple));
      expect(ColourOption.values, contains(ColourOption.red));
      expect(ColourOption.values, contains(ColourOption.green));
      expect(ColourOption.values, contains(ColourOption.blue));
    });

    test('should have correct string representation', () {
      expect(ColourOption.system.name, 'system');
      expect(ColourOption.deepPurple.name, 'deepPurple');
      expect(ColourOption.red.name, 'red');
      expect(ColourOption.green.name, 'green');
      expect(ColourOption.blue.name, 'blue');
    });

    test('should be comparable', () {
      expect(ColourOption.system == ColourOption.system, true);
      expect(ColourOption.red == ColourOption.red, true);
      expect(ColourOption.blue == ColourOption.blue, true);
      expect(ColourOption.system == ColourOption.red, false);
      expect(ColourOption.green == ColourOption.blue, false);
    });

    test('should have correct index values', () {
      expect(ColourOption.system.index, 0);
      expect(ColourOption.deepPurple.index, 1);
      expect(ColourOption.red.index, 2);
      expect(ColourOption.green.index, 3);
      expect(ColourOption.blue.index, 4);
    });
  });
}
