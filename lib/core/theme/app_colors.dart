import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Light palette ──

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
  static const sageTint = Color(0x269CB3AF); // 15%

  // Destructive
  static const terracotta = Color(0xFFD48C70);
  static const terracottaBg = Color(0xFFFAF0EB);

  // Tool card background
  static const toolCardBg = Color(0xFFF5F4F0);

  // Shadows
  static const shadowSm = Color(0x0F35312A); // 6%
  static const shadowMd = Color(0x1F35312A); // 12%
  static const shadowLg = Color(0x3335312A); // 20%

  // Divider
  static const divider = Color(0x1A35312A); // 10%

  // ── Dark palette (warm charcoal — preserves Paper & Ink identity) ──

  static const darkInk = Color(0xFFEDE9E0);
  static const darkInkMuted = Color(0xFFA09C93);

  static const darkPaperBg = Color(0xFF1C1B19);
  static const darkPaperCard = Color(0xFF2A2926);
  static const darkPaperWhite = Color(0xFF353330);

  static const darkSlate = Color(0xFF8AB4C7);
  static const darkSlateLight = Color(0xFF2C3A40);

  static const darkSage = Color(0xFFB8D0CC);
  static const darkSageTint = Color(0x26B8D0CC); // 15%

  static const darkTerracotta = Color(0xFFE8A68C);
  static const darkTerracottaBg = Color(0xFF352420);

  static const darkToolCardBg = Color(0xFF302E2B);

  static const darkShadowSm = Color(0x1A000000);
  static const darkShadowMd = Color(0x33000000);
  static const darkShadowLg = Color(0x4D000000);

  static const darkDivider = Color(0x1FFFFFFF); // 12%

  // ── Context-aware resolver ──

  static AppColorsResolved of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _dark
        : _light;
  }

  static const _light = AppColorsResolved(
    ink: ink,
    inkMuted: inkMuted,
    paperBg: paperBg,
    paperCard: paperCard,
    paperWhite: paperWhite,
    slate: slate,
    slateLight: slateLight,
    sage: sage,
    sageTint: sageTint,
    terracotta: terracotta,
    terracottaBg: terracottaBg,
    toolCardBg: toolCardBg,
    shadowSm: shadowSm,
    shadowMd: shadowMd,
    shadowLg: shadowLg,
    divider: divider,
  );

  static const _dark = AppColorsResolved(
    ink: darkInk,
    inkMuted: darkInkMuted,
    paperBg: darkPaperBg,
    paperCard: darkPaperCard,
    paperWhite: darkPaperWhite,
    slate: darkSlate,
    slateLight: darkSlateLight,
    sage: darkSage,
    sageTint: darkSageTint,
    terracotta: darkTerracotta,
    terracottaBg: darkTerracottaBg,
    toolCardBg: darkToolCardBg,
    shadowSm: darkShadowSm,
    shadowMd: darkShadowMd,
    shadowLg: darkShadowLg,
    divider: darkDivider,
  );
}

@immutable
class AppColorsResolved {
  const AppColorsResolved({
    required this.ink,
    required this.inkMuted,
    required this.paperBg,
    required this.paperCard,
    required this.paperWhite,
    required this.slate,
    required this.slateLight,
    required this.sage,
    required this.sageTint,
    required this.terracotta,
    required this.terracottaBg,
    required this.toolCardBg,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
    required this.divider,
  });

  final Color ink;
  final Color inkMuted;
  final Color paperBg;
  final Color paperCard;
  final Color paperWhite;
  final Color slate;
  final Color slateLight;
  final Color sage;
  final Color sageTint;
  final Color terracotta;
  final Color terracottaBg;
  final Color toolCardBg;
  final Color shadowSm;
  final Color shadowMd;
  final Color shadowLg;
  final Color divider;
}
