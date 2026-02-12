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

  // Light Theme - Tertiary (Soft Mauve/Rose for accents)
  static const Color tertiaryLight = Color(0xFFC5A0B5);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFF0E0EB);
  static const Color onTertiaryContainerLight = Color(0xFF2F1726);

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
  static const Color dialogBackgroundLight = Color(0xFFF0F4F3); // Slightly tinted dialog background

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

  // Dark Theme - Tertiary (Soft Mauve/Rose)
  static const Color tertiaryDark = Color(0xFFE5C4D8);
  static const Color onTertiaryDark = Color(0xFF4A2D3D);
  static const Color tertiaryContainerDark = Color(0xFF634455);
  static const Color onTertiaryContainerDark = Color(0xFFF0E0EB);

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
  static const Color dialogBackgroundDark = Color(0xFF2A2E2D); // Slightly lighter dialog background for dark theme

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

  // ============================================================================
  // THEME 2: OCEAN BLUE (Professional, calm, focused)
  // ============================================================================

  // Ocean Blue Light Theme
  static const Color primaryOceanLight = Color(0xFF1976D2);
  static const Color onPrimaryOceanLight = Color(0xFFFFFFFF);
  static const Color primaryContainerOceanLight = Color(0xFFBBDEFB);
  static const Color onPrimaryContainerOceanLight = Color(0xFF001B3D);

  static const Color secondaryOceanLight = Color(0xFF0288D1);
  static const Color onSecondaryOceanLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerOceanLight = Color(0xFFB3E5FC);
  static const Color onSecondaryContainerOceanLight = Color(0xFF001E30);

  static const Color tertiaryOceanLight = Color(0xFF0097A7);
  static const Color onTertiaryOceanLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerOceanLight = Color(0xFFB2EBF2);
  static const Color onTertiaryContainerOceanLight = Color(0xFF002022);

  static const Color backgroundOceanLight = Color(0xFFF5F9FC);
  static const Color surfaceOceanLight = Color(0xFFFFFFFF);
  static const Color onSurfaceOceanLight = Color(0xFF1A1C1E);
  static const Color surfaceVariantOceanLight = Color(0xFFDDE3EA);
  static const Color onSurfaceVariantOceanLight = Color(0xFF41484D);
  static const Color outlineOceanLight = Color(0xFF71787E);
  static const Color outlineVariantOceanLight = Color(0xFFC1C7CE);

  // Ocean Blue Dark Theme
  static const Color primaryOceanDark = Color(0xFF90CAF9);
  static const Color onPrimaryOceanDark = Color(0xFF003258);
  static const Color primaryContainerOceanDark = Color(0xFF004A77);
  static const Color onPrimaryContainerOceanDark = Color(0xFFBBDEFB);

  static const Color secondaryOceanDark = Color(0xFF81D4FA);
  static const Color onSecondaryOceanDark = Color(0xFF00344F);
  static const Color secondaryContainerOceanDark = Color(0xFF004D6F);
  static const Color onSecondaryContainerOceanDark = Color(0xFFB3E5FC);

  static const Color tertiaryOceanDark = Color(0xFF80DEEA);
  static const Color onTertiaryOceanDark = Color(0xFF003639);
  static const Color tertiaryContainerOceanDark = Color(0xFF004F54);
  static const Color onTertiaryContainerOceanDark = Color(0xFFB2EBF2);

  static const Color backgroundOceanDark = Color(0xFF1A1C1E);
  static const Color surfaceOceanDark = Color(0xFF1F2224);
  static const Color onSurfaceOceanDark = Color(0xFFE1E2E5);
  static const Color surfaceVariantOceanDark = Color(0xFF41484D);
  static const Color onSurfaceVariantOceanDark = Color(0xFFC1C7CE);
  static const Color outlineOceanDark = Color(0xFF8B9297);
  static const Color outlineVariantOceanDark = Color(0xFF41484D);

  // ============================================================================
  // THEME 3: FOREST GREEN (Natural, calming, eco-friendly)
  // ============================================================================

  // Forest Green Light Theme
  static const Color primaryForestLight = Color(0xFF2E7D32);
  static const Color onPrimaryForestLight = Color(0xFFFFFFFF);
  static const Color primaryContainerForestLight = Color(0xFFA5D6A7);
  static const Color onPrimaryContainerForestLight = Color(0xFF00210A);

  static const Color secondaryForestLight = Color(0xFF558B2F);
  static const Color onSecondaryForestLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerForestLight = Color(0xFFDCEDC8);
  static const Color onSecondaryContainerForestLight = Color(0xFF1B2A00);

  static const Color tertiaryForestLight = Color(0xFF689F38);
  static const Color onTertiaryForestLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerForestLight = Color(0xFFF1F8E9);
  static const Color onTertiaryContainerForestLight = Color(0xFF1E3000);

  static const Color backgroundForestLight = Color(0xFFF6F9F4);
  static const Color surfaceForestLight = Color(0xFFFFFFFF);
  static const Color onSurfaceForestLight = Color(0xFF1A1C19);
  static const Color surfaceVariantForestLight = Color(0xFFDEE5D8);
  static const Color onSurfaceVariantForestLight = Color(0xFF424940);
  static const Color outlineForestLight = Color(0xFF72796F);
  static const Color outlineVariantForestLight = Color(0xFFC2C9BD);

  // Forest Green Dark Theme
  static const Color primaryForestDark = Color(0xFF81C784);
  static const Color onPrimaryForestDark = Color(0xFF003910);
  static const Color primaryContainerForestDark = Color(0xFF005319);
  static const Color onPrimaryContainerForestDark = Color(0xFFA5D6A7);

  static const Color secondaryForestDark = Color(0xFF9CCC65);
  static const Color onSecondaryForestDark = Color(0xFF2C4700);
  static const Color secondaryContainerForestDark = Color(0xFF426600);
  static const Color onSecondaryContainerForestDark = Color(0xFFDCEDC8);

  static const Color tertiaryForestDark = Color(0xFFAED581);
  static const Color onTertiaryForestDark = Color(0xFF2F4900);
  static const Color tertiaryContainerForestDark = Color(0xFF476600);
  static const Color onTertiaryContainerForestDark = Color(0xFFF1F8E9);

  static const Color backgroundForestDark = Color(0xFF1A1C19);
  static const Color surfaceForestDark = Color(0xFF1F221E);
  static const Color onSurfaceForestDark = Color(0xFFE1E3DF);
  static const Color surfaceVariantForestDark = Color(0xFF424940);
  static const Color onSurfaceVariantForestDark = Color(0xFFC2C9BD);
  static const Color outlineForestDark = Color(0xFF8C9388);
  static const Color outlineVariantForestDark = Color(0xFF424940);

  // ============================================================================
  // THEME 4: SUNSET ORANGE (Warm, energetic, motivating)
  // ============================================================================

  // Sunset Orange Light Theme
  static const Color primarySunsetLight = Color(0xFFE65100);
  static const Color onPrimarySunsetLight = Color(0xFFFFFFFF);
  static const Color primaryContainerSunsetLight = Color(0xFFFFCC80);
  static const Color onPrimaryContainerSunsetLight = Color(0xFF2B1700);

  static const Color secondarySunsetLight = Color(0xFFFF6F00);
  static const Color onSecondarySunsetLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerSunsetLight = Color(0xFFFFE0B2);
  static const Color onSecondaryContainerSunsetLight = Color(0xFF3E1F00);

  static const Color tertiarySunsetLight = Color(0xFFF57C00);
  static const Color onTertiarySunsetLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerSunsetLight = Color(0xFFFFE082);
  static const Color onTertiaryContainerSunsetLight = Color(0xFF2E2000);

  static const Color backgroundSunsetLight = Color(0xFFFFF8F5);
  static const Color surfaceSunsetLight = Color(0xFFFFFFFF);
  static const Color onSurfaceSunsetLight = Color(0xFF1F1B16);
  static const Color surfaceVariantSunsetLight = Color(0xFFF0E0D0);
  static const Color onSurfaceVariantSunsetLight = Color(0xFF4F4539);
  static const Color outlineSunsetLight = Color(0xFF817567);
  static const Color outlineVariantSunsetLight = Color(0xFFD3C4B4);

  // Sunset Orange Dark Theme
  static const Color primarySunsetDark = Color(0xFFFFB74D);
  static const Color onPrimarySunsetDark = Color(0xFF452B00);
  static const Color primaryContainerSunsetDark = Color(0xFF653F00);
  static const Color onPrimaryContainerSunsetDark = Color(0xFFFFCC80);

  static const Color secondarySunsetDark = Color(0xFFFFAB40);
  static const Color onSecondaryDunsetDark = Color(0xFF5F3200);
  static const Color secondaryContainerSunsetDark = Color(0xFF874A00);
  static const Color onSecondaryContainerSunsetDark = Color(0xFFFFE0B2);

  static const Color tertiarySunsetDark = Color(0xFFFFD54F);
  static const Color onTertiarySunsetDark = Color(0xFF4A3400);
  static const Color tertiaryContainerSunsetDark = Color(0xFF6A4C00);
  static const Color onTertiaryContainerSunsetDark = Color(0xFFFFE082);

  static const Color backgroundSunsetDark = Color(0xFF1F1B16);
  static const Color surfaceSunsetDark = Color(0xFF26211B);
  static const Color onSurfaceSunsetDark = Color(0xFFECE0D4);
  static const Color surfaceVariantSunsetDark = Color(0xFF4F4539);
  static const Color onSurfaceVariantSunsetDark = Color(0xFFD3C4B4);
  static const Color outlineSunsetDark = Color(0xFF9C8F80);
  static const Color outlineVariantSunsetDark = Color(0xFF4F4539);

  // ============================================================================
  // THEME 5: PURPLE DREAMS (Creative, modern, inspiring)
  // ============================================================================

  // Purple Dreams Light Theme
  static const Color primaryPurpleLight = Color(0xFF6A1B9A);
  static const Color onPrimaryPurpleLight = Color(0xFFFFFFFF);
  static const Color primaryContainerPurpleLight = Color(0xFFE1BEE7);
  static const Color onPrimaryContainerPurpleLight = Color(0xFF23003E);

  static const Color secondaryPurpleLight = Color(0xFF7B1FA2);
  static const Color onSecondaryPurpleLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerPurpleLight = Color(0xFFF3E5F5);
  static const Color onSecondaryContainerPurpleLight = Color(0xFF2E0052);

  static const Color tertiaryPurpleLight = Color(0xFF8E24AA);
  static const Color onTertiaryPurpleLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerPurpleLight = Color(0xFFEDE7F6);
  static const Color onTertiaryContainerPurpleLight = Color(0xFF2A0064);

  static const Color backgroundPurpleLight = Color(0xFFFAF8FC);
  static const Color surfacePurpleLight = Color(0xFFFFFFFF);
  static const Color onSurfacePurpleLight = Color(0xFF1C1B1F);
  static const Color surfaceVariantPurpleLight = Color(0xFFE7E0EC);
  static const Color onSurfaceVariantPurpleLight = Color(0xFF49454F);
  static const Color outlinePurpleLight = Color(0xFF79747E);
  static const Color outlineVariantPurpleLight = Color(0xFFCAC4D0);

  // Purple Dreams Dark Theme
  static const Color primaryPurpleDark = Color(0xFFCE93D8);
  static const Color onPrimaryPurpleDark = Color(0xFF3E0061);
  static const Color primaryContainerPurpleDark = Color(0xFF56008A);
  static const Color onPrimaryContainerPurpleDark = Color(0xFFE1BEE7);

  static const Color secondaryPurpleDark = Color(0xFFBA68C8);
  static const Color onSecondaryPurpleDark = Color(0xFF4A0072);
  static const Color secondaryContainerPurpleDark = Color(0xFF65009B);
  static const Color onSecondaryContainerPurpleDark = Color(0xFFF3E5F5);

  static const Color tertiaryPurpleDark = Color(0xFFAB47BC);
  static const Color onTertiaryPurpleDark = Color(0xFF42008E);
  static const Color tertiaryContainerPurpleDark = Color(0xFF5F00A9);
  static const Color onTertiaryContainerPurpleDark = Color(0xFFEDE7F6);

  static const Color backgroundPurpleDark = Color(0xFF1C1B1F);
  static const Color surfacePurpleDark = Color(0xFF232228);
  static const Color onSurfacePurpleDark = Color(0xFFE6E1E5);
  static const Color surfaceVariantPurpleDark = Color(0xFF49454F);
  static const Color onSurfaceVariantPurpleDark = Color(0xFFCAC4D0);
  static const Color outlinePurpleDark = Color(0xFF938F99);
  static const Color outlineVariantPurpleDark = Color(0xFF49454F);
}
