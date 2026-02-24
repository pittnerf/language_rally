// lib/core/constants/app_constants.dart

/// Application-wide constants for Language Rally
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  /// Minimum number of answers required before badges can be earned
  /// This prevents users from earning badges with insufficient data
  /// Example: If user answers 2 items correctly, that's 100% but not meaningful
  static const int minAnswersForBadges = 10;

  /// Badge thresholds (percentage)
  static const List<int> badgeThresholds = [25, 50, 75, 90, 95];

  /// Default items per training session
  static const int defaultItemsPerSession = 20;

  /// Minimum items per training session
  static const int minItemsPerSession = 5;

  /// Maximum items per training session
  static const int maxItemsPerSession = 100;

  /// Default review interval in hours
  static const int defaultReviewIntervalHours = 24;

  /// Default "don't know" threshold
  static const int defaultDontKnowThreshold = 3;

  /// App version
  static const String appVersion = '1.0.0';

  /// Default package icon
  static const String defaultPackageIcon = 'assets/images/default_package_icon.svg';
}

