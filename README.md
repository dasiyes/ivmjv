# ivmJV 

**ivmJV** is a tool to validate string as JSON object.
The tool will respect [RFC8259], but I have not thoroughly tested it to complain in full with the standard.

# Install
```yaml
  dependencies:
    ivmjv: any
```
Run `pub get`

# Example

To test a string if it can be a valid JSON object, import the library,
create an instance of `JsonValidator` class and pass the string to be tested as initial parameter.

```dart
void main() {
  JsonValidator iv = JsonValidator("{\"amount\": 100.00}");
  print('valid?: ${iv.validate()}');
}
```
