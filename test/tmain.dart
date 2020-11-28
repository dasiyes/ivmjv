import 'package:test/test.dart';
import 'jvalid/test_jvalid.dart';

/// The ivmJV package test suites
///
void main() {
  group('JValid', () {
    /// Test suite for proprietary JSON validation lib
    test('Function validate() testing...', () async {
      testJValidInit();
      testValidateFunctionMain();
      test_validateNameValuePair();
      testJsonObjects();
    });
  });
}
