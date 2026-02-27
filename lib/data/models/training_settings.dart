import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training_settings.g.dart';

enum ItemScope { all, lastN, onlyUnknown, onlyImportant, onlyFavourite }

enum ItemOrder { random, sequential }

enum DisplayLanguage {
  motherTongue, // language1
  targetLanguage, // language2
  random,
}

enum ItemType { dictionaryItems, examples }

@JsonSerializable()
class TrainingSettings extends Equatable {
  final String packageId;

  // Item selection
  final ItemScope itemScope;
  final int lastNItems; // Used when itemScope is lastN

  // Order
  final ItemOrder itemOrder;

  // Display
  final DisplayLanguage displayLanguage;

  // Item type
  final ItemType itemType;

  // Category filters
  final List<String> selectedCategoryIds; // Empty list means no filter

  // Training control
  final int dontKnowThreshold; // For resetting "don't know counters"

  const TrainingSettings({
    required this.packageId,
    this.itemScope = ItemScope.all,
    this.lastNItems = 20,
    this.itemOrder = ItemOrder.random,
    this.displayLanguage = DisplayLanguage.random,
    this.itemType = ItemType.dictionaryItems,
    this.selectedCategoryIds = const [],
    this.dontKnowThreshold = 3,
  });

  factory TrainingSettings.fromJson(Map<String, dynamic> json) =>
      _$TrainingSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSettingsToJson(this);

  TrainingSettings copyWith({
    String? packageId,
    ItemScope? itemScope,
    int? lastNItems,
    ItemOrder? itemOrder,
    DisplayLanguage? displayLanguage,
    ItemType? itemType,
    List<String>? selectedCategoryIds,
    int? dontKnowThreshold,
  }) => TrainingSettings(
    packageId: packageId ?? this.packageId,
    itemScope: itemScope ?? this.itemScope,
    lastNItems: lastNItems ?? this.lastNItems,
    itemOrder: itemOrder ?? this.itemOrder,
    displayLanguage: displayLanguage ?? this.displayLanguage,
    itemType: itemType ?? this.itemType,
    selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    dontKnowThreshold: dontKnowThreshold ?? this.dontKnowThreshold,
  );

  @override
  List<Object?> get props => [
    packageId,
    itemScope,
    lastNItems,
    itemOrder,
    displayLanguage,
    itemType,
    selectedCategoryIds,
    dontKnowThreshold,
  ];
}
