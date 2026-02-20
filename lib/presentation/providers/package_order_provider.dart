// lib/presentation/providers/package_order_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/package_order_repository.dart';
import '../../data/models/package_order.dart';

/// Provider for package order repository
final packageOrderRepositoryProvider = Provider<PackageOrderRepository>((ref) {
  return PackageOrderRepository();
});

/// Provider for current package order
final packageOrderProvider = FutureProvider<PackageOrder?>((ref) async {
  final repository = ref.watch(packageOrderRepositoryProvider);
  return await repository.getPackageOrder();
});

/// Provider for updating package order
final packageOrderNotifierProvider =
    NotifierProvider<PackageOrderNotifier, AsyncValue<PackageOrder?>>(
        () {
  return PackageOrderNotifier();
});

/// Notifier for managing package order state
class PackageOrderNotifier extends Notifier<AsyncValue<PackageOrder?>> {
  PackageOrderRepository get _repository => ref.read(packageOrderRepositoryProvider);

  @override
  AsyncValue<PackageOrder?> build() {
    _loadOrder();
    return const AsyncValue.loading();
  }

  Future<void> _loadOrder() async {
    state = const AsyncValue.loading();
    try {
      final order = await _repository.getPackageOrder();
      state = AsyncValue.data(order);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update the package order
  Future<void> updateOrder(List<String> packageIds) async {
    try {
      await _repository.updateOrder(packageIds);
      final newOrder = PackageOrder(
        packageIds: packageIds,
        lastModified: DateTime.now(),
      );
      state = AsyncValue.data(newOrder);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh the order from storage
  Future<void> refresh() async {
    await _loadOrder();
  }
}

