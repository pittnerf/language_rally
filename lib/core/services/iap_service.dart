import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart' as rc;
import '../../data/models/store_product.dart';
import '../../data/repositories/import_export_repository.dart';
import '../../data/repositories/language_package_group_repository.dart';
import '../../data/repositories/language_package_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/item_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../utils/debug_print.dart';

// ---------------------------------------------------------------------------
// ⚙️  Configuration — fill these in from your RevenueCat dashboard
// ---------------------------------------------------------------------------
const _kRevenueCatAndroidKey = 'YOUR_REVENUECAT_ANDROID_PUBLIC_KEY';
const _kRevenueCatIosKey     = 'YOUR_REVENUECAT_IOS_PUBLIC_KEY';
// ---------------------------------------------------------------------------

/// Result from [IAPService.purchaseAndDownload].
enum IAPResult { success, cancelled, alreadyOwned, error }

/// Central service for in-app purchases and content delivery.
///
/// Responsibilities:
///  1. Configure and initialise RevenueCat.
///  2. Expose available offerings/products.
///  3. Trigger a purchase, then download the ZIP from Firebase Storage and
///     import it into the local SQLite database.
///  4. Restore prior purchases.
///
/// Windows is not supported by RevenueCat; [isSupported] returns false there
/// and all purchase calls are no-ops that return [IAPResult.error].
class IAPService {
  static final IAPService instance = IAPService._();
  IAPService._();

  bool _initialised = false;

  /// True on Android and iOS, false on Windows/Linux/macOS (no IAP support yet).
  bool get isSupported => Platform.isAndroid || Platform.isIOS;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Call once during app startup (after Firebase is initialised).
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
      logDebug('✓ IAPService: RevenueCat initialised');
    } catch (e) {
      logDebug('⚠️ IAPService: initialisation failed — $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Product info from RevenueCat
  // ---------------------------------------------------------------------------

  /// Returns the current RevenueCat offering's package list.
  /// Each package wraps a store-level product (price, title, etc.).
  Future<List<rc.Package>> getAvailablePackages() async {
    if (!isSupported || !_initialised) return [];
    try {
      final offerings = await rc.Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (e) {
      logDebug('⚠️ IAPService: getOfferings failed — $e');
      return [];
    }
  }

  /// Returns the set of product IDs the current user has already purchased.
  Future<Set<String>> getPurchasedProductIds() async {
    if (!isSupported || !_initialised) return {};
    try {
      final info = await rc.Purchases.getCustomerInfo();
      // Active entitlements map 1-to-1 with product IDs in our setup
      return info.entitlements.active.keys.toSet();
    } catch (e) {
      logDebug('⚠️ IAPService: getCustomerInfo failed — $e');
      return {};
    }
  }

  // ---------------------------------------------------------------------------
  // Purchase + download + import pipeline
  // ---------------------------------------------------------------------------

  /// Purchases [product] via the store, then downloads the ZIP from Firebase
  /// Storage and imports it.
  ///
  /// [onProgress] receives download progress values 0.0 – 1.0.
  Future<IAPResult> purchaseAndDownload(
    StoreProduct product, {
    ValueChanged<double>? onProgress,
  }) async {
    if (!isSupported) {
      logDebug('⚠️ IAPService: IAP not supported on this platform');
      return IAPResult.error;
    }

    // ── 1. Find the matching RevenueCat package ────────────────────────────
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

    // ── 2. Trigger store purchase ──────────────────────────────────────────
    try {
      final customerInfo = await rc.Purchases.purchasePackage(rcPackage);
      final entitlementActive =
          customerInfo.entitlements.active.containsKey(product.productId);
      if (!entitlementActive) {
        logDebug('⚠️ IAPService: entitlement not active after purchase');
        return IAPResult.error;
      }
      logDebug('✓ IAPService: purchase successful for ${product.productId}');
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

    // ── 3. Download ZIP from Firebase Storage ──────────────────────────────
    try {
      final zipBytes = await _downloadFromStorage(
        product.storagePath,
        onProgress: onProgress,
      );
      await _importZip(zipBytes);
      logDebug('✓ IAPService: imported ${product.productId}');
      return IAPResult.success;
    } catch (e) {
      logDebug('⚠️ IAPService: download/import failed — $e');
      return IAPResult.error;
    }
  }

  /// Downloads a product that is already purchased (e.g. after restore or
  /// on a new device) but not yet in the local DB.
  Future<IAPResult> downloadPurchased(
    StoreProduct product, {
    ValueChanged<double>? onProgress,
  }) async {
    try {
      final zipBytes = await _downloadFromStorage(
        product.storagePath,
        onProgress: onProgress,
      );
      await _importZip(zipBytes);
      return IAPResult.success;
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

  Future<Uint8List> _downloadFromStorage(
    String storagePath, {
    ValueChanged<double>? onProgress,
  }) async {
    // ── 1. Call Cloud Function to get a signed URL ─────────────────────────
    // The function verifies the RevenueCat entitlement server-side before
    // issuing the URL, so the download is fully gated on a valid purchase.
    final callable = FirebaseFunctions.instance
        .httpsCallable('getPackageDownloadUrl');

    // RevenueCat user ID (anonymous ID if the user hasn't signed in)
    String rcUserId;
    try {
      final info = await rc.Purchases.getCustomerInfo();
      rcUserId = info.originalAppUserId;
    } catch (_) {
      rcUserId = 'anonymous';
    }

    final result = await callable.call<Map<String, dynamic>>({
      'productId': p.basenameWithoutExtension(storagePath)
          .replaceAll('pkg_', 'lang_pkg_'),
      'revenueCatUserId': rcUserId,
    });

    final downloadUrl = result.data['downloadUrl'] as String;

    // ── 2. Stream download to a temp file ─────────────────────────────────
    final tempDir = await getTemporaryDirectory();
    final fileName = p.basename(storagePath);
    final tempFile = File(p.join(tempDir.path, fileName));

    final request = http.Request('GET', Uri.parse(downloadUrl));
    final response = await request.send();
    final total = response.contentLength ?? 0;
    int received = 0;

    final sink = tempFile.openWrite();
    await response.stream.map((chunk) {
      received += chunk.length;
      if (total > 0) onProgress?.call(received / total);
      return chunk;
    }).pipe(sink);

    final bytes = await tempFile.readAsBytes();
    await tempFile.delete();
    return bytes;
  }

  Future<void> _importZip(Uint8List bytes) async {
    final packageRepo = LanguagePackageRepository();
    final importRepo = ImportExportRepository(
      packageRepo: packageRepo,
      groupRepo: LanguagePackageGroupRepository(),
      categoryRepo: CategoryRepository(),
      itemRepo: ItemRepository(),
    );
    await importRepo.importPackageFromZipBytesSeeding(bytes);
  }
}

