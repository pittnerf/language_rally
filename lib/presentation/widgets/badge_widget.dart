// lib/presentation/widgets/badge_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/badge_helper.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

/// Widget to display an achievement badge
class BadgeWidget extends StatelessWidget {
  final String badgeId;
  final double size;
  final bool isEarned;
  final bool showLocked;

  const BadgeWidget({
    super.key,
    required this.badgeId,
    this.size = 64.0,
    this.isEarned = true,
    this.showLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = BadgeHelper.getBadgeAssetPath(badgeId);
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Badge image
        SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          colorFilter: isEarned
              ? null
              : ColorFilter.mode(
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  BlendMode.saturation,
                ),
        ),

        // Lock icon for unearned badges
        if (!isEarned && showLocked)
          Icon(
            Icons.lock,
            size: size * 0.4,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}

/// Compact badge widget for list items
class BadgeWidgetSmall extends StatelessWidget {
  final String badgeId;
  final bool isEarned;

  const BadgeWidgetSmall({
    super.key,
    required this.badgeId,
    this.isEarned = true,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      badgeId: badgeId,
      size: 32,
      isEarned: isEarned,
      showLocked: false,
    );
  }
}

/// Large badge widget for detailed views
class BadgeWidgetLarge extends StatelessWidget {
  final String badgeId;
  final bool isEarned;

  const BadgeWidgetLarge({
    super.key,
    required this.badgeId,
    this.isEarned = true,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      badgeId: badgeId,
      size: 96,
      isEarned: isEarned,
    );
  }
}

/// Display all badges with their status
class BadgeGrid extends StatelessWidget {
  final double currentAccuracy;
  final int totalAnswers;
  final VoidCallback? onBadgeTap;

  const BadgeGrid({
    super.key,
    required this.currentAccuracy,
    this.totalAnswers = 0,
    this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: BadgeHelper.badgeLevels.length,
      itemBuilder: (context, index) {
        final level = BadgeHelper.badgeLevels[index];
        final isEarned = currentAccuracy >= level.threshold &&
                        totalAnswers >= AppConstants.minAnswersForBadges;

        return GestureDetector(
          onTap: onBadgeTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeWidget(
                badgeId: level.id,
                size: 56,
                isEarned: isEarned,
              ),
              const SizedBox(height: 4),
              Text(
                '${level.threshold.toInt()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Display earned badges in a horizontal list
class EarnedBadgesList extends StatelessWidget {
  final double currentAccuracy;
  final int totalAnswers;
  final int maxBadges;

  const EarnedBadgesList({
    super.key,
    required this.currentAccuracy,
    this.totalAnswers = 0,
    this.maxBadges = 3,
  });

  @override
  Widget build(BuildContext context) {
    final earnedBadges = BadgeHelper.getAllEarnedBadgeIds(
      currentAccuracy,
      totalAnswers: totalAnswers,
    );

    if (earnedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show most recent badges
    final displayBadges = earnedBadges.reversed.take(maxBadges).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...displayBadges.map((badgeId) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: BadgeWidgetSmall(badgeId: badgeId),
        )),
        if (earnedBadges.length > maxBadges)
          Text(
            '+${earnedBadges.length - maxBadges}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

/// Show next badge progress
class NextBadgeProgress extends StatelessWidget {
  final double currentAccuracy;

  const NextBadgeProgress({
    super.key,
    required this.currentAccuracy,
  });

  @override
  Widget build(BuildContext context) {
    final nextBadge = BadgeHelper.getNextBadge(currentAccuracy);

    if (nextBadge == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Theme.of(context).colorScheme.tertiary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '🎉 All badges earned! You are a Master!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final progress = BadgeHelper.getProgressToNextBadge(currentAccuracy);
    final pointsNeeded = nextBadge.threshold - currentAccuracy;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BadgeWidget(
                  badgeId: nextBadge.id,
                  size: 48,
                  isEarned: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next: ${nextBadge.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${pointsNeeded.toStringAsFixed(1)}% to go',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% progress',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog to show when a badge is earned
class BadgeEarnedDialog extends StatelessWidget {
  final String badgeId;

  const BadgeEarnedDialog({
    super.key,
    required this.badgeId,
  });

  @override
  Widget build(BuildContext context) {
    final level = BadgeHelper.getBadgeLevelById(badgeId);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.celebration,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          Text(l10n.badgeEarned),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BadgeWidgetLarge(badgeId: badgeId),
          const SizedBox(height: 16),
          if (level != null) ...[
            Text(
              level.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${level.threshold.toInt()}% ${l10n.achievement}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.awesome),
        ),
      ],
    );
  }

  static void show(BuildContext context, String badgeId) {
    showDialog(
      context: context,
      builder: (_) => BadgeEarnedDialog(badgeId: badgeId),
    );
  }
}

