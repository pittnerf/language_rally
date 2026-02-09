// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingStatistics _$TrainingStatisticsFromJson(Map<String, dynamic> json) =>
    TrainingStatistics(
      packageId: json['packageId'] as String,
      totalItemsLearned: (json['totalItemsLearned'] as num?)?.toInt() ?? 0,
      totalItemsReviewed: (json['totalItemsReviewed'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastTrainedAt: DateTime.parse(json['lastTrainedAt'] as String),
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TrainingStatisticsToJson(TrainingStatistics instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'totalItemsLearned': instance.totalItemsLearned,
      'totalItemsReviewed': instance.totalItemsReviewed,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastTrainedAt': instance.lastTrainedAt.toIso8601String(),
      'averageAccuracy': instance.averageAccuracy,
    };
