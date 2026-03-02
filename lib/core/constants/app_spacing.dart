import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Specific layout values from design doc
  static const double cardRadius = 20;
  static const double buttonRadius = 100; // pill
  static const double bottomSheetRadius = 28;
  static const double inputRadius = 14;
  static const double thumbnailRadius = 10;
  static const double chipRadius = 100; // pill
  static const double snackbarRadius = 14;

  static const double buttonHeight = 52;
  static const double chipHeight = 36;
  static const double fileCardHeight = 72;
  static const double dropZoneHeight = 120;
  static const double fabSize = 56;
  static const double bottomSheetHandle = 40;

  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 40;
  static const double iconXxl = 48;

  // Page padding
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
}
