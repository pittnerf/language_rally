import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training_statistics.g.dart';

@JsonSerializable()
class TrainingStatistics extends Equatable {
  final String packageId;
  final int totalItemsLearned;
  final int totalItemsReviewed;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastTrainedAt;
  final double averageAccuracy;

  const TrainingStatistics({
    required this.packageId,
    this.totalItemsLearned = 0,
    this.totalItemsReviewed = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastTrainedAt,
    this.averageAccuracy = 0.0,
  });

  factory TrainingStatistics.fromJson(Map<String, dynamic> json) =>
      _$TrainingStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingStatisticsToJson(this);

  TrainingStatistics copyWith({
    String? packageId,
    int? totalItemsLearned,
    int? totalItemsReviewed,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastTrainedAt,
    double? averageAccuracy,
  }) =>
      TrainingStatistics(
        packageId: packageId ?? this.packageId,
        totalItemsLearned: totalItemsLearned ?? this.totalItemsLearned,
        totalItemsReviewed: totalItemsReviewed ?? this.totalItemsReviewed,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastTrainedAt: lastTrainedAt ?? this.lastTrainedAt,
        averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      );

  @override
  List<Object?> get props => [
    packageId,
    totalItemsLearned,
    totalItemsReviewed,
    currentStreak,
    longestStreak,
    lastTrainedAt,
    averageAccuracy,
  ];
}
