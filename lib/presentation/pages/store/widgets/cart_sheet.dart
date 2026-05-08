import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../../core/services/iap_service.dart';
import '../../../../data/models/store_product.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/store_provider.dart';

/// Opens the shopping-cart bottom sheet modal.
Future<void> showCartSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _CartSheet(),
  );
}

class _CartSheet extends ConsumerWidget {
  const _CartSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cartIds = ref.watch(cartProvider);
    final catalogAsync = ref.watch(storeCatalogProvider);

    // Flat list of all products from the catalog.
    final allProducts = catalogAsync.value?.values
            .expand((list) => list)
            .toList() ??
        [];

    // Products whose IDs are in the cart.
    final cartItems = allProducts
        .where((p) => cartIds.contains(p.productId))
        .toList();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Column(
          children: [
            // ── Handle ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart_rounded,
                      color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.storeCartTitle,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (cartItems.isNotEmpty)
                    TextButton.icon(
                      onPressed: () =>
                          ref.read(cartProvider.notifier).clear(),
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                      label: Text(l.storeCartClearAll),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),

            // ── Cart items ──────────────────────────────────────────────────
            Expanded(
              child: cartItems.isEmpty
                  ? _EmptyCart(l: l)
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 4),
                      itemBuilder: (_, i) =>
                          _CartItemTile(product: cartItems[i], l: l),
                    ),
            ),

            // ── Checkout footer ─────────────────────────────────────────────
            if (cartItems.isNotEmpty)
              _CheckoutFooter(cartItems: cartItems, l: l),
          ],
        );
      },
    );
  }
}

// ── Cart item tile ─────────────────────────────────────────────────────────────

class _CartItemTile extends ConsumerWidget {
  final StoreProduct product;
  final AppLocalizations l;
  const _CartItemTile({required this.product, required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (product.localizedPrice != null)
              Text(
                product.localizedPrice!,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              tooltip: l.storeRemoveFromCart,
              iconSize: 20,
              color: colorScheme.error,
              visualDensity: VisualDensity.compact,
              onPressed: () =>
                  ref.read(cartProvider.notifier).remove(product.productId),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyCart({required this.l});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 56, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 12),
          Text(l.storeCartEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── Checkout footer ────────────────────────────────────────────────────────────

class _CheckoutFooter extends ConsumerStatefulWidget {
  final List<StoreProduct> cartItems;
  final AppLocalizations l;
  const _CheckoutFooter({required this.cartItems, required this.l});

  @override
  ConsumerState<_CheckoutFooter> createState() => _CheckoutFooterState();
}

class _CheckoutFooterState extends ConsumerState<_CheckoutFooter> {
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.l.storeCartItemCount(widget.cartItems.length),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (_purchasing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  FilledButton.icon(
                    onPressed: _checkout,
                    icon: const Icon(Icons.payment_rounded),
                    label: Text(widget.l.storeCartCheckout),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout() async {
    setState(() => _purchasing = true);
    final notifier = ref.read(storeCatalogProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);
    int successCount = 0;
    int failedCount = 0;
    bool cancelled = false;

    for (final product in List.of(widget.cartItems)) {
      if (!mounted) break;
      final result = await notifier.purchase(product);
      switch (result) {
        case IAPResult.success:
        case IAPResult.alreadyOwned:
          cartNotifier.remove(product.productId);
          successCount++;
          break;
        case IAPResult.cancelled:
          cancelled = true;
          break;
        case IAPResult.error:
          failedCount++;
          break;
      }

      if (cancelled) {
        break;
      }
    }

    if (mounted) {
      setState(() => _purchasing = false);
      if (failedCount == 0 && !cancelled) {
        Navigator.of(context).pop();
      }

      final messenger = ScaffoldMessenger.of(context);
      if (cancelled) {
        messenger.showSnackBar(
          SnackBar(content: Text(widget.l.storePurchaseCancelled)),
        );
      } else if (failedCount > 0) {
        messenger.showSnackBar(
          SnackBar(content: Text(widget.l.storePurchaseError)),
        );
      } else if (successCount > 0) {
        messenger.showSnackBar(
          SnackBar(content: Text(widget.l.storeCartCheckout)),
        );
      }
    }
  }
}

