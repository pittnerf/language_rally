import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the set of product IDs currently in the shopping cart.
final cartProvider =
    NotifierProvider<CartNotifier, Set<String>>(CartNotifier.new);

/// Derived provider: number of items in the cart.
final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider).length);

class CartNotifier extends Notifier<Set<String>> {
  static const _storageKey = 'store_cart_product_ids';

  @override
  Set<String> build() {
    _loadFromStorage();
    return {};
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? const <String>[];
    state = stored.toSet();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state.toList());
  }

  void add(String productId) {
    state = {...state, productId};
    unawaited(_saveToStorage());
  }

  void remove(String productId) {
    state = state.difference({productId});
    unawaited(_saveToStorage());
  }

  void clear() {
    state = {};
    unawaited(_saveToStorage());
  }

  bool contains(String productId) => state.contains(productId);
}

