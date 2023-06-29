import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  static RegExp decimalTextInputRegex = RegExp(
    r'^[+-]{0,1}[0-9]*[.,]{0,1}[0-9]*$',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (decimalTextInputRegex.hasMatch(
      newValue.text,
    )) {
      return newValue;
    }
    return oldValue;
  }
}
