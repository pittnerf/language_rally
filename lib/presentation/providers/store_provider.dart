import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/store_product.dart';
import '../../data/repositories/pending_store_download_repository.dart';
import '../../data/repositories/store_repository.dart';
import '../../core/services/iap_service.dart';

// ── Catalog provider ──────────────────────────────────────────────────────────

/// Async provider: fetches the full store catalog (Firestore + RevenueCat merge).
final storeCatalogProvider =
    AsyncNotifierProvider<StoreCatalogNotifier, Map<String, List<StoreProduct>>>(
  StoreCatalogNotifier.new,
);

/// True while the app is resuming pending purchase downloads/imports.
final storeResumeInProgressProvider =
    NotifierProvider<StoreResumeInProgressNotifier, bool>(
  StoreResumeInProgressNotifier.new,
);

class StoreResumeInProgressNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setInProgress(bool value) => state = value;
}

class StoreCatalogNotifier
    extends AsyncNotifier<Map<String, List<StoreProduct>>> {
  final _repo = StoreRepository();
  final _pendingRepo = PendingStoreDownloadRepository();
  bool _resumeInProgress = false;

  @override
  Future<Map<String, List<StoreProduct>>> build() async {
    final catalog = await _repo.getCatalogByGroup();
    unawaited(resumePendingDownloads());
    return catalog;
  }

  /// Reload catalog (e.g. after restore or returning from a purchase).
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getCatalogByGroup);
    unawaited(resumePendingDownloads());
  }

  // ---------------------------------------------------------------------------
  // Purchase flow
  // ---------------------------------------------------------------------------

  /// Initiates a purchase for [product].
  ///
  /// Sets the product's [isDownloading] flag during download and updates the
  /// catalog entry once complete.
  ///
  /// [onDuplicate] is forwarded to [IAPService.purchaseAndDownload] — see that
  /// method for details.
  Future<IAPResult> purchase(
    StoreProduct product, {
    Future<bool> Function(String groupName, String packageName)? onDuplicate,
  }) async {
    await _pendingRepo.markPending(product.productId);

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
      onDuplicate: onDuplicate,
    );

    // Refresh from source after attempt
    final refreshed = await _repo.refreshProduct(product);
    _updateProduct(refreshed.copyWith(isDownloading: false));

    final keepPending = refreshed.isPurchased && !refreshed.isImported;
    if (!keepPending || result == IAPResult.cancelled) {
      await _pendingRepo.clearPending(product.productId);
    }
    return result;
  }

  /// Downloads a product that is already purchased but not yet imported.
  ///
  /// [onDuplicate] is called when a package with the same group name and
  /// package name already exists locally. Return `true` to overwrite the
  /// existing package or `false` to abort.
  Future<IAPResult> downloadPurchased(
    StoreProduct product, {
    Future<bool> Function(String groupName, String packageName)? onDuplicate,
  }) async {
    await _pendingRepo.markPending(product.productId);
    _updateProduct(product.copyWith(isDownloading: true, downloadProgress: 0.0));

    final result = await IAPService.instance.downloadPurchased(
      product,
      onProgress: (progress) {
        _updateProduct(product.copyWith(
          isDownloading: true,
          downloadProgress: progress,
        ));
      },
      onDuplicate: onDuplicate,
    );

    final refreshed = await _repo.refreshProduct(product);
    _updateProduct(refreshed.copyWith(isDownloading: false));

    if (refreshed.isImported || !refreshed.isPurchased || result == IAPResult.cancelled) {
      await _pendingRepo.clearPending(product.productId);
    }
    return result;
  }

  /// Resumes unfinished download/import tasks for previously purchased products.
  Future<void> resumePendingDownloads() async {
    if (_resumeInProgress) return;
    _resumeInProgress = true;
    ref.read(storeResumeInProgressProvider.notifier).setInProgress(true);

    try {
      var current = state.value;
      if (current == null) {
        current = await _repo.getCatalogByGroup();
        state = AsyncData(current);
      }

      final pendingIds = await _pendingRepo.getPendingProductIds();
      if (pendingIds.isEmpty) return;

      final allProducts = current.values.expand((list) => list).toList();
      for (final productId in pendingIds.toList()) {
        StoreProduct? product;
        for (final p in allProducts) {
          if (p.productId == productId) {
            product = p;
            break;
          }
        }

        if (product == null) {
          await _pendingRepo.clearPending(productId);
          continue;
        }

        final currentProduct = product;

        // If the package is no longer pending, clear stale queue entry.
        if (!currentProduct.isPurchased || currentProduct.isImported) {
          await _pendingRepo.clearPending(productId);
          continue;
        }

        _updateProduct(currentProduct.copyWith(isDownloading: true, downloadProgress: 0.0));
        await IAPService.instance.downloadPurchased(
          currentProduct,
          onProgress: (progress) {
            _updateProduct(currentProduct.copyWith(
              isDownloading: true,
              downloadProgress: progress,
            ));
          },
        );

        final refreshed = await _repo.refreshProduct(currentProduct);
        _updateProduct(refreshed.copyWith(isDownloading: false));
        if (refreshed.isImported || !refreshed.isPurchased) {
          await _pendingRepo.clearPending(productId);
        }
      }
    } finally {
      _resumeInProgress = false;
      ref.read(storeResumeInProgressProvider.notifier).setInProgress(false);
    }
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

