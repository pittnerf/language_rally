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
      lastNItems: (json['lastNItems'] as num?)?.toInt() ?? 20,
      itemOrder:
          $enumDecodeNullable(_$ItemOrderEnumMap, json['itemOrder']) ??
          ItemOrder.random,
      displayLanguage:
          $enumDecodeNullable(
            _$DisplayLanguageEnumMap,
            json['displayLanguage'],
          ) ??
          DisplayLanguage.random,
      itemType:
          $enumDecodeNullable(_$ItemTypeEnumMap, json['itemType']) ??
          ItemType.dictionaryItems,
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
      'itemType': _$ItemTypeEnumMap[instance.itemType]!,
      'selectedCategoryIds': instance.selectedCategoryIds,
      'dontKnowThreshold': instance.dontKnowThreshold,
    };

const _$ItemScopeEnumMap = {
  ItemScope.all: 'all',
  ItemScope.lastN: 'lastN',
  ItemScope.onlyUnknown: 'onlyUnknown',
  ItemScope.onlyImportant: 'onlyImportant',
  ItemScope.onlyFavourite: 'onlyFavourite',
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

const _$ItemTypeEnumMap = {
  ItemType.dictionaryItems: 'dictionaryItems',
  ItemType.examples: 'examples',
};
