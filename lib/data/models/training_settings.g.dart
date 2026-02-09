// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingSettings _$TrainingSettingsFromJson(Map<String, dynamic> json) =>
    TrainingSettings(
      packageId: json['packageId'] as String,
      itemScope:
          $enumDecodeNullable(_$ItemScopeEnumMap, json['itemScope']) ??
          ItemScope.all,
      lastNItems: (json['lastNItems'] as num?)?.toInt() ?? 10,
      itemOrder:
          $enumDecodeNullable(_$ItemOrderEnumMap, json['itemOrder']) ??
          ItemOrder.random,
      displayLanguage:
          $enumDecodeNullable(
            _$DisplayLanguageEnumMap,
            json['displayLanguage'],
          ) ??
          DisplayLanguage.random,
      selectedCategoryIds:
          (json['selectedCategoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dontKnowThreshold: (json['dontKnowThreshold'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$TrainingSettingsToJson(TrainingSettings instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'itemScope': _$ItemScopeEnumMap[instance.itemScope]!,
      'lastNItems': instance.lastNItems,
      'itemOrder': _$ItemOrderEnumMap[instance.itemOrder]!,
      'displayLanguage': _$DisplayLanguageEnumMap[instance.displayLanguage]!,
      'selectedCategoryIds': instance.selectedCategoryIds,
      'dontKnowThreshold': instance.dontKnowThreshold,
    };

const _$ItemScopeEnumMap = {
  ItemScope.all: 'all',
  ItemScope.lastN: 'lastN',
  ItemScope.onlyUnknown: 'onlyUnknown',
  ItemScope.onlyImportant: 'onlyImportant',
};

const _$ItemOrderEnumMap = {
  ItemOrder.random: 'random',
  ItemOrder.sequential: 'sequential',
};

const _$DisplayLanguageEnumMap = {
  DisplayLanguage.motherTongue: 'motherTongue',
  DisplayLanguage.targetLanguage: 'targetLanguage',
  DisplayLanguage.random: 'random',
};
