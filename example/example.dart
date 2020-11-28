import 'package:ivmjv/ivmjv.dart';

void main() async {
  final iv = JsonValidator('{\"amount\": 100.00}');
  print('valid?: ${await iv.validate()}');
}
