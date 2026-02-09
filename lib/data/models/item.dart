import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'item_language_data.dart';
import 'example_sentence.dart';

part 'item.g.dart';

@JsonSerializable()
class Item extends Equatable {
  final String id;
  final String packageId; // Links Item to LanguagePackage
  final List<String> categoryIds;
  final ItemLanguageData language1Data;
  final ItemLanguageData language2Data;
  final List<ExampleSentence> examples;
  final bool isKnown;
  final bool isFavourite;
  final bool isImportant;
  final int dontKnowCounter;
  final DateTime? lastReviewedAt;

  const Item({
    required this.id,
    required this.packageId,
    required this.categoryIds,
    required this.language1Data,
    required this.language2Data,
    this.examples = const [],
    this.isKnown = false,
    this.isFavourite = false,
    this.isImportant = false,
    this.dontKnowCounter = 0,
    this.lastReviewedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  Item copyWith({
    String? id,
    String? packageId,
    List<String>? categoryIds,
    ItemLanguageData? language1Data,
    ItemLanguageData? language2Data,
    List<ExampleSentence>? examples,
    bool? isKnown,
    bool? isFavourite,
    bool? isImportant,
    int? dontKnowCounter,
    DateTime? lastReviewedAt,
  }) =>
      Item(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        categoryIds: categoryIds ?? this.categoryIds,
        language1Data: language1Data ?? this.language1Data,
        language2Data: language2Data ?? this.language2Data,
        examples: examples ?? this.examples,
        isKnown: isKnown ?? this.isKnown,
        isFavourite: isFavourite ?? this.isFavourite,
        isImportant: isImportant ?? this.isImportant,
        dontKnowCounter: dontKnowCounter ?? this.dontKnowCounter,
        lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      );

  @override
  List<Object?> get props => [
        id,
        packageId,
        categoryIds,
        language1Data,
        language2Data,
        examples,
        isKnown,
        isFavourite,
        isImportant,
        dontKnowCounter,
        lastReviewedAt
      ];
}
