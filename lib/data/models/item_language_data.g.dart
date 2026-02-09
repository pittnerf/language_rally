// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_language_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemLanguageData _$ItemLanguageDataFromJson(Map<String, dynamic> json) =>
    ItemLanguageData(
      languageCode: json['languageCode'] as String,
      text: json['text'] as String,
      preItem: json['preItem'] as String?,
      postItem: json['postItem'] as String?,
    );

Map<String, dynamic> _$ItemLanguageDataToJson(ItemLanguageData instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'text': instance.text,
      'preItem': instance.preItem,
      'postItem': instance.postItem,
    };
