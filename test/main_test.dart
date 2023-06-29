// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/shared/formatters/decimal_text_input.formatter.dart';

void main() {
  test(
    'regex',
    () async {
      expect(
        DecimalTextInputFormatter.decimalTextInputRegex.hasMatch(
          "-123.456",
        ),
        true,
      );
    },
  );
}
