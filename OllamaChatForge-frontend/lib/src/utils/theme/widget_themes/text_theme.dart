import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class TTextTheme{
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(fontSize: 28.0, fontWeight: FontWeight.bold, color: textDarkColor),
    bodyMedium: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.normal, color: textDarkColor),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(fontSize: 28.0, fontWeight: FontWeight.bold, color: textWhiteColor),
    bodyMedium: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.normal, color: textWhiteColor),
  );
}