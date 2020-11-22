import 'package:ivmjv/ivmjv.dart';

void main() {
  JsonValidator iv = JsonValidator("{\"amount\": 100.00}");
  print('valid?: ${iv.validate()}');
}
