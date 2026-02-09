import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_language_data.g.dart';

@JsonSerializable()
class ItemLanguageData extends Equatable {
  final String languageCode;
  final String text;
  final String? preItem;
  final String? postItem;

  const ItemLanguageData({
    required this.languageCode,
    required this.text,
    this.preItem,
    this.postItem,
  });

  factory ItemLanguageData.fromJson(Map<String, dynamic> json) =>
      _$ItemLanguageDataFromJson(json);

  Map<String, dynamic> toJson() => _$ItemLanguageDataToJson(this);

  @override
  List<Object?> get props => [languageCode, text, preItem, postItem];
}
