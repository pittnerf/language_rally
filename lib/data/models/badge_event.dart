// lib/data/models/badge_event.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge_event.g.dart';

enum BadgeEventType { earned, lost }

/// Represents a badge being earned or lost during a training session
@JsonSerializable()
class BadgeEvent extends Equatable {
  final String badgeId;
  final BadgeEventType eventType;
  final int totalAnswersAtEvent; // Total answers when this event occurred
  final double accuracyAtEvent; // Accuracy when this event occurred

  const BadgeEvent({
    required this.badgeId,
    required this.eventType,
    required this.totalAnswersAtEvent,
    required this.accuracyAtEvent,
  });

  factory BadgeEvent.fromJson(Map<String, dynamic> json) =>
      _$BadgeEventFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeEventToJson(this);

  /// Create an "earned" badge event
  factory BadgeEvent.earned({
    required String badgeId,
    required int totalAnswers,
    required double accuracy,
  }) =>
      BadgeEvent(
        badgeId: badgeId,
        eventType: BadgeEventType.earned,
        totalAnswersAtEvent: totalAnswers,
        accuracyAtEvent: accuracy,
      );

  /// Create a "lost" badge event
  factory BadgeEvent.lost({
    required String badgeId,
    required int totalAnswers,
    required double accuracy,
  }) =>
      BadgeEvent(
        badgeId: badgeId,
        eventType: BadgeEventType.lost,
        totalAnswersAtEvent: totalAnswers,
        accuracyAtEvent: accuracy,
      );

  bool get isEarned => eventType == BadgeEventType.earned;
  bool get isLost => eventType == BadgeEventType.lost;

  @override
  List<Object?> get props => [
        badgeId,
        eventType,
        totalAnswersAtEvent,
        accuracyAtEvent,
      ];

  @override
  String toString() {
    final action = isEarned ? 'Earned' : 'Lost';
    return '$action $badgeId at $totalAnswersAtEvent answers ($accuracyAtEvent%)';
  }
}

