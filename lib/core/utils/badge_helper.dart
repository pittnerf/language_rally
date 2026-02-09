// lib/core/utils/badge_helper.dart

import '../constants/app_constants.dart';

/// Helper class for managing achievement badges in Language Rally
class BadgeHelper {
  /// All available badge thresholds and their identifiers
  static const List<BadgeLevel> badgeLevels = [
    BadgeLevel(25, 'badge_25', 'Beginner', '🥉'),
    BadgeLevel(50, 'badge_50', 'Learner', '🥈'),
    BadgeLevel(75, 'badge_75', 'Skilled', '🥇'),
    BadgeLevel(80, 'badge_80', 'Advanced', '💚'),
    BadgeLevel(85, 'badge_85', 'Proficient', '💙'),
    BadgeLevel(90, 'badge_90', 'Excellent', '💜'),
    BadgeLevel(95, 'badge_95', 'Master', '⭐'),
    BadgeLevel(100, 'badge_100', 'Wizard', '🧙‍♂️'),
  ];

  /// Get the asset path for a badge
  static String getBadgeAssetPath(String badgeId) {
    return 'assets/images/badges/$badgeId.svg';
  }

  /// Get badge ID from accuracy percentage
  /// Returns null if minimum answers requirement is not met
  static String? getBadgeIdForAccuracy(double accuracy, {int totalAnswers = 0}) {
    // Check if minimum answers requirement is met
    if (totalAnswers < AppConstants.minAnswersForBadges) {
      return null; // Not enough answers to earn a badge
    }

    // Find the highest badge level achieved
    for (int i = badgeLevels.length - 1; i >= 0; i--) {
      if (accuracy >= badgeLevels[i].threshold) {
        return badgeLevels[i].id;
      }
    }
    return null; // No badge earned yet
  }

  /// Get all badge IDs that should be earned for given accuracy
  /// Returns empty list if minimum answers requirement is not met
  static List<String> getAllEarnedBadgeIds(double accuracy, {int totalAnswers = 0}) {
    // Check if minimum answers requirement is met
    if (totalAnswers < AppConstants.minAnswersForBadges) {
      return []; // Not enough answers to earn badges
    }

    return badgeLevels
        .where((level) => accuracy >= level.threshold)
        .map((level) => level.id)
        .toList();
  }

  /// Get badge level information by ID
  static BadgeLevel? getBadgeLevelById(String badgeId) {
    try {
      return badgeLevels.firstWhere((level) => level.id == badgeId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a new badge was earned (comparing previous and current accuracy)
  /// Requires totalAnswers to check minimum requirement
  static String? getNewlyEarnedBadge(
    double previousAccuracy,
    double currentAccuracy, {
    required int totalAnswers,
  }) {
    final previousBadge = getBadgeIdForAccuracy(previousAccuracy, totalAnswers: totalAnswers - 1);
    final currentBadge = getBadgeIdForAccuracy(currentAccuracy, totalAnswers: totalAnswers);

    if (currentBadge != null && currentBadge != previousBadge) {
      return currentBadge;
    }
    return null;
  }

  /// Get all badges that should be earned between two accuracy values
  /// Requires totalAnswers to check minimum requirement
  static List<String> getBadgesCrossedInRange(
    double fromAccuracy,
    double toAccuracy, {
    required int totalAnswers,
  }) {
    // Check if minimum answers requirement is met
    if (totalAnswers < AppConstants.minAnswersForBadges) {
      return []; // Not enough answers to earn badges
    }

    final newBadges = <String>[];

    for (final level in badgeLevels) {
      // Check if threshold was crossed
      if (fromAccuracy < level.threshold && toAccuracy >= level.threshold) {
        newBadges.add(level.id);
      }
    }

    return newBadges;
  }

  /// Get the next badge to achieve
  static BadgeLevel? getNextBadge(double currentAccuracy) {
    for (final level in badgeLevels) {
      if (currentAccuracy < level.threshold) {
        return level;
      }
    }
    return null; // All badges earned!
  }

  /// Calculate progress to next badge (0.0 to 1.0)
  static double getProgressToNextBadge(double currentAccuracy) {
    final nextBadge = getNextBadge(currentAccuracy);
    if (nextBadge == null) return 1.0; // All badges earned

    // Find previous badge threshold
    double previousThreshold = 0.0;
    for (final level in badgeLevels) {
      if (level.threshold >= nextBadge.threshold) break;
      if (currentAccuracy >= level.threshold) {
        previousThreshold = level.threshold;
      }
    }

    final range = nextBadge.threshold - previousThreshold;
    final progress = currentAccuracy - previousThreshold;

    return range > 0 ? (progress / range).clamp(0.0, 1.0) : 0.0;
  }

  /// Get formatted badge name with emoji
  static String getBadgeDisplayName(String badgeId) {
    final level = getBadgeLevelById(badgeId);
    if (level == null) return badgeId;
    return '${level.emoji} ${level.name}';
  }

  /// Check if all badges are earned
  /// Requires minimum answers to be met
  static bool hasAllBadges(double accuracy, {int totalAnswers = 0}) {
    if (totalAnswers < AppConstants.minAnswersForBadges) {
      return false; // Not enough answers
    }
    return accuracy >= badgeLevels.last.threshold;
  }

  /// Get total number of badges
  static int get totalBadgeCount => badgeLevels.length;

  /// Get number of earned badges for given accuracy
  /// Returns 0 if minimum answers requirement is not met
  static int getEarnedBadgeCount(double accuracy, {int totalAnswers = 0}) {
    return getAllEarnedBadgeIds(accuracy, totalAnswers: totalAnswers).length;
  }
}

/// Represents a badge level with its properties
class BadgeLevel {
  final double threshold;
  final String id;
  final String name;
  final String emoji;

  const BadgeLevel(this.threshold, this.id, this.name, this.emoji);

  /// Get the asset path for this badge
  String get assetPath => BadgeHelper.getBadgeAssetPath(id);

  @override
  String toString() => '$emoji $name ($threshold%)';
}

