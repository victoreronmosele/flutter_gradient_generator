import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextTheme getTextTheme(BuildContext context) =>
      GoogleFonts.nunitoTextTheme(
        Theme.of(context).textTheme,
      );

  static String? getFontFamily(BuildContext context) =>
      GoogleFonts.nunito().fontFamily;
}
