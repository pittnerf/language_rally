import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/store_product.dart';
import '../../data/repositories/store_repository.dart';
import '../../core/services/iap_service.dart';

// ── Catalog provider ──────────────────────────────────────────────────────────

/// Async provider: fetches the full store catalog (Firestore + RevenueCat merge).
final storeCatalogProvider =
    AsyncNotifierProvider<StoreCatalogNotifier, Map<String, List<StoreProduct>>>(
  StoreCatalogNotifier.new,
);

class StoreCatalogNotifier
    extends AsyncNotifier<Map<String, List<StoreProduct>>> {
  final _repo = StoreRepository();

  @override
  Future<Map<String, List<StoreProduct>>> build() => _repo.getCatalogByGroup();

  /// Reload catalog (e.g. after restore or returning from a purchase).
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getCatalogByGroup);
  }

  // ---------------------------------------------------------------------------
  // Purchase flow
  // ---------------------------------------------------------------------------

  /// Initiates a purchase for [product].
  ///
  /// Sets the product's [isDownloading] flag during download and updates the
  /// catalog entry once complete.
  Future<IAPResult> purchase(StoreProduct product) async {
    // Optimistically mark as downloading
    _updateProduct(product.copyWith(isDownloading: true, downloadProgress: 0.0));

    final result = await IAPService.instance.purchaseAndDownload(
      product,
      onProgress: (progress) {
        _updateProduct(product.copyWith(
          isDownloading: true,
          downloadProgress: progress,
        ));
      },
    );

    // Refresh from source after attempt
    final refreshed = await _repo.refreshProduct(product);
    _updateProduct(refreshed.copyWith(isDownloading: false));
    return result;
  }

  /// Downloads a product that is already purchased but not yet imported.
  Future<IAPResult> downloadPurchased(StoreProduct product) async {
    _updateProduct(product.copyWith(isDownloading: true, downloadProgress: 0.0));

    final result = await IAPService.instance.downloadPurchased(
      product,
      onProgress: (progress) {
        _updateProduct(product.copyWith(
          isDownloading: true,
          downloadProgress: progress,
        ));
      },
    );

    final refreshed = await _repo.refreshProduct(product);
    _updateProduct(refreshed.copyWith(isDownloading: false));
    return result;
  }

  // ---------------------------------------------------------------------------
  // Restore
  // ---------------------------------------------------------------------------

  Future<void> restorePurchases() async {
    state = const AsyncLoading();
    await IAPService.instance.restorePurchases();
    state = await AsyncValue.guard(_repo.getCatalogByGroup);
  }

  // ---------------------------------------------------------------------------
  // Internal helper
  // ---------------------------------------------------------------------------

  void _updateProduct(StoreProduct updated) {
    final current = state.value;
    if (current == null) return;

    final newMap = <String, List<StoreProduct>>{};
    for (final entry in current.entries) {
      newMap[entry.key] = entry.value.map((p) {
        return p.productId == updated.productId ? updated : p;
      }).toList();
    }
    state = AsyncData(newMap);
  }
}

