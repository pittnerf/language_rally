import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/iap_service.dart';
import '../../../data/models/store_product.dart';
import '../../providers/store_provider.dart';
import 'widgets/product_card.dart';

/// Store screen — browse and purchase language packages.
///
/// Shows a grouped list of [StoreProduct]s fetched from Firestore, with
/// price and purchase status from RevenueCat.
///
/// On platforms where IAP is not supported (Windows) a "coming soon" banner
/// is shown instead of the buy buttons.
class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(storeCatalogProvider);
    final iapSupported = IAPService.instance.isSupported;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Package Store'),
        actions: [
          if (iapSupported)
            IconButton(
              icon: const Icon(Icons.restore_rounded),
              tooltip: 'Restore purchases',
              onPressed: _restorePurchases,
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(storeCatalogProvider.notifier).reload(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              hintText: 'Search packages…',
              leading: const Icon(Icons.search_rounded),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Platform banner for Windows
          if (!iapSupported) const _WindowsBanner(),

          Expanded(
            child: catalogAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorView(
                message: e.toString(),
                onRetry: () =>
                    ref.read(storeCatalogProvider.notifier).reload(),
              ),
              data: (grouped) => _CatalogList(
                grouped: grouped,
                searchQuery: _searchQuery,
                iapSupported: iapSupported,
                onBuy: _buy,
                onDownload: _download,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _buy(StoreProduct product) async {
    final result =
        await ref.read(storeCatalogProvider.notifier).purchase(product);
    if (!mounted) return;
    _showResultSnackbar(result, product.title);
  }

  Future<void> _download(StoreProduct product) async {
    final result = await ref
        .read(storeCatalogProvider.notifier)
        .downloadPurchased(product);
    if (!mounted) return;
    _showResultSnackbar(result, product.title);
  }

  Future<void> _restorePurchases() async {
    await ref.read(storeCatalogProvider.notifier).restorePurchases();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Purchases restored')),
    );
  }

  void _showResultSnackbar(IAPResult result, String title) {
    final msg = switch (result) {
      IAPResult.success   => '$title installed successfully!',
      IAPResult.cancelled => 'Purchase cancelled.',
      IAPResult.alreadyOwned => '$title is already installed.',
      IAPResult.error     => 'Something went wrong. Please try again.',
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _CatalogList extends StatelessWidget {
  final Map<String, List<StoreProduct>> grouped;
  final String searchQuery;
  final bool iapSupported;
  final void Function(StoreProduct) onBuy;
  final void Function(StoreProduct) onDownload;

  const _CatalogList({
    required this.grouped,
    required this.searchQuery,
    required this.iapSupported,
    required this.onBuy,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final q = searchQuery.toLowerCase();

    // Filter + flatten for search; otherwise keep grouping
    if (q.isNotEmpty) {
      final matches = grouped.values
          .expand((list) => list)
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.groupName.toLowerCase().contains(q) ||
              p.level.toLowerCase().contains(q))
          .toList();

      if (matches.isEmpty) {
        return const Center(child: Text('No packages match your search.'));
      }
      return ListView.builder(
        itemCount: matches.length,
        itemBuilder: (_, i) => _buildCard(matches[i]),
      );
    }

    // Grouped display
    final groups = grouped.entries.toList();
    if (groups.isEmpty) {
      return const Center(child: Text('No packages available.'));
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (_, i) {
        final group = groups[i];
        return _GroupSection(
          groupName: group.key,
          products: group.value,
          cardBuilder: _buildCard,
        );
      },
    );
  }

  Widget _buildCard(StoreProduct product) {
    return ProductCard(
      product: product,
      onBuy: (iapSupported && !product.isPurchased && !product.isImported)
          ? () => onBuy(product)
          : null,
      onDownload:
          (product.isPurchased && !product.isImported && !product.isDownloading)
              ? () => onDownload(product)
              : null,
    );
  }
}

class _GroupSection extends StatefulWidget {
  final String groupName;
  final List<StoreProduct> products;
  final Widget Function(StoreProduct) cardBuilder;

  const _GroupSection({
    required this.groupName,
    required this.products,
    required this.cardBuilder,
  });

  @override
  State<_GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<_GroupSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final purchasedCount =
        widget.products.where((p) => p.isImported).length;

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.groupName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '$purchasedCount / ${widget.products.length} installed',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(_expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        if (_expanded)
          ...widget.products.map(widget.cardBuilder),
      ],
    );
  }
}

class _WindowsBanner extends StatelessWidget {
  const _WindowsBanner();

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      padding: const EdgeInsets.all(12),
      content: const Text(
        'In-app purchases are not available on Windows. '
        'Visit our website to purchase packages.',
      ),
      leading: const Icon(Icons.info_outline_rounded),
      actions: [
        TextButton(
          onPressed: () {/* TODO: open web store URL */},
          child: const Text('Open website'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: 16),
            Text('Could not load the store.',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

