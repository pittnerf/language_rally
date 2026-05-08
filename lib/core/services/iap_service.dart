import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart' as rc;
import '../../data/models/store_product.dart';
import '../../data/repositories/import_export_repository.dart';
import '../../data/repositories/language_package_group_repository.dart';
import '../../data/repositories/language_package_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/item_repository.dart';
import '../utils/debug_print.dart';

// ---------------------------------------------------------------------------
// ⚙️  Configuration — fill these in from your RevenueCat dashboard
// ---------------------------------------------------------------------------
const _kRevenueCatAndroidKey = 'goog_gyAPWDNhOZyYfFcVXvxOvFCJhxp';
const _kRevenueCatIosKey     = 'YOUR_REVENUECAT_IOS_PUBLIC_KEY';
// ---------------------------------------------------------------------------

/// Result from [IAPService.purchaseAndDownload].
enum IAPResult { success, cancelled, alreadyOwned, error }

/// Central service for in-app purchases and content delivery.
///
/// Platform support:
///  • **Android** — Google Play via RevenueCat
///  • **iOS**     — App Store via RevenueCat
///  • **Windows / Linux / macOS** — not supported; [isSupported] returns false
///
/// After a successful purchase the ZIP is downloaded directly from
/// Firebase Storage and imported into the local SQLite database.
class IAPService {
  static final IAPService instance = IAPService._();
  IAPService._();

  bool _initialised = false;

  /// True on Android and iOS, false on Desktop platforms.
  bool get isSupported => Platform.isAndroid || Platform.isIOS;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Call once during app startup (after Firebase.initializeApp).
  Future<void> initialise({String? userId}) async {
    if (!isSupported || _initialised) return;
    try {
      final apiKey = Platform.isAndroid ? _kRevenueCatAndroidKey : _kRevenueCatIosKey;
      final config = rc.PurchasesConfiguration(apiKey);
      await rc.Purchases.configure(config);
      if (userId != null) {
        await rc.Purchases.logIn(userId);
      }
      _initialised = true;
      logDebug('✓ IAPService: RevenueCat initialised (${Platform.isAndroid ? "Android" : "iOS"})');
    } catch (e) {
      logDebug('⚠️ IAPService: initialisation failed — $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Product info from RevenueCat
  // ---------------------------------------------------------------------------

  /// Returns the current RevenueCat offering's package list.
  Future<List<rc.Package>> getAvailablePackages() async {
    if (!isSupported || !_initialised) {
      logDebug('⚠️ IAPService: getAvailablePackages skipped — isSupported=$isSupported, _initialised=$_initialised');
      return [];
    }
    try {
      final offerings = await rc.Purchases.getOfferings();

      // ── Debug: dump all offerings ──────────────────────────────────────────
      logDebug('🛍️ IAPService: all offerings count = ${offerings.all.length}');
      offerings.all.forEach((offeringId, offering) {
        logDebug('  offering "$offeringId": ${offering.availablePackages.length} package(s)');
        for (final pkg in offering.availablePackages) {
          logDebug(
            '    pkg "${pkg.identifier}" → productId="${pkg.storeProduct.identifier}"'
            ' price="${pkg.storeProduct.priceString}"',
          );
        }
      });

      final current = offerings.current;
      if (current == null) {
        logDebug('⚠️ IAPService: offerings.current is NULL — no default offering set in RevenueCat dashboard');
        logDebug('⚠️ IAPService: falling back to ALL offerings packages combined');
        // Collect all packages from all offerings as a fallback
        final allPackages = offerings.all.values
            .expand((o) => o.availablePackages)
            .toList();
        logDebug('✅ IAPService: fallback found ${allPackages.length} package(s) across all offerings');
        return allPackages;
      }
      logDebug('✅ IAPService: current offering "${current.identifier}" has ${current.availablePackages.length} package(s)');
      return current.availablePackages;
    } catch (e) {
      logDebug('⚠️ IAPService: getOfferings failed — $e');
      return [];
    }
  }

  /// Returns the set of product IDs the current user has already purchased.
  /// Includes both entitlement-based and non-consumable (allPurchasedProductIdentifiers).
  Future<Set<String>> getPurchasedProductIds() async {
    if (!isSupported || !_initialised) return {};
    try {
      final info = await rc.Purchases.getCustomerInfo();
      final activeEntitlements = info.entitlements.active.keys.toSet();
      final allPurchased = info.allPurchasedProductIdentifiers;
      logDebug('🛍️ IAPService: active entitlements (${activeEntitlements.length}): ${activeEntitlements.join(", ")}');
      logDebug('🛍️ IAPService: allPurchasedProductIdentifiers: ${allPurchased.toList().join(", ")}');
      // Combine both so non-consumables (no entitlement) are still detected
      return {...activeEntitlements, ...allPurchased};
    } catch (e) {
      logDebug('⚠️ IAPService: getCustomerInfo failed — $e');
      return {};
    }
  }

  // ---------------------------------------------------------------------------
  // Purchase + download + import pipeline
  // ---------------------------------------------------------------------------

  /// Purchases [product] via the platform store (Google Play / App Store),
  /// then downloads the ZIP from Firebase Storage and imports it.
  ///
  /// [onProgress] receives download progress values 0.0 – 1.0.
  /// [onDuplicate] is called when a local package with the same group name and
  /// package name already exists. Return `true` to overwrite it or `false` to
  /// abort the import.
  Future<IAPResult> purchaseAndDownload(
    StoreProduct product, {
    ValueChanged<double>? onProgress,
    Future<bool> Function(String groupName, String packageName)? onDuplicate,
  }) async {
    if (!isSupported) {
      logDebug('⚠️ IAPService: IAP not supported on this platform');
      return IAPResult.error;
    }

    // ── 1. Find the matching RevenueCat package ──────────────────────────
    final packages = await getAvailablePackages();
    rc.Package? rcPackage;
    for (final pkg in packages) {
      if (pkg.storeProduct.identifier == product.productId) {
        rcPackage = pkg;
        break;
      }
    }

    if (rcPackage == null) {
      logDebug('⚠️ IAPService: product ${product.productId} not found in offerings');
      return IAPResult.error;
    }

    // ── 2. Trigger store purchase (Google Play / App Store dialog) ───────
    try {
      final purchaseResult = await rc.Purchases.purchase(rc.PurchaseParams.package(rcPackage));
      final customerInfo = purchaseResult.customerInfo;

      // For non-consumables, check allPurchasedProductIdentifiers (entitlements
      // only work if an Entitlement is configured in RevenueCat dashboard).
      final purchased = customerInfo.allPurchasedProductIdentifiers
          .contains(product.productId);
      final entitlementActive =
          customerInfo.entitlements.active.containsKey(product.productId);

      if (!purchased && !entitlementActive) {
        logDebug('⚠️ IAPService: purchase not confirmed — productId not in purchased list or entitlements');
        return IAPResult.error;
      }
      logDebug('✓ IAPService: purchase successful for ${product.productId} (entitlement=$entitlementActive, purchased=$purchased)');
    } on rc.PurchasesErrorCode catch (code) {
      if (code == rc.PurchasesErrorCode.purchaseCancelledError) {
        return IAPResult.cancelled;
      }
      logDebug('⚠️ IAPService: purchase error — $code');
      return IAPResult.error;
    } catch (e) {
      logDebug('⚠️ IAPService: purchase exception — $e');
      return IAPResult.error;
    }

    // ── 3. Download ZIP from Firebase Storage and import ────────────────
    try {
      final zipBytes = await _downloadFromFirebaseStorage(
        product.storagePath,
        onProgress: onProgress,
      );
      final importResult = await _importZip(zipBytes, onDuplicate: onDuplicate);
      logDebug('✓ IAPService: import result for ${product.productId}: $importResult');
      return importResult;
    } catch (e) {
      logDebug('⚠️ IAPService: download/import failed — $e');
      return IAPResult.error;
    }
  }

  /// Downloads a product that was already purchased (e.g. after restore or
  /// on a new device) but is not yet in the local database.
  ///
  /// [onDuplicate] is called when a package with the same group name and
  /// package name already exists in the local database.  It receives the
  /// group name and package name of the conflicting package and should return
  /// `true` if the existing package should be overwritten or `false` to keep
  /// the existing package and abort the import.  When [onDuplicate] is `null`
  /// (e.g. during background resume) duplicates are silently skipped and
  /// [IAPResult.cancelled] is returned so the caller can clear the pending
  /// queue entry.
  Future<IAPResult> downloadPurchased(
    StoreProduct product, {
    ValueChanged<double>? onProgress,
    Future<bool> Function(String groupName, String packageName)? onDuplicate,
  }) async {
    try {
      final zipBytes = await _downloadFromFirebaseStorage(
        product.storagePath,
        onProgress: onProgress,
      );
      return await _importZip(zipBytes, onDuplicate: onDuplicate);
    } catch (e) {
      logDebug('⚠️ IAPService: downloadPurchased failed — $e');
      return IAPResult.error;
    }
  }

  // ---------------------------------------------------------------------------
  // Restore purchases
  // ---------------------------------------------------------------------------

  /// Restores all past purchases for the current user.
  /// Returns the set of restored product IDs.
  Future<Set<String>> restorePurchases() async {
    if (!isSupported || !_initialised) return {};
    try {
      final info = await rc.Purchases.restorePurchases();
      final ids = info.entitlements.active.keys.toSet();
      logDebug('✓ IAPService: restored ${ids.length} purchases');
      return ids;
    } catch (e) {
      logDebug('⚠️ IAPService: restorePurchases failed — $e');
      return {};
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Downloads a file from Firebase Storage using [storagePath] (relative to
  /// the default bucket, e.g. "packages/DE/pkg_en_de_A1_Animals.zip").
  ///
  /// The user must be signed in (anonymously or otherwise) so that Firebase
  /// Storage security rules can gate access to authenticated users.
  Future<Uint8List> _downloadFromFirebaseStorage(
    String storagePath, {
    ValueChanged<double>? onProgress,
  }) async {
    logDebug('⬇️  IAPService: downloading $storagePath from Firebase Storage');

    // Get a public download URL (requires auth if Storage rules require it)
    final ref = FirebaseStorage.instance.ref(storagePath);
    final downloadUrl = await ref.getDownloadURL();

    // Stream download for progress reporting
    final request = http.Request('GET', Uri.parse(downloadUrl));
    final response = await request.send();
    final total = response.contentLength ?? 0;
    int received = 0;

    final builder = BytesBuilder(copy: false);
    await response.stream.forEach((chunk) {
      received += chunk.length;
      builder.add(chunk);
      if (total > 0) onProgress?.call(received / total);
    });

    final bytes = builder.toBytes();
    logDebug('✓ IAPService: downloaded ${bytes.length} bytes from $storagePath');
    return bytes;
  }

  Future<IAPResult> _importZip(
    Uint8List bytes, {
    Future<bool> Function(String groupName, String packageName)? onDuplicate,
  }) async {
    final packageRepo = LanguagePackageRepository();
    final groupRepo = LanguagePackageGroupRepository();
    final importRepo = ImportExportRepository(
      packageRepo: packageRepo,
      groupRepo: groupRepo,
      categoryRepo: CategoryRepository(),
      itemRepo: ItemRepository(),
    );

    // ── Duplicate check ──────────────────────────────────────────────────────
    final existingPackage = await importRepo.checkDuplicateInZipBytes(bytes);
    if (existingPackage != null) {
      final group = await groupRepo.getGroupById(existingPackage.groupId);
      final groupName = group?.name ?? '';
      final packageName = existingPackage.packageName ?? '';

      if (onDuplicate == null) {
        // Background resume with no UI handler — skip silently so the
        // pending-queue entry is cleared and the user can decide manually.
        logDebug(
          '⚠️ IAPService: duplicate package "$packageName" in group "$groupName" found during background resume — skipping',
        );
        return IAPResult.cancelled;
      }

      final shouldOverwrite = await onDuplicate(groupName, packageName);
      if (!shouldOverwrite) {
        logDebug(
          '⚠️ IAPService: user chose to keep existing package "$packageName" — import aborted',
        );
        return IAPResult.cancelled;
      }

      // Delete the old package before importing the new one.
      logDebug(
        '🗑️  IAPService: overwriting existing package "${existingPackage.id}" ("$packageName" in "$groupName")',
      );
      await packageRepo.deletePackageWithAllData(existingPackage.id);
    }

    await importRepo.importPackageFromZipBytesSeeding(bytes);
    return IAPResult.success;
  }
}

