import 'package:com.example.app/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:com.example.app/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:com.example.app/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:com.example.app/src/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme{

  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: TTextTheme.lightTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevateButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );


  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: TTextTheme.darkTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevateButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}