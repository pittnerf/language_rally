import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'badge_event.dart';
import 'training_settings.dart';

part 'training_session.g.dart';

enum SessionStatus { active, completed, paused }

@JsonSerializable()
class TrainingSession extends Equatable {
  final String id;
  final String packageId;
  final TrainingSettings settings;
  final List<String> itemIds;
  final List<bool> itemOutcomes; // True = user knew it, False = didn't know
  final List<double> historicalAccuracyRatios; // Accuracy after each answer (correctAnswers/totalAnswers)
  final List<BadgeEvent> badgeEvents; // Badge earned/lost events with timestamps
  final int currentItemIndex;
  final int correctAnswers;
  final int totalAnswers;
  final DateTime startedAt;
  final DateTime? completedAt;
  final SessionStatus status;

  const TrainingSession({
    required this.id,
    required this.packageId,
    required this.settings,
    required this.itemIds,
    this.itemOutcomes = const [],
    this.historicalAccuracyRatios = const [],
    this.badgeEvents = const [],
    this.currentItemIndex = 0,
    this.correctAnswers = 0,
    this.totalAnswers = 0,
    required this.startedAt,
    this.completedAt,
    this.status = SessionStatus.active,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSessionToJson(this);

  double get accuracy =>
      totalAnswers == 0 ? 0.0 : (correctAnswers / totalAnswers) * 100;

  /// Get all currently earned badges (earned but not lost)
  List<String> get currentBadges {
    final badgeStatus = <String, bool>{};

    for (final event in badgeEvents) {
      if (event.isEarned) {
        badgeStatus[event.badgeId] = true;
      } else if (event.isLost) {
        badgeStatus[event.badgeId] = false;
      }
    }

    return badgeStatus.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check if a specific badge is currently held
  bool hasBadge(String badgeId) {
    return currentBadges.contains(badgeId);
  }

  /// Get all earned badge events
  List<BadgeEvent> get earnedBadgeEvents {
    return badgeEvents.where((e) => e.isEarned).toList();
  }

  /// Get all lost badge events
  List<BadgeEvent> get lostBadgeEvents {
    return badgeEvents.where((e) => e.isLost).toList();
  }

  TrainingSession copyWith({
    String? id,
    String? packageId,
    TrainingSettings? settings,
    List<String>? itemIds,
    List<bool>? itemOutcomes,
    List<double>? historicalAccuracyRatios,
    List<BadgeEvent>? badgeEvents,
    int? currentItemIndex,
    int? correctAnswers,
    int? totalAnswers,
    DateTime? startedAt,
    DateTime? completedAt,
    SessionStatus? status,
  }) =>
      TrainingSession(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        settings: settings ?? this.settings,
        itemIds: itemIds ?? this.itemIds,
        itemOutcomes: itemOutcomes ?? this.itemOutcomes,
        historicalAccuracyRatios: historicalAccuracyRatios ?? this.historicalAccuracyRatios,
        badgeEvents: badgeEvents ?? this.badgeEvents,
        currentItemIndex: currentItemIndex ?? this.currentItemIndex,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        totalAnswers: totalAnswers ?? this.totalAnswers,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
    id,
    packageId,
    settings,
    itemIds,
    itemOutcomes,
    historicalAccuracyRatios,
    badgeEvents,
    currentItemIndex,
    correctAnswers,
    totalAnswers,
    startedAt,
    completedAt,
    status,
  ];
}
