import 'package:ivmjv/ivmjv.dart';
import 'package:test/test.dart';

/// Test jvalid.dart initiation
///
/// Test class instantiation and validate() function initiation.
void testJValidInit() async {
  /// Test validate function initiation with empty parameter.
  var jv1 = JsonValidator('');
  var jv_result1 = await jv1.validate();
  expect(jv_result1, false);

  /// Test validate function initiation with empty ({}) json string).
  var jv2 = JsonValidator('{}');
  var jv_result2 = await jv2.validate();
  expect(jv_result2, true);

  /// Test validate function initiation with simple json value param provided at class instantiation.
  var jv3 = JsonValidator('{\"name\": \"test\", \"value\": 1}');
  var jv_result3 = await jv3.validate();
  expect(jv_result3, true);

  /// Test validate function initiation with simple json value param provided as direct validate() param.
  var jv4 = JsonValidator('');
  var jv_result4 = await jv4.validate('{\"name\": \"test\", \"value\": 1}');
  expect(jv_result4, true);
}

/// Test jvalid.dart validate()
///
/// Test validation of the main use cases:
/// - key-value pair's two parts: 1) name (key) and 2) value
/// * name should be double quoted
/// * value can be:
///   - string
///   - number
///   - 3 literal names: **true**, **false** or **null**
/// * structural chars: ":", ",", "[", "]", "{", "}"
///
void testValidateFunctionMain() async {
  /// Test the validation of the name(key) & value
  /// 1) valid name/key & value
  var jv = JsonValidator('');
  var result1 = await jv.validate('{\"name\": \"test\", \"value\": 1}');
  expect(result1, true);

  /// invalid key/name missing leading qm
  var result2 = await jv.validate('{name\": \"test\"}');
  expect(result2, false);

  /// invalid string value missing trailing qm
  var result6 = await jv.validate('{\"name\": \"test}');
  expect(result6, false);

  /// invalid string value missing leading qm
  var result3 = await jv.validate('{\"name\": test\"}');
  expect(result3, false);

  /// 2) validating the 3 lietral vlaue: false, true and null

  /// valid 'false' value
  var result4 = await jv.validate('{\"name\": false}');
  expect(result4, true);

  /// invalid 'false' value
  var result5 = await jv.validate('{\"name\": false\"}');
  expect(result5, false);

  /// valid 'true' value
  var result7 = await jv.validate('{\"name\": true}');
  expect(result7, true);

  /// invalid 'true' value
  var result8 = await jv.validate('{\"name\": true\"}');
  expect(result8, false);

  /// valid 'null' value
  var result9 = await jv.validate('{\"name\": null}');
  expect(result9, true);

  /// invalid 'null' value
  var result10 = await jv.validate('{\"name\": null\"}');
  expect(result10, false);

  /// 3) validating NUMBER values

  /// valid + 'number' value
  var result11 = await jv.validate('{\"positive\": 230}');
  expect(result11, true);

  /// valid - 'number' value
  var result12 = await jv.validate('{\"name\": -230}');
  expect(result12, true);

  /// valid exp 'numbr' value
  var result13 = await jv.validate('{\"name\": 1.5e-3}');
  expect(result13, true);

  /// invalid positive 'numbr' value
  var result14 = await jv.validate('{\"name\": +1.5}');
  expect(result14, false);

  /// 4) validation of empty structural objects '[]' and '{}'

  /// valid 'empty object - {}' value
  var result15 = await jv.validate('{\"empty_object\": {}}');
  expect(result15, true);

  /// valid 'empty array - []' value
  var result16 = await jv.validate('{\"empty_array\": []}');
  expect(result16, true);

  /// invalid 1 'array - [' value
  var result17 = await jv.validate('{\"empty_array\": [}');
  expect(result17, false);

  /// invalid 2 'array - [}' value
  var result18 = await jv.validate('{\"empty_array\": [}}');
  expect(result18, false);

  /// invalid 1 'object - {[space]' value
  var result19 = await jv.validate('{\"empty_array\": { }');
  expect(result19, false);

  /// invalid 2 'object - {' value [object.length == 1]
  var result20 = await jv.validate('{\"empty_array\": {}');
  expect(result20, false);
}

/// Unit test _validateNameValuePair() through validate()
///
/// * if paramter 'value' is empty string => false
/// * if parameter 'value'.length < 6 chars = {"":n} => false
/// * if parameter '_value' returned by _validateFirstKeyValuePair(_value)
/// == 'invalid' => false
/// * if parameter '_value' returned by _validateFirstKeyValuePair(_value)
/// == '' => true
///
void test_validateNameValuePair() async {
  /// value - empty string
  var jv = JsonValidator('');
  var result1 = await jv.validate(' ');
  expect(result1, false);

  /// value length = 6 chars {"":n}
  var result2 = await jv.validate('{\"\":1}');
  expect(result2, true);

  /// value length < 6 chars {":n}
  var result3 = await jv.validate('{\":1}');
  expect(result3, false);

  /// value == invalid => false
  var result4 = await jv.validate('{\"test\":invalid}');
  expect(result4, false);

  /// value == "invalid" => true
  var result5 = await jv.validate('{\"test\":\"invalid\"}');
  expect(result5, true);
}

/// Test JSON formats
///
/// Some example use cases that include edge cases too
/// TODO: Verify the testJsonObjects test items
///
void testJsonObjects() async {
  var jv = JsonValidator('');

  /// JSON 1  [expecct TRUE]
  /// - key/name : string
  /// - key/name : array
  ///   - object
  ///     - key/name : string
  ///     - key/name : string
  ///   - object
  ///     - key/name : array
  ///     - key/name : number
  ///
  var result1 = await jv.validate(
      '{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}]}');
  expect(result1, true);

  /// JSON 2  [expecct TRUE]
  /// JSON 1 +
  /// - key/name : number
  var result2 = await jv.validate(
      '{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}], \"kvo\": 34}');
  expect(result2, true);

  /// JSON 3  [expecct TRUE]
  ///
  /// - key/name : array
  ///   - number
  ///   - string
  ///   - bool - true
  ///   - null
  ///   - negative number
  /// - kye/name : decimal number
  /// - key/name : exp number
  ///
  var result3 = await jv.validate(
      '{"arrayMain": [1, "fal{se", true, null, -5], "kvo": 34.4, "expon": 1.05e-3}');
  expect(result3, true);

  /// JSON 4  [expecct TRUE]
  ///
  /// - key/name : array
  ///   - number
  ///   - string
  ///   - bool - false
  ///   - null
  ///   - negative number
  ///   - negative exp number
  /// SPECIAL: "]" char within quoted string
  ///
  var result4 = await jv
      .validate('{\"arrayMain\": [1, \"fal]se\", false, null, -5, -1.25e7]}');
  expect(result4, true);

  /// JSON 5 [expecct TRUE]
  ///
  /// - array
  ///   - object
  ///   - object
  ///  ... etc.
  ///
  var result5 = await jv.validate(
      '[{\"arrayMain\": [1, \"fal]se\", false, null, -5, -1.25e7]}, {\"test\": true}]');
  expect(result5, true);

  /// JSON 6 [expecct TRUE]
  ///
  /// format of JWKS with single key in the array
  ///
  var result6 = await jv.validate(
      '{\"keys\": [{\"kty\":\"RSA\",\"n\":\"_6iKyYXNaobNWiqDPGShr1qiYfElJfPUyIy3MKrKLBNAx9mC6I0YPhcpVLsm-BK5NePwe-gbhTrNMs8TTQG-CHx-mNXsgRlEwUvOtVOT-NyFKIlDW6zbfqCMX6sCTHkbGRsg51asxChZZUSMPvSuMFMuCKrQvJ8ez9RwMvqjL8MvY06La-izj95BGZmtGleOVHXosm9EWefjRFelXiiSf2aObR1bEn9Qt1GBUZ1znyDE0_8lhQUy-rmzjmolts-ZXE6Wp95MgprUC3IH1JmrSJtYjCtYutjDa-9XU3baPNrlsyb_43Lg49hWCHw1nIqEGRDwmCgVTnt81PzoNdj4jQ==\",\"e\":\"AQAB\",\"alg\":\"RS256\",\"use\":\"sig\",\"kid\":\"0bdab256-2eb0-11eb-8ca8-afffbde2b643\"}]}');
  expect(result6, true);

  /// JSON 7  [expecct FALSE]
  ///
  /// ERROR: Not quoted string value not in (true, false, null).
  ///
  var result7 = await jv.validate(
      '{\"arrayMain\": [1, \"fal]se\", something, null, -5, -1.25e7]}');
  expect(result7, false);

  /// JSON 8  [expect FALSE]
  ///
  /// ERROR: additional double qoute mark.
  ///
  var result8 = await jv
      .validate('{\"arrayMain\": [1, \"\"fal]se\", false, null, -5, -1.25e7]}');
  expect(result8, false);

  /// JSON 9 [expect TRUE]
  ///
  /// TEST: testing json strings for whitespaces (CRLF, LF, TAB, SPACE)
  ///
  var result9 = await jv.validate('''{
  "keys": [
    {
      "alg": "RS256",
      "e": "AQAB",
      "kty": "RSA",
      "kid": "dedc012d07f52aedfd5f97784e1bcbe23c19724d",
      "n": "sV158-MQ-5-sP2iTJibiMap1ug8tNY97laOud3Se_3jd4INq36NwhLpgU3FC5SCfJOs9wehTLzv_hBuo-sW0JNjAEtMEE-SDtx5486gjymDR-5Iwv7bgt25tD0cDgiboZLt1RLn-nP-V3zgYHZa_s9zLjpNyArsWWcSh6tWe2R8yW6BqS8l4_9z8jkKeyAwWmdpkY8BtKS0zZ9yljiCxKvs8CKjfHmrayg45sZ8V1-aRcjtR2ECxATHjE8L96_oNddZ-rj2axf2vTmnkx3OvIMgx0tZ0ycMG6Wy8wxxaR5ir2LV3Gkyfh72U7tI8Q1sokPmH6G62JcduNY66jEQlvQ",
      "use": "sig"
    },
    {
      "kty": "RSA",
      "e": "AQAB",
      "use": "sig",
      "alg": "RS256",
      "n": "syWuIlYmoWSl5rBQGOtYGwO5OCCZnhoWBCyl-x5gby5ofc4HNhBoVVMUggk-f_MH-pyMI5yRYsS_aPQ2bmSox2s4i9cPhxqtSAYMhTPwSwQ2BROC7xxi_N0ovp5Ivut5q8TwAn5kQZa_jR9d7JO20BUB7UqbMkBsqg2J8QTtMJ9YtA5BmUn4Y6vhIjTFtvrA6iM4i1cKoUD5Rirt5CYpcKwsLxBZbVk4E4rqgv7G0UlWt6NAs-z7XDkchlNBVpMUuiUBzxHl4LChc7dsWXRaO5vhu3j_2WnxuWCQZPlGoB51jD_ynZ027hhIcoa_tXg28_qb5Al78ZttiRCQDKueAQ",
      "kid": "2e3025f26b595f96eac907cc2b9471422bcaeb93"
    }
  ]
}''');
  expect(result9, true);
}
