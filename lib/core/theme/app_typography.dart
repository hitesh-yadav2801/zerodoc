import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextStyle _fraunces({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w600,
    double height = 1.2,
    Color? color,
  }) {
    return GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  static TextStyle _dmSans({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.5,
    Color? color,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  // Fraunces — titles only
  static TextStyle pageTitle({Color? color}) =>
      _fraunces(fontSize: 28, color: color);

  static TextStyle sectionHeader({Color? color}) =>
      _fraunces(fontSize: 20, color: color);

  static TextStyle resultTitle({Color? color}) =>
      _fraunces(fontSize: 24, color: color);

  // DM Sans — everything else
  static TextStyle body({Color? color}) =>
      _dmSans(fontSize: 16, color: color);

  static TextStyle bodyMedium({Color? color}) =>
      _dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: color);

  static TextStyle label({Color? color}) =>
      _dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: color);

  static TextStyle button({Color? color}) =>
      _dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: color);

  static TextStyle caption({Color? color}) =>
      _dmSans(fontSize: 12, color: color);

  static TextStyle chip({Color? color}) =>
      _dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: color);

  static TextStyle navLabel({Color? color}) =>
      _dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: color);

  static TextStyle pageBadge({Color? color}) =>
      _dmSans(fontSize: 11, color: color);
}
