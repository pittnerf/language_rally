// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  id: json['id'] as String,
  packageId: json['packageId'] as String,
  categoryIds: (json['categoryIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  language1Data: ItemLanguageData.fromJson(
    json['language1Data'] as Map<String, dynamic>,
  ),
  language2Data: ItemLanguageData.fromJson(
    json['language2Data'] as Map<String, dynamic>,
  ),
  examples:
      (json['examples'] as List<dynamic>?)
          ?.map((e) => ExampleSentence.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isKnown: json['isKnown'] as bool? ?? false,
  isFavourite: json['isFavourite'] as bool? ?? false,
  isImportant: json['isImportant'] as bool? ?? false,
  dontKnowCounter: (json['dontKnowCounter'] as num?)?.toInt() ?? 0,
  lastReviewedAt: json['lastReviewedAt'] == null
      ? null
      : DateTime.parse(json['lastReviewedAt'] as String),
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'id': instance.id,
  'packageId': instance.packageId,
  'categoryIds': instance.categoryIds,
  'language1Data': instance.language1Data,
  'language2Data': instance.language2Data,
  'examples': instance.examples,
  'isKnown': instance.isKnown,
  'isFavourite': instance.isFavourite,
  'isImportant': instance.isImportant,
  'dontKnowCounter': instance.dontKnowCounter,
  'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
};
