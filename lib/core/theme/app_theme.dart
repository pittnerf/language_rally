// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

/// Language Rally Design System
/// Calm, modern, language-learning focused UI with Material 3
class AppTheme {
  // Border radius constants
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;

  // Spacing constants
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  /// Light Theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.onPrimaryContainerLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.onSecondaryLight,
      secondaryContainer: AppColors.secondaryContainerLight,
      onSecondaryContainer: AppColors.onSecondaryContainerLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: AppColors.onTertiaryLight,
      tertiaryContainer: AppColors.tertiaryContainerLight,
      onTertiaryContainer: AppColors.onTertiaryContainerLight,
      error: AppColors.errorLight,
      onError: AppColors.onErrorLight,
      errorContainer: AppColors.errorContainerLight,
      onErrorContainer: AppColors.onErrorContainerLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      outline: AppColors.outlineLight,
      outlineVariant: AppColors.outlineVariantLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      fontFamily: AppFonts.fontFamily,
      textTheme: AppFonts.getTextTheme(colorScheme.onSurface),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppFonts.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.all(spacing8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        selectedColor: colorScheme.secondaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing8,
        ),
        labelStyle: AppFonts.labelLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: AppFonts.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        side: BorderSide.none,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing8,
          vertical: spacing4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        labelStyle: AppFonts.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: AppFonts.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusExtraLarge),
        ),
        backgroundColor: AppColors.dialogBackgroundLight,
        titleTextStyle: AppFonts.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppFonts.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusExtraLarge),
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: spacing16,
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 80,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppFonts.labelMedium.copyWith(
              color: colorScheme.onSurface,
            );
          }
          return AppFonts.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppFonts.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.onPrimaryContainerDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.onSecondaryDark,
      secondaryContainer: AppColors.secondaryContainerDark,
      onSecondaryContainer: AppColors.onSecondaryContainerDark,
      tertiary: AppColors.tertiaryDark,
      onTertiary: AppColors.onTertiaryDark,
      tertiaryContainer: AppColors.tertiaryContainerDark,
      onTertiaryContainer: AppColors.onTertiaryContainerDark,
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
      errorContainer: AppColors.errorContainerDark,
      onErrorContainer: AppColors.onErrorContainerDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineVariantDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: AppFonts.fontFamily,
      textTheme: AppFonts.getTextTheme(colorScheme.onSurface),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppFonts.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.all(spacing8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        selectedColor: colorScheme.secondaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing8,
        ),
        labelStyle: AppFonts.labelLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: AppFonts.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        side: BorderSide.none,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing8,
          vertical: spacing4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        labelStyle: AppFonts.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: AppFonts.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusExtraLarge),
        ),
        backgroundColor: AppColors.dialogBackgroundDark,
        titleTextStyle: AppFonts.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppFonts.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusExtraLarge),
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: spacing16,
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 80,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppFonts.labelMedium.copyWith(
              color: colorScheme.onSurface,
            );
          }
          return AppFonts.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppFonts.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================================
  // ADDITIONAL THEMES
  // ============================================================================

  /// Ocean Blue Theme (Light)
  static ThemeData get oceanLightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primaryOceanLight,
        onPrimary: AppColors.onPrimaryOceanLight,
        primaryContainer: AppColors.primaryContainerOceanLight,
        onPrimaryContainer: AppColors.onPrimaryContainerOceanLight,
        secondary: AppColors.secondaryOceanLight,
        onSecondary: AppColors.onSecondaryOceanLight,
        secondaryContainer: AppColors.secondaryContainerOceanLight,
        onSecondaryContainer: AppColors.onSecondaryContainerOceanLight,
        tertiary: AppColors.tertiaryOceanLight,
        onTertiary: AppColors.onTertiaryOceanLight,
        tertiaryContainer: AppColors.tertiaryContainerOceanLight,
        onTertiaryContainer: AppColors.onTertiaryContainerOceanLight,
        surface: AppColors.surfaceOceanLight,
        onSurface: AppColors.onSurfaceOceanLight,
        surfaceVariant: AppColors.surfaceVariantOceanLight,
        onSurfaceVariant: AppColors.onSurfaceVariantOceanLight,
        background: AppColors.backgroundOceanLight,
        outline: AppColors.outlineOceanLight,
        outlineVariant: AppColors.outlineVariantOceanLight,
      );

  /// Ocean Blue Theme (Dark)
  static ThemeData get oceanDarkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryOceanDark,
        onPrimary: AppColors.onPrimaryOceanDark,
        primaryContainer: AppColors.primaryContainerOceanDark,
        onPrimaryContainer: AppColors.onPrimaryContainerOceanDark,
        secondary: AppColors.secondaryOceanDark,
        onSecondary: AppColors.onSecondaryOceanDark,
        secondaryContainer: AppColors.secondaryContainerOceanDark,
        onSecondaryContainer: AppColors.onSecondaryContainerOceanDark,
        tertiary: AppColors.tertiaryOceanDark,
        onTertiary: AppColors.onTertiaryOceanDark,
        tertiaryContainer: AppColors.tertiaryContainerOceanDark,
        onTertiaryContainer: AppColors.onTertiaryContainerOceanDark,
        surface: AppColors.surfaceOceanDark,
        onSurface: AppColors.onSurfaceOceanDark,
        surfaceVariant: AppColors.surfaceVariantOceanDark,
        onSurfaceVariant: AppColors.onSurfaceVariantOceanDark,
        background: AppColors.backgroundOceanDark,
        outline: AppColors.outlineOceanDark,
        outlineVariant: AppColors.outlineVariantOceanDark,
      );

  /// Forest Green Theme (Light)
  static ThemeData get forestLightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primaryForestLight,
        onPrimary: AppColors.onPrimaryForestLight,
        primaryContainer: AppColors.primaryContainerForestLight,
        onPrimaryContainer: AppColors.onPrimaryContainerForestLight,
        secondary: AppColors.secondaryForestLight,
        onSecondary: AppColors.onSecondaryForestLight,
        secondaryContainer: AppColors.secondaryContainerForestLight,
        onSecondaryContainer: AppColors.onSecondaryContainerForestLight,
        tertiary: AppColors.tertiaryForestLight,
        onTertiary: AppColors.onTertiaryForestLight,
        tertiaryContainer: AppColors.tertiaryContainerForestLight,
        onTertiaryContainer: AppColors.onTertiaryContainerForestLight,
        surface: AppColors.surfaceForestLight,
        onSurface: AppColors.onSurfaceForestLight,
        surfaceVariant: AppColors.surfaceVariantForestLight,
        onSurfaceVariant: AppColors.onSurfaceVariantForestLight,
        background: AppColors.backgroundForestLight,
        outline: AppColors.outlineForestLight,
        outlineVariant: AppColors.outlineVariantForestLight,
      );

  /// Forest Green Theme (Dark)
  static ThemeData get forestDarkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryForestDark,
        onPrimary: AppColors.onPrimaryForestDark,
        primaryContainer: AppColors.primaryContainerForestDark,
        onPrimaryContainer: AppColors.onPrimaryContainerForestDark,
        secondary: AppColors.secondaryForestDark,
        onSecondary: AppColors.onSecondaryForestDark,
        secondaryContainer: AppColors.secondaryContainerForestDark,
        onSecondaryContainer: AppColors.onSecondaryContainerForestDark,
        tertiary: AppColors.tertiaryForestDark,
        onTertiary: AppColors.onTertiaryForestDark,
        tertiaryContainer: AppColors.tertiaryContainerForestDark,
        onTertiaryContainer: AppColors.onTertiaryContainerForestDark,
        surface: AppColors.surfaceForestDark,
        onSurface: AppColors.onSurfaceForestDark,
        surfaceVariant: AppColors.surfaceVariantForestDark,
        onSurfaceVariant: AppColors.onSurfaceVariantForestDark,
        background: AppColors.backgroundForestDark,
        outline: AppColors.outlineForestDark,
        outlineVariant: AppColors.outlineVariantForestDark,
      );

  /// Sunset Orange Theme (Light)
  static ThemeData get sunsetLightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primarySunsetLight,
        onPrimary: AppColors.onPrimarySunsetLight,
        primaryContainer: AppColors.primaryContainerSunsetLight,
        onPrimaryContainer: AppColors.onPrimaryContainerSunsetLight,
        secondary: AppColors.secondarySunsetLight,
        onSecondary: AppColors.onSecondarySunsetLight,
        secondaryContainer: AppColors.secondaryContainerSunsetLight,
        onSecondaryContainer: AppColors.onSecondaryContainerSunsetLight,
        tertiary: AppColors.tertiarySunsetLight,
        onTertiary: AppColors.onTertiarySunsetLight,
        tertiaryContainer: AppColors.tertiaryContainerSunsetLight,
        onTertiaryContainer: AppColors.onTertiaryContainerSunsetLight,
        surface: AppColors.surfaceSunsetLight,
        onSurface: AppColors.onSurfaceSunsetLight,
        surfaceVariant: AppColors.surfaceVariantSunsetLight,
        onSurfaceVariant: AppColors.onSurfaceVariantSunsetLight,
        background: AppColors.backgroundSunsetLight,
        outline: AppColors.outlineSunsetLight,
        outlineVariant: AppColors.outlineVariantSunsetLight,
      );

  /// Sunset Orange Theme (Dark)
  static ThemeData get sunsetDarkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primarySunsetDark,
        onPrimary: AppColors.onPrimarySunsetDark,
        primaryContainer: AppColors.primaryContainerSunsetDark,
        onPrimaryContainer: AppColors.onPrimaryContainerSunsetDark,
        secondary: AppColors.secondarySunsetDark,
        onSecondary: AppColors.onSecondaryDunsetDark,
        secondaryContainer: AppColors.secondaryContainerSunsetDark,
        onSecondaryContainer: AppColors.onSecondaryContainerSunsetDark,
        tertiary: AppColors.tertiarySunsetDark,
        onTertiary: AppColors.onTertiarySunsetDark,
        tertiaryContainer: AppColors.tertiaryContainerSunsetDark,
        onTertiaryContainer: AppColors.onTertiaryContainerSunsetDark,
        surface: AppColors.surfaceSunsetDark,
        onSurface: AppColors.onSurfaceSunsetDark,
        surfaceVariant: AppColors.surfaceVariantSunsetDark,
        onSurfaceVariant: AppColors.onSurfaceVariantSunsetDark,
        background: AppColors.backgroundSunsetDark,
        outline: AppColors.outlineSunsetDark,
        outlineVariant: AppColors.outlineVariantSunsetDark,
      );

  /// Purple Dreams Theme (Light)
  static ThemeData get purpleLightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primaryPurpleLight,
        onPrimary: AppColors.onPrimaryPurpleLight,
        primaryContainer: AppColors.primaryContainerPurpleLight,
        onPrimaryContainer: AppColors.onPrimaryContainerPurpleLight,
        secondary: AppColors.secondaryPurpleLight,
        onSecondary: AppColors.onSecondaryPurpleLight,
        secondaryContainer: AppColors.secondaryContainerPurpleLight,
        onSecondaryContainer: AppColors.onSecondaryContainerPurpleLight,
        tertiary: AppColors.tertiaryPurpleLight,
        onTertiary: AppColors.onTertiaryPurpleLight,
        tertiaryContainer: AppColors.tertiaryContainerPurpleLight,
        onTertiaryContainer: AppColors.onTertiaryContainerPurpleLight,
        surface: AppColors.surfacePurpleLight,
        onSurface: AppColors.onSurfacePurpleLight,
        surfaceVariant: AppColors.surfaceVariantPurpleLight,
        onSurfaceVariant: AppColors.onSurfaceVariantPurpleLight,
        background: AppColors.backgroundPurpleLight,
        outline: AppColors.outlinePurpleLight,
        outlineVariant: AppColors.outlineVariantPurpleLight,
      );

  /// Purple Dreams Theme (Dark)
  static ThemeData get purpleDarkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryPurpleDark,
        onPrimary: AppColors.onPrimaryPurpleDark,
        primaryContainer: AppColors.primaryContainerPurpleDark,
        onPrimaryContainer: AppColors.onPrimaryContainerPurpleDark,
        secondary: AppColors.secondaryPurpleDark,
        onSecondary: AppColors.onSecondaryPurpleDark,
        secondaryContainer: AppColors.secondaryContainerPurpleDark,
        onSecondaryContainer: AppColors.onSecondaryContainerPurpleDark,
        tertiary: AppColors.tertiaryPurpleDark,
        onTertiary: AppColors.onTertiaryPurpleDark,
        tertiaryContainer: AppColors.tertiaryContainerPurpleDark,
        onTertiaryContainer: AppColors.onTertiaryContainerPurpleDark,
        surface: AppColors.surfacePurpleDark,
        onSurface: AppColors.onSurfacePurpleDark,
        surfaceVariant: AppColors.surfaceVariantPurpleDark,
        onSurfaceVariant: AppColors.onSurfaceVariantPurpleDark,
        background: AppColors.backgroundPurpleDark,
        outline: AppColors.outlinePurpleDark,
        outlineVariant: AppColors.outlineVariantPurpleDark,
      );

  // ============================================================================
  // THEME BUILDER HELPER
  // ============================================================================

  /// Build a theme from color parameters
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color primaryContainer,
    required Color onPrimaryContainer,
    required Color secondary,
    required Color onSecondary,
    required Color secondaryContainer,
    required Color onSecondaryContainer,
    required Color tertiary,
    required Color onTertiary,
    required Color tertiaryContainer,
    required Color onTertiaryContainer,
    required Color surface,
    required Color onSurface,
    required Color surfaceVariant,
    required Color onSurfaceVariant,
    required Color background,
    required Color outline,
    required Color outlineVariant,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: brightness == Brightness.light ? AppColors.errorLight : AppColors.errorDark,
      onError: brightness == Brightness.light ? AppColors.onErrorLight : AppColors.onErrorDark,
      errorContainer: brightness == Brightness.light ? AppColors.errorContainerLight : AppColors.errorContainerDark,
      onErrorContainer: brightness == Brightness.light ? AppColors.onErrorContainerLight : AppColors.onErrorContainerDark,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: AppFonts.fontFamily,
      textTheme: AppFonts.getTextTheme(colorScheme.onSurface),
      // ...existing code... (all the theme components use colorScheme)
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppFonts.titleLarge.copyWith(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.all(spacing8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppFonts.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: AppFonts.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: spacing16, vertical: spacing12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
          foregroundColor: colorScheme.primary,
          textStyle: AppFonts.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: spacing8, vertical: spacing4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMedium), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        selectedColor: colorScheme.secondaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: spacing12, vertical: spacing8),
        labelStyle: AppFonts.labelLarge.copyWith(color: colorScheme.onSurfaceVariant),
        secondaryLabelStyle: AppFonts.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        side: BorderSide.none,
      ),
      dialogTheme: DialogThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusExtraLarge)),
        backgroundColor: surface,
        titleTextStyle: AppFonts.headlineSmall.copyWith(color: colorScheme.onSurface),
        contentTextStyle: AppFonts.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppFonts.bodyMedium.copyWith(color: colorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
