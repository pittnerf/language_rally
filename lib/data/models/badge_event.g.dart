// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadgeEvent _$BadgeEventFromJson(Map<String, dynamic> json) => BadgeEvent(
  badgeId: json['badgeId'] as String,
  eventType: $enumDecode(_$BadgeEventTypeEnumMap, json['eventType']),
  totalAnswersAtEvent: (json['totalAnswersAtEvent'] as num).toInt(),
  accuracyAtEvent: (json['accuracyAtEvent'] as num).toDouble(),
);

Map<String, dynamic> _$BadgeEventToJson(BadgeEvent instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'eventType': _$BadgeEventTypeEnumMap[instance.eventType]!,
      'totalAnswersAtEvent': instance.totalAnswersAtEvent,
      'accuracyAtEvent': instance.accuracyAtEvent,
    };

const _$BadgeEventTypeEnumMap = {
  BadgeEventType.earned: 'earned',
  BadgeEventType.lost: 'lost',
};
