// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Design system colors for Language Rally
/// Calm, modern palette focused on language learning
class AppColors {
  // Light Theme - Primary (Soft Teal/Blue-green)
  static const Color primaryLight = Color(0xFF4A9B8E);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFB8E6DD);
  static const Color onPrimaryContainerLight = Color(0xFF002019);

  // Light Theme - Secondary (Warm Coral)
  static const Color secondaryLight = Color(0xFFE27D60);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFFFDAD5);
  static const Color onSecondaryContainerLight = Color(0xFF3A1000);

  // Light Theme - Tertiary (Soft Purple for accents)
  static const Color tertiaryLight = Color(0xFF8B7AB8);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFE9DDFF);
  static const Color onTertiaryContainerLight = Color(0xFF2A1742);

  // Light Theme - Error
  static const Color errorLight = Color(0xFFD84654);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);

  // Light Theme - Background & Surface
  static const Color backgroundLight = Color(0xFFF8FAF9);
  static const Color onBackgroundLight = Color(0xFF191C1B);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF191C1B);
  static const Color surfaceVariantLight = Color(0xFFDFE4E2);
  static const Color onSurfaceVariantLight = Color(0xFF42494A);

  // Light Theme - Outline
  static const Color outlineLight = Color(0xFF72797A);
  static const Color outlineVariantLight = Color(0xFFC2C8C6);

  // Dark Theme - Primary
  static const Color primaryDark = Color(0xFF9DD4C8);
  static const Color onPrimaryDark = Color(0xFF00382E);
  static const Color primaryContainerDark = Color(0xFF005046);
  static const Color onPrimaryContainerDark = Color(0xFFB8E6DD);

  // Dark Theme - Secondary
  static const Color secondaryDark = Color(0xFFFFB4A1);
  static const Color onSecondaryDark = Color(0xFF5F1600);
  static const Color secondaryContainerDark = Color(0xFF8A3526);
  static const Color onSecondaryContainerDark = Color(0xFFFFDAD5);

  // Dark Theme - Tertiary
  static const Color tertiaryDark = Color(0xFFD0BCFF);
  static const Color onTertiaryDark = Color(0xFF402D5A);
  static const Color tertiaryContainerDark = Color(0xFF584371);
  static const Color onTertiaryContainerDark = Color(0xFFE9DDFF);

  // Dark Theme - Error
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  // Dark Theme - Background & Surface
  static const Color backgroundDark = Color(0xFF191C1B);
  static const Color onBackgroundDark = Color(0xFFE0E3E1);
  static const Color surfaceDark = Color(0xFF1F2221);
  static const Color onSurfaceDark = Color(0xFFE0E3E1);
  static const Color surfaceVariantDark = Color(0xFF42494A);
  static const Color onSurfaceVariantDark = Color(0xFFC2C8C6);

  // Dark Theme - Outline
  static const Color outlineDark = Color(0xFF8C9390);
  static const Color outlineVariantDark = Color(0xFF42494A);

  // Semantic Colors (Common across themes)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Learning-specific colors
  static const Color knownItem = Color(0xFF66BB6A);
  static const Color unknownItem = Color(0xFFEF5350);
  static const Color learningItem = Color(0xFFFFCA28);
}
