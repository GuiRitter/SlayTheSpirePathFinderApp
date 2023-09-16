import 'package:flutter/material.dart';

class Settings {
  // /// 2^31 - 1 on the web, 2^63 - 1 otherwise
  // static const intMaxSafe = -1 >>> 1;

  /// 2^53 - 1
  static const intMax53 = 0x1fffffffffffff;

  static RegExp floorRegex = RegExp(
    r'((?<exitingNeow>N)|((?<exitingFloor>[UMTREL]{1})(?<exitingNumber>[0-9]+)))-((?<enteringBoss>B)|((?<enteringFloor>[UMTREL]{1})(?<enteringNumber>[0-9]+)))\s+',
  );

  static RegExp mapRegex = RegExp(
    r'^(((N|([UMTREL]{1}[0-9]+))-(B|([UMTREL]{1}[0-9]+)))\s+)+$',
  );

  static final GlobalKey<ScaffoldMessengerState> snackState =
      GlobalKey<ScaffoldMessengerState>();

  static const floorWidgetFontSize = 40.0;

  static const double materialBaselineGridSize = 8;

  static const materialBaselineGridSizeHalf = materialBaselineGridSize / 2;
}
