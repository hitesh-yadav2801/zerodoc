import 'package:flutter/material.dart';

abstract final class AppColors {
  // Ink (text)
  static const ink = Color(0xFF3A3A3A);
  static const inkMuted = Color(0xFF8C8A84);

  // Paper (backgrounds)
  static const paperBg = Color(0xFFF2F0E9);
  static const paperCard = Color(0xFFFCFBF8);
  static const paperWhite = Color(0xFFFFFFFF);

  // Primary action
  static const slate = Color(0xFF4F6D7A);
  static const slateLight = Color(0xFFE8EFF1);

  // Success
  static const sage = Color(0xFF9CB3AF);
  static const sageTint = Color(0x269CB3AF); // 15% opacity

  // Destructive
  static const terracotta = Color(0xFFD48C70);
  static const terracottaBg = Color(0xFFFAF0EB);

  // Tool card background (slightly warmer than paper-card)
  static const toolCardBg = Color(0xFFF5F4F0);

  // Shadows
  static const shadowSm = Color(0x0F35312A); // 6%
  static const shadowMd = Color(0x1F35312A); // 12%
  static const shadowLg = Color(0x3335312A); // 20%

  // Divider
  static const divider = Color(0x1A35312A); // 10%

  // Dark mode equivalents
  static const darkPaperBg = Color(0xFF1A1A1A);
  static const darkPaperCard = Color(0xFF242424);
  static const darkPaperWhite = Color(0xFF2E2E2E);
  static const darkInk = Color(0xFFE8E6E1);
  static const darkInkMuted = Color(0xFF9E9C96);
  static const darkSlate = Color(0xFF7FA3B2);
  static const darkSlateLight = Color(0xFF2A3A42);
  static const darkSage = Color(0xFFB0C8C4);
  static const darkTerracotta = Color(0xFFE0A48A);
  static const darkTerracottaBg = Color(0xFF2E2220);
  static const darkSageTint = Color(0x26B0C8C4);
  static const darkToolCardBg = Color(0xFF2A2A28);
  static const darkShadowSm = Color(0x1A000000);
  static const darkShadowMd = Color(0x33000000);
  static const darkShadowLg = Color(0x4D000000);
  static const darkDivider = Color(0x1AFFFFFF);
}
