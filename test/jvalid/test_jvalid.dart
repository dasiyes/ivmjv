import 'package:ivmjv/ivmjv.dart';
import 'package:test/test.dart';

/// Test jvalid.dart initiation
///
/// Test class instantiation and validate() function initiation.
void testJValidInit() {
  /// Test validate function initiation with empty parameter.
  JsonValidator jv1 = JsonValidator("");
  bool jv_result1 = jv1.validate();
  expect(jv_result1, false);

  /// Test validate function initiation with empty ({}) json string).
  JsonValidator jv2 = JsonValidator("{}");
  bool jv_result2 = jv2.validate();
  expect(jv_result2, true);

  /// Test validate function initiation with simple json value param provided at class instantiation.
  JsonValidator jv3 = JsonValidator("{\"name\": \"test\", \"value\": 1}");
  bool jv_result3 = jv3.validate();
  expect(jv_result3, true);

  /// Test validate function initiation with simple json value param provided as direct validate() param.
  JsonValidator jv4 = JsonValidator("");
  bool jv_result4 = jv4.validate("{\"name\": \"test\", \"value\": 1}");
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
void testValidateFunctionMain() {
  /// Test the validation of the name(key) & value
  /// 1) valid name/key & value
  JsonValidator jv = JsonValidator("");
  bool result1 = jv.validate("{\"name\": \"test\", \"value\": 1}");
  expect(result1, true);

  /// invalid key/name missing leading qm
  bool result2 = jv.validate("{name\": \"test\"}");
  expect(result2, false);

  /// invalid string value missing trailing qm
  bool result6 = jv.validate("{\"name\": \"test}");
  expect(result6, false);

  /// invalid string value missing leading qm
  bool result3 = jv.validate("{\"name\": test\"}");
  expect(result3, false);

  /// 2) validating the 3 lietral vlaue: false, true and null

  /// valid 'false' value
  bool result4 = jv.validate("{\"name\": false}");
  expect(result4, true);

  /// invalid 'false' value
  bool result5 = jv.validate("{\"name\": false\"}");
  expect(result5, false);

  /// valid 'true' value
  bool result7 = jv.validate("{\"name\": true}");
  expect(result7, true);

  /// invalid 'true' value
  bool result8 = jv.validate("{\"name\": true\"}");
  expect(result8, false);

  /// valid 'null' value
  bool result9 = jv.validate("{\"name\": null}");
  expect(result9, true);

  /// invalid 'null' value
  bool result10 = jv.validate("{\"name\": null\"}");
  expect(result10, false);

  /// 3) validating NUMBER values

  /// valid + 'number' value
  bool result11 = jv.validate("{\"positive\": 230}");
  expect(result11, true);

  /// valid - 'number' value
  bool result12 = jv.validate("{\"name\": -230}");
  expect(result12, true);

  /// valid exp 'numbr' value
  bool result13 = jv.validate("{\"name\": 1.5e-3}");
  expect(result13, true);

  /// invalid positive 'numbr' value
  bool result14 = jv.validate("{\"name\": +1.5}");
  expect(result14, false);

  /// 4) validation of empty structural objects '[]' and '{}'

  /// valid 'empty object - {}' value
  bool result15 = jv.validate("{\"empty_object\": {}}");
  expect(result15, true);

  /// valid 'empty array - []' value
  bool result16 = jv.validate("{\"empty_array\": []}");
  expect(result16, true);

  /// invalid 1 'array - [' value
  bool result17 = jv.validate("{\"empty_array\": [}");
  expect(result17, false);

  /// invalid 2 'array - [}' value
  bool result18 = jv.validate("{\"empty_array\": [}}");
  expect(result18, false);

  /// invalid 1 'object - {[space]' value
  bool result19 = jv.validate("{\"empty_array\": { }");
  expect(result19, false);

  /// invalid 2 'object - {' value [object.length == 1]
  bool result20 = jv.validate("{\"empty_array\": {}");
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
void test_validateNameValuePair() {
  /// value - empty string
  JsonValidator jv = JsonValidator("");
  bool result1 = jv.validate(" ");
  expect(result1, false);

  /// value length = 6 chars {"":n}
  bool result2 = jv.validate("{\"\":1}");
  expect(result2, true);

  /// value length < 6 chars {":n}
  bool result3 = jv.validate("{\":1}");
  expect(result3, false);

  /// value == invalid => false
  bool result4 = jv.validate("{\"test\":invalid}");
  expect(result4, false);

  /// value == "invalid" => true
  bool result5 = jv.validate("{\"test\":\"invalid\"}");
  expect(result5, true);
}

/// Test JSON formats
///
/// Some example use cases that include edge cases too
/// TODO: Extend the examples with more cases
///
void testJsonObjects() {
  JsonValidator jv = JsonValidator("");

  /// JSON 1
  /// - key/name : string
  /// - key/name : array
  ///   - object
  ///     - key/name : string
  ///     - key/name : string
  ///   - object
  ///     - key/name : array
  ///     - key/name : number
  ///
  bool result1 = jv.validate(
      "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}]}");
  expect(result1, true);

  /// JSON 2
  /// JSON 1 +
  /// - key/name : number
  bool result2 = jv.validate(
      "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}], \"kvo\": 34}");
  expect(result2, true);

  /// JSON 3
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
  bool result3 = jv.validate(
      "{\"arrayMain\": [1, \"fal{se\", true, null, -5], \"kvo\": 34.4, \"expon\": 1.05e-3}");
  expect(result3, true);

  /// JSON 4
  ///
  /// - key/name : array
  ///   - number
  ///   - string
  ///   - bool - false
  ///   - null
  ///   - negative number
  ///   - negative exp number
  ///
  bool result4 =
      jv.validate("{\"arrayMain\": [1, \"fal]se\", false, null, -5, -1.25e7]}");
  expect(result4, true);

  /// JSON 5
  ///
  /// - array
  ///   - object
  ///   - object
  ///  ... etc.
  ///
  bool result5 = jv.validate(
      "[{\"arrayMain\": [1, \"fal]se\", false, null, -5, -1.25e7]}, {\"test\": true}]");
  expect(result5, true);
}
