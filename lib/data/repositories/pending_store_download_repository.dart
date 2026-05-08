import 'package:shared_preferences/shared_preferences.dart';

/// Persists product IDs that still need download/import after purchase.
class PendingStoreDownloadRepository {
  static const _pendingIdsKey = 'pending_store_download_product_ids';

  Future<Set<String>> getPendingProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_pendingIdsKey) ?? const <String>[]).toSet();
  }

  Future<void> markPending(String productId) async {
    final ids = await getPendingProductIds();
    ids.add(productId);
    await _save(ids);
  }

  Future<void> clearPending(String productId) async {
    final ids = await getPendingProductIds();
    ids.remove(productId);
    await _save(ids);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingIdsKey);
  }

  Future<void> _save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pendingIdsKey, ids.toList());
  }
}

