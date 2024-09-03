import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        prefixIconColor: textSecondaryColor,
        floatingLabelStyle: const TextStyle(color: textSecondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(width: 2, color: textSecondaryColor),
        ));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        prefixIconColor: textPrimaryColor,
        floatingLabelStyle: const TextStyle(color: textPrimaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(width: 2, color: textPrimaryColor),
        ));
}