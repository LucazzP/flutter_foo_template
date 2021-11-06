import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/extensions/string.ext.dart';

main() {
  group('Capitalize string tests', () {
    test('Should capitalize the first letter of a simple string', () {
      const testString = 'lucas';
      final capitalizedString = testString.capitalizeFirstLetter;
      expect(capitalizedString, 'Lucas');
    });
    test('Should capitalize the first letter of a complex string', () {
      const testString = 'lucas is an excellent programmer';
      final capitalizedString = testString.capitalizeFirstLetter;
      expect(capitalizedString, 'Lucas is an excellent programmer');
    });
    test('Should capitalize every first letter of a complex string', () {
      const testString = 'lucas is an excellent programmer';
      final capitalizedString = testString.capitalizeAllFirstLetters;
      expect(capitalizedString, 'Lucas Is An Excellent Programmer');
    });
  });
}
