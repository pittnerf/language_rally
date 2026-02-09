// lib/data/repositories/package_order_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/package_order.dart';

/// Repository for managing the display order of language packages
class PackageOrderRepository {
  static const String _orderKey = 'package_display_order';

  /// Get the saved package order
  Future<PackageOrder?> getPackageOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = prefs.getString(_orderKey);

    if (orderJson == null) return null;

    try {
      final map = jsonDecode(orderJson) as Map<String, dynamic>;
      return PackageOrder.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Save the package order
  Future<void> savePackageOrder(PackageOrder order) async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = jsonEncode(order.toJson());
    await prefs.setString(_orderKey, orderJson);
  }

  /// Clear the saved order
  Future<void> clearPackageOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orderKey);
  }

  /// Update the order of packages
  Future<void> updateOrder(List<String> packageIds) async {
    final order = PackageOrder(
      packageIds: packageIds,
      lastModified: DateTime.now(),
    );
    await savePackageOrder(order);
  }
}

