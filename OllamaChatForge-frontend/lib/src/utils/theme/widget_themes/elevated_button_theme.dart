import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevateButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: textSecondaryColor,
      backgroundColor: textWhiteColor,
      side: BorderSide(color: textSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: textButtonHeight),
    ),
  );

  static final darkElevateButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: textWhiteColor,
      backgroundColor: textPrimaryColor,
      side: BorderSide(color: textSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: textButtonHeight),
    ),
  );
}