// lib/data/models/extracted_item.dart

/// Represents an item extracted from text analysis
class ExtractedItem {
  final String text;
  final String type; // 'word' or 'expression'
  final String? preItem;
  final String? postItem;
  bool isSelected;
  bool isDuplicate;

  // Translated data
  String? translatedText;
  String? translatedPreItem;
  String? translatedPostItem;
  List<Map<String, String>>? examples;

  ExtractedItem({
    required this.text,
    required this.type,
    this.preItem,
    this.postItem,
    this.isSelected = true,
    this.isDuplicate = false,
    this.translatedText,
    this.translatedPreItem,
    this.translatedPostItem,
    this.examples,
  });

  ExtractedItem copyWith({
    String? text,
    String? type,
    String? preItem,
    String? postItem,
    bool? isSelected,
    bool? isDuplicate,
    String? translatedText,
    String? translatedPreItem,
    String? translatedPostItem,
    List<Map<String, String>>? examples,
  }) {
    return ExtractedItem(
      text: text ?? this.text,
      type: type ?? this.type,
      preItem: preItem ?? this.preItem,
      postItem: postItem ?? this.postItem,
      isSelected: isSelected ?? this.isSelected,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      translatedText: translatedText ?? this.translatedText,
      translatedPreItem: translatedPreItem ?? this.translatedPreItem,
      translatedPostItem: translatedPostItem ?? this.translatedPostItem,
      examples: examples ?? this.examples,
    );
  }
}

