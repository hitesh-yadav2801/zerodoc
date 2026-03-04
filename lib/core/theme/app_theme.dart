import 'package:flutter/material.dart';
import 'package:zerodoc/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    paperBg: AppColors.paperBg,
    paperCard: AppColors.paperCard,
    paperWhite: AppColors.paperWhite,
    ink: AppColors.ink,
    inkMuted: AppColors.inkMuted,
    slate: AppColors.slate,
    slateLight: AppColors.slateLight,
    sage: AppColors.sage,
    terracotta: AppColors.terracotta,
    terracottaBg: AppColors.terracottaBg,
    divider: AppColors.divider,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    paperBg: AppColors.darkPaperBg,
    paperCard: AppColors.darkPaperCard,
    paperWhite: AppColors.darkPaperWhite,
    ink: AppColors.darkInk,
    inkMuted: AppColors.darkInkMuted,
    slate: AppColors.darkSlate,
    slateLight: AppColors.darkSlateLight,
    sage: AppColors.darkSage,
    terracotta: AppColors.darkTerracotta,
    terracottaBg: AppColors.darkTerracottaBg,
    divider: AppColors.darkDivider,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color paperBg,
    required Color paperCard,
    required Color paperWhite,
    required Color ink,
    required Color inkMuted,
    required Color slate,
    required Color slateLight,
    required Color sage,
    required Color terracotta,
    required Color terracottaBg,
    required Color divider,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: slate,
      onPrimary: Colors.white,
      primaryContainer: slateLight,
      onPrimaryContainer: slate,
      secondary: sage,
      onSecondary: Colors.white,
      secondaryContainer: sage.withValues(alpha: 0.15),
      onSecondaryContainer: sage,
      error: terracotta,
      onError: Colors.white,
      errorContainer: terracottaBg,
      onErrorContainer: terracotta,
      surface: paperCard,
      onSurface: ink,
      onSurfaceVariant: inkMuted,
      outline: divider,
      outlineVariant: divider,
      shadow: brightness == Brightness.light
          ? AppColors.shadowMd
          : AppColors.darkShadowMd,
      surfaceContainerHighest: paperWhite,
      surfaceContainerLow: paperBg,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paperBg,
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        fontFamily: 'DM Sans',
        bodyColor: ink,
        displayColor: ink,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: paperCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: slate,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: slate,
          shape: const StadiumBorder(),
          side: BorderSide(color: slate, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: slate,
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: slate,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: paperCard,
        selectedItemColor: slate,
        unselectedItemColor: inkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: paperCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paperWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: slate, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return inkMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return sage;
          return divider;
        }),
      ),
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 0.5,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paperBg,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
    );
  }
}
