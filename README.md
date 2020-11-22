# ivmJV 

**ivmJV** is a tool to validte string as JSON object.
The tool will respect [RFC8259] but it is not fully tested to complain in full with the standard.

# Install
```yaml
  dependencies:
    ivmJV: any
```
Run `pub get`

# Example

To test a string if it can be a valid JSON object, import the library,
create an instance of `JsonValidatr` class and pass the string as initial parameter.

```dart
void main() {
  JsonValidator iv = JsonValidator("{\"amount\": 100.00}");
  print('valid?: ${iv.validate()}');
}
```
