import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: textWhiteColor,
      side: BorderSide(color: textWhiteColor),
      padding: EdgeInsets.symmetric(vertical: textButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: textWhiteColor,
      side: BorderSide(color: textWhiteColor),
      padding: EdgeInsets.symmetric(vertical: textButtonHeight),
    ),
  );
}