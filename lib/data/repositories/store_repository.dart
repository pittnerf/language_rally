import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // The Firestore database was created with the named ID 'languagerally'
  // instead of the default '(default)', so we must reference it explicitly.
  final _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'languagerally',
  );
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
    // ── 1. Firestore catalog ───────────────────────────────────────────────
    // Fetch ALL documents and filter client-side so that documents without an
    // explicit `isActive` field (null/absent) are still included.
    // Only documents where isActive is explicitly `false` are excluded.
    final snapshot = await _col.get();
    logDebug('🛒 StoreRepository: fetched ${snapshot.docs.length} raw doc(s) from Firestore');

    final rawProducts = snapshot.docs
        .map((d) {
          try {
            return StoreProduct.fromFirestore(d.data());
          } catch (e) {
            logDebug('⚠️  StoreRepository: skipping malformed doc "${d.id}": $e');
            return null;
          }
        })
        .whereType<StoreProduct>()
        .where((p) => p.isActive)   // isActive defaults to true in fromFirestore
        .toList();

    logDebug('🛒 StoreRepository: ${rawProducts.length} active product(s) after filtering');

    // ── 2. RevenueCat packages (prices + purchase status) ─────────────────
    List rcPackages = [];
    Set<String> purchasedIds = {};
    try {
      rcPackages = await IAPService.instance.getAvailablePackages();
      purchasedIds = await IAPService.instance.getPurchasedProductIds();
    } catch (e) {
      // RevenueCat errors (e.g. invalid key) must not hide the catalog.
      logDebug('⚠️  StoreRepository: RevenueCat unavailable — $e');
    }

    // Build a price lookup map: productId → localizedPriceString
    final priceMap = <String, String>{};
    for (final pkg in rcPackages) {
      final id = pkg.storeProduct.identifier;
      final price = pkg.storeProduct.priceString;
      priceMap[id] = price;
      logDebug('🛍️ StoreRepository: RC package "$id" → price "$price"');
    }
    if (priceMap.isEmpty) {
      logDebug('⚠️ StoreRepository: priceMap is empty — RevenueCat returned no packages');
    }

    // ── 3. Local DB — which packages are already imported ─────────────────
    final allLocalPackages = await _packageRepo.getAllPackages();
    final importedNames =
        allLocalPackages.map((p) => p.packageName ?? '').toSet();

    // ── 4. Merge ──────────────────────────────────────────────────────────
    return rawProducts.map((product) {
      final matchedPrice = priceMap[product.productId];
      final alreadyPurchased = purchasedIds.contains(product.productId);
      final alreadyImported = importedNames.contains(product.title);
      logDebug(
        '🛒 StoreRepository: merging "${product.productId}"'
        ' — price=${matchedPrice ?? "NOT FOUND in RC"}'
        ' purchased=$alreadyPurchased'
        ' imported=$alreadyImported',
      );
      return product.copyWith(
        localizedPrice: matchedPrice,
        isPurchased: alreadyPurchased,
        isImported: alreadyImported,
      );
    }).toList();
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

