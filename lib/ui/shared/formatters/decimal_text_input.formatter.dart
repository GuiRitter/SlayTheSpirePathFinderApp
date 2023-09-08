import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  static RegExp decimalTextInputRegex = RegExp(
    r'^[+-]{0,1}[0-9]*[.,]{0,1}[0-9]*$',
  );

  final FloorEnum floorEnum;

  DecimalTextInputFormatter({
    required this.floorEnum,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (decimalTextInputRegex.hasMatch(
      newValue.text,
    )) {
      SharedPreferences.getInstance().then(
        (
          prefs,
        ) =>
            prefs.setDouble(
          floorEnum.name,
          double.parse(
            newValue.text,
          ),
        ),
      );

      return newValue;
    }
    return oldValue;
  }
}
