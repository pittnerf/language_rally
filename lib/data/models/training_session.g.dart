// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingSession _$TrainingSessionFromJson(
  Map<String, dynamic> json,
) => TrainingSession(
  id: json['id'] as String,
  packageId: json['packageId'] as String,
  settings: TrainingSettings.fromJson(json['settings'] as Map<String, dynamic>),
  itemIds: (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
  itemOutcomes:
      (json['itemOutcomes'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const [],
  historicalAccuracyRatios:
      (json['historicalAccuracyRatios'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [],
  badgeEvents:
      (json['badgeEvents'] as List<dynamic>?)
          ?.map((e) => BadgeEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentItemIndex: (json['currentItemIndex'] as num?)?.toInt() ?? 0,
  correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
  totalAnswers: (json['totalAnswers'] as num?)?.toInt() ?? 0,
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  status:
      $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
      SessionStatus.active,
);

Map<String, dynamic> _$TrainingSessionToJson(TrainingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageId': instance.packageId,
      'settings': instance.settings,
      'itemIds': instance.itemIds,
      'itemOutcomes': instance.itemOutcomes,
      'historicalAccuracyRatios': instance.historicalAccuracyRatios,
      'badgeEvents': instance.badgeEvents,
      'currentItemIndex': instance.currentItemIndex,
      'correctAnswers': instance.correctAnswers,
      'totalAnswers': instance.totalAnswers,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'status': _$SessionStatusEnumMap[instance.status]!,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'active',
  SessionStatus.completed: 'completed',
  SessionStatus.paused: 'paused',
};
