import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/store_product.dart';
import '../../../core/services/iap_service.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../core/utils/debug_print.dart';

/// Fetches the product catalog from Firestore and merges runtime state:
///  • localised price from RevenueCat
///  • purchase status from RevenueCat entitlements
///  • import status from the local SQLite database
///
/// Firestore collection: `store_products`
/// Each document ID = `productId` and contains the fields defined in
/// [StoreProduct.fromFirestore].
class StoreRepository {
  final _firestore = FirebaseFirestore.instance;
  final _packageRepo = LanguagePackageRepository();

  // ── Firestore collection ref ───────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('store_products');

  // ---------------------------------------------------------------------------
  // Catalog
  // ---------------------------------------------------------------------------

  /// Returns all active products from Firestore, enriched with:
  ///  - localized prices from RevenueCat
  ///  - purchase status from RevenueCat entitlements
  ///  - local import status from SQLite
  Future<List<StoreProduct>> getCatalog() async {
    try {
      // ── 1. Firestore catalog ─────────────────────────────────────────────
      final snapshot =
          await _col.where('isActive', isEqualTo: true).get();
      final rawProducts = snapshot.docs
          .map((d) => StoreProduct.fromFirestore(d.data()))
          .toList();

      // ── 2. RevenueCat packages (prices + purchase status) ────────────────
      final rcPackages = await IAPService.instance.getAvailablePackages();
      final purchasedIds = await IAPService.instance.getPurchasedProductIds();

      // Build a price lookup map: productId → localizedPriceString
      final priceMap = <String, String>{};
      for (final pkg in rcPackages) {
        priceMap[pkg.storeProduct.identifier] = pkg.storeProduct.priceString;
      }

      // ── 3. Local DB — which packages are already imported ────────────────
      final allLocalPackages = await _packageRepo.getAllPackages();
      final importedNames =
          allLocalPackages.map((p) => p.packageName ?? '').toSet();

      // ── 4. Merge ─────────────────────────────────────────────────────────
      return rawProducts.map((product) {
        return product.copyWith(
          localizedPrice: priceMap[product.productId],
          isPurchased: purchasedIds.contains(product.productId),
          isImported: importedNames.contains(product.title),
        );
      }).toList();
    } catch (e) {
      logDebug('⚠️ StoreRepository.getCatalog failed: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Grouped catalog (for UI sections)
  // ---------------------------------------------------------------------------

  /// Returns the catalog grouped by [StoreProduct.groupName], sorted by key.
  Future<Map<String, List<StoreProduct>>> getCatalogByGroup() async {
    final products = await getCatalog();
    final grouped = <String, List<StoreProduct>>{};
    for (final p in products) {
      grouped.putIfAbsent(p.groupName, () => []).add(p);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  // ---------------------------------------------------------------------------
  // Single product refresh (after purchase / download)
  // ---------------------------------------------------------------------------

  /// Re-fetches a single product's runtime state (purchase + import status).
  Future<StoreProduct> refreshProduct(StoreProduct product) async {
    try {
      final purchasedIds = await IAPService.instance.getPurchasedProductIds();
      final allLocalPackages = await _packageRepo.getAllPackages();
      final importedNames =
          allLocalPackages.map((p) => p.packageName ?? '').toSet();
      return product.copyWith(
        isPurchased: purchasedIds.contains(product.productId),
        isImported: importedNames.contains(product.title),
      );
    } catch (e) {
      logDebug('⚠️ StoreRepository.refreshProduct failed: $e');
      return product;
    }
  }
}

