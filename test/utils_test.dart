import 'package:flutter_test/flutter_test.dart';
import 'package:o_connect/ui/utils/utils.dart';

void main() {
  group('normalizeExitUrl', () {
    test('should return valid url', () {
      expect(normalizeExitUrl('olx.in'), 'https://olx.in');
      expect(normalizeExitUrl('http://olx.in'), 'http://olx.in');
      expect(normalizeExitUrl('https://olx.in'), 'https://olx.in');
    });
    test('should return default exit url', () {
      String defaultUrl = 'https://www.onpassive.com';
      expect(normalizeExitUrl('://olx.in'), defaultUrl);
      expect(normalizeExitUrl('http:sdf://olx.in'), defaultUrl);
      expect(normalizeExitUrl('http:://olx.in'), defaultUrl);
      expect(normalizeExitUrl('http://https://olx.in'), defaultUrl);
    });
  });
}
