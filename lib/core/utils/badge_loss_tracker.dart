// lib/core/utils/badge_loss_tracker.dart

import '../../data/models/training_session.dart';
import '../../data/models/badge_event.dart';
import 'badge_helper.dart';
import '../constants/app_constants.dart';

/// Tracks consecutive failures to detect when badges should be lost
class BadgeLossTracker {
  /// Number of consecutive failures required to lose a badge
  static const int consecutiveFailuresForLoss = 5;

  /// Check if any badges should be lost based on consecutive failures
  /// Returns list of BadgeEvents for badges that should be lost
  static List<BadgeEvent> checkForLostBadges(TrainingSession session) {
    final lostBadges = <BadgeEvent>[];

    // Need minimum answers to have badges
    if (session.totalAnswers < AppConstants.minAnswersForBadges) {
      return lostBadges;
    }

    // Check each currently held badge
    final currentBadges = session.currentBadges;

    for (final badgeId in currentBadges) {
      if (_shouldLoseBadge(session, badgeId)) {
        lostBadges.add(BadgeEvent.lost(
          badgeId: badgeId,
          totalAnswers: session.totalAnswers,
          accuracy: session.accuracy,
        ));
      }
    }

    return lostBadges;
  }

  /// Check if a specific badge should be lost
  static bool _shouldLoseBadge(TrainingSession session, String badgeId) {
    final badgeLevel = BadgeHelper.getBadgeLevelById(badgeId);
    if (badgeLevel == null) return false;

    final threshold = badgeLevel.threshold;

    // Check if current accuracy is below threshold
    if (session.accuracy >= threshold) {
      return false; // Still above threshold
    }

    // Count consecutive failures (answers where user didn't know)
    final consecutiveFailures = _getConsecutiveFailures(session.itemOutcomes);

    return consecutiveFailures >= consecutiveFailuresForLoss;
  }

  /// Get the number of consecutive failures at the end of outcomes list
  static int _getConsecutiveFailures(List<bool> itemOutcomes) {
    if (itemOutcomes.isEmpty) return 0;

    int count = 0;
    for (int i = itemOutcomes.length - 1; i >= 0; i--) {
      if (itemOutcomes[i] == false) {
        // false = didn't know
        count++;
      } else {
        break; // Stop at first success
      }
    }

    return count;
  }

  /// Check if badge was recently lost (within last N answers)
  static bool wasRecentlyLost(TrainingSession session, String badgeId, {int withinLastN = 10}) {
    final lostEvents = session.lostBadgeEvents
        .where((e) => e.badgeId == badgeId)
        .toList();

    if (lostEvents.isEmpty) return false;

    final lastLostEvent = lostEvents.last;
    final answersSinceLoss = session.totalAnswers - lastLostEvent.totalAnswersAtEvent;

    return answersSinceLoss <= withinLastN;
  }

  /// Get number of consecutive failures before next badge loss
  static int failuresUntilBadgeLoss(TrainingSession session, String badgeId) {
    if (!session.hasBadge(badgeId)) {
      return 0; // Badge not held
    }

    final badgeLevel = BadgeHelper.getBadgeLevelById(badgeId);
    if (badgeLevel == null) return 0;

    // If still above threshold, return max failures
    if (session.accuracy >= badgeLevel.threshold) {
      return consecutiveFailuresForLoss;
    }

    final currentFailures = _getConsecutiveFailures(session.itemOutcomes);
    return (consecutiveFailuresForLoss - currentFailures).clamp(0, consecutiveFailuresForLoss);
  }

  /// Get warning message for badge at risk of being lost
  static String? getBadgeLossWarning(TrainingSession session, String badgeId) {
    final failuresLeft = failuresUntilBadgeLoss(session, badgeId);

    if (failuresLeft <= 0) {
      return null; // Badge not at risk
    }

    final badgeLevel = BadgeHelper.getBadgeLevelById(badgeId);
    if (badgeLevel == null) return null;

    if (session.accuracy < badgeLevel.threshold && failuresLeft <= 2) {
      return '⚠️ Badge at risk! $failuresLeft more failures will lose this badge.';
    }

    return null;
  }
}

