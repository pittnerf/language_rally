/// Represents a purchasable language package available in the store.
///
/// The catalog is fetched from Firestore.  [localizedPrice] and [isPurchased]
/// are filled in at runtime from RevenueCat after the catalog is loaded.
class StoreProduct {
  final String productId;       // e.g. "lang_pkg_en_de_a1_animals"
  final String title;           // e.g. "Animals (EN→DE, A1)"
  final String description;
  final String groupName;       // e.g. "English → German"
  final String languageCode1;   // "en"
  final String languageCode2;   // "de"
  final String level;           // "A1", "B2", etc.
  final String storagePath;     // Firebase Storage path to ZIP
  final bool isActive;          // can be toggled in Firestore to hide products

  // ── Runtime state (produced by IAPService, not stored in Firestore) ────────
  final String? localizedPrice;   // e.g. "€1.99" — comes from RevenueCat
  final bool isPurchased;
  final bool isDownloading;
  final double downloadProgress;  // 0.0 – 1.0
  final bool isImported;          // ZIP has been imported into local DB

  const StoreProduct({
    required this.productId,
    required this.title,
    required this.description,
    required this.groupName,
    required this.languageCode1,
    required this.languageCode2,
    required this.level,
    required this.storagePath,
    this.isActive = true,
    this.localizedPrice,
    this.isPurchased = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.isImported = false,
  });

  /// Build from a Firestore document snapshot map.
  factory StoreProduct.fromFirestore(Map<String, dynamic> data) {
    return StoreProduct(
      productId: data['productId'] as String,
      title: data['title'] as String,
      description: (data['description'] as String?) ?? '',
      groupName: data['groupName'] as String,
      languageCode1: data['languageCode1'] as String,
      languageCode2: data['languageCode2'] as String,
      level: (data['level'] as String?) ?? '',
      storagePath: data['storagePath'] as String,
      isActive: (data['isActive'] as bool?) ?? true,
    );
  }

  StoreProduct copyWith({
    String? localizedPrice,
    bool? isPurchased,
    bool? isDownloading,
    double? downloadProgress,
    bool? isImported,
  }) {
    return StoreProduct(
      productId: productId,
      title: title,
      description: description,
      groupName: groupName,
      languageCode1: languageCode1,
      languageCode2: languageCode2,
      level: level,
      storagePath: storagePath,
      isActive: isActive,
      localizedPrice: localizedPrice ?? this.localizedPrice,
      isPurchased: isPurchased ?? this.isPurchased,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isImported: isImported ?? this.isImported,
    );
  }
}

