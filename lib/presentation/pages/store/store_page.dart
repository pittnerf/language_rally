import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../core/services/iap_service.dart';
import '../../../data/models/store_product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/store_provider.dart';
import 'widgets/cart_sheet.dart';
import 'widgets/product_card.dart';

/// Store screen — browse and purchase language packages.
///
/// Groups products by language pair with filter chips for CEFR level and
/// language group.  On platforms where IAP is not supported (Windows/Linux)
/// a banner explains the limitation.
class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  String _searchQuery = '';
  String? _selectedLevel;  // null = all levels
  String? _selectedGroup;  // null = all language groups

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(storeCatalogProvider);
    final resumeInProgress = ref.watch(storeResumeInProgressProvider);
    final iapSupported = IAPService.instance.isSupported;
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.storeTitle),
        actions: [
          // ── Cart icon with badge ─────────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                tooltip: l.storeCartTitle,
                onPressed: () => showCartSheet(context),
              ),
              if (cartCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                          minWidth: 16, minHeight: 16),
                      child: Text(
                        '$cartCount',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (iapSupported)
            IconButton(
              icon: const Icon(Icons.restore_rounded),
              tooltip: l.storeRestorePurchases,
              onPressed: _restorePurchases,
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l.storeRefresh,
            onPressed: () => ref.read(storeCatalogProvider.notifier).reload(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              hintText: l.storeSearchHint,
              leading: const Icon(Icons.search_rounded),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (resumeInProgress) const _StoreResumeIndicator(),

          // Platform banner for unsupported platforms
          if (!iapSupported) _PlatformBanner(l: l),

          // Filter chips (level + language group)
          catalogAsync.maybeWhen(
            data: (grouped) => _FilterRow(
              grouped: grouped,
              selectedLevel: _selectedLevel,
              selectedGroup: _selectedGroup,
              l: l,
              onLevelChanged: (v) => setState(() => _selectedLevel = v),
              onGroupChanged: (v) => setState(() => _selectedGroup = v),
            ),
            orElse: () => const SizedBox.shrink(),
          ),

          // Catalog
          Expanded(
            child: catalogAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorView(
                message: e.toString(),
                l: l,
                onRetry: () => ref.read(storeCatalogProvider.notifier).reload(),
              ),
              data: (grouped) => _CatalogList(
                grouped: grouped,
                searchQuery: _searchQuery,
                selectedLevel: _selectedLevel,
                selectedGroup: _selectedGroup,
                iapSupported: iapSupported,
                l: l,
                onDownload: _download,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _download(StoreProduct product) async {
    final l = AppLocalizations.of(context)!;
    final result = await ref.read(storeCatalogProvider.notifier).downloadPurchased(
      product,
      onDuplicate: (groupName, packageName) => _showOverwriteDialog(
        groupName: groupName,
        packageName: packageName,
        l: l,
      ),
    );
    if (!mounted) return;
    _showResultSnackbar(result, product.title, l);
  }

  /// Shows a confirmation dialog when a duplicate package is detected.
  /// Returns `true` if the user wants to overwrite the existing package.
  Future<bool> _showOverwriteDialog({
    required String groupName,
    required String packageName,
    required AppLocalizations l,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.storePackageDuplicateTitle),
        content: Text(
          l.storePackageDuplicateMessage(packageName, groupName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.storePackageDuplicateKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.storePackageDuplicateOverwrite),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _restorePurchases() async {
    final l = AppLocalizations.of(context)!;
    await ref.read(storeCatalogProvider.notifier).restorePurchases();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.storePurchasesRestored)));
  }

  void _showResultSnackbar(IAPResult result, String title, AppLocalizations l) {
    final msg = switch (result) {
      IAPResult.success      => l.storePurchaseSuccess(title),
      IAPResult.cancelled    => l.storePurchaseCancelled,
      IAPResult.alreadyOwned => l.storePurchaseAlreadyOwned(title),
      IAPResult.error        => l.storePurchaseError,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _StoreResumeIndicator extends StatelessWidget {
  const _StoreResumeIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.secondaryContainer,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2),
          LinearProgressIndicator(minHeight: 2),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}

// ── Filter row ─────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final Map<String, List<StoreProduct>> grouped;
  final String? selectedLevel;
  final String? selectedGroup;
  final AppLocalizations l;
  final void Function(String?) onLevelChanged;
  final void Function(String?) onGroupChanged;

  const _FilterRow({
    required this.grouped,
    required this.selectedLevel,
    required this.selectedGroup,
    required this.l,
    required this.onLevelChanged,
    required this.onGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    final levels = grouped.values
        .expand((list) => list)
        .map((p) => p.level)
        .where((lv) => lv.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    if (levels.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              FilterChip(
                label: Text(l.storeAllLevels),
                selected: selectedLevel == null,
                onSelected: (_) => onLevelChanged(null),
              ),
              const SizedBox(width: 6),
              ...levels.map((lv) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(lv),
                      selected: selectedLevel == lv,
                      onSelected: (_) =>
                          onLevelChanged(selectedLevel == lv ? null : lv),
                    ),
                  )),
            ],
          ),
        ),
        // Language-group chips (only when there are multiple groups)
        if (grouped.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12)
                .copyWith(bottom: 6),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l.storeAllGroups),
                  selected: selectedGroup == null,
                  onSelected: (_) => onGroupChanged(null),
                ),
                const SizedBox(width: 6),
                ...grouped.keys.map((g) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(g),
                        selected: selectedGroup == g,
                        onSelected: (_) =>
                            onGroupChanged(selectedGroup == g ? null : g),
                      ),
                    )),
              ],
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}

// ── Catalog list ───────────────────────────────────────────────────────────────

class _CatalogList extends ConsumerWidget {
  final Map<String, List<StoreProduct>> grouped;
  final String searchQuery;
  final String? selectedLevel;
  final String? selectedGroup;
  final bool iapSupported;
  final AppLocalizations l;
  final void Function(StoreProduct) onDownload;

  const _CatalogList({
    required this.grouped,
    required this.searchQuery,
    required this.selectedLevel,
    required this.selectedGroup,
    required this.iapSupported,
    required this.l,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    // Apply group filter
    var display = selectedGroup != null
        ? <String, List<StoreProduct>>{
            selectedGroup!: grouped[selectedGroup!] ?? []
          }
        : Map<String, List<StoreProduct>>.from(grouped);

    // Apply level filter
    if (selectedLevel != null) {
      display = display.map((key, list) => MapEntry(
            key,
            list.where((p) => p.level == selectedLevel).toList(),
          ));
    }

    // Apply search
    final q = searchQuery.toLowerCase();
    if (q.isNotEmpty) {
      display = display.map((key, list) => MapEntry(
            key,
            list
                .where((p) =>
                    p.title.toLowerCase().contains(q) ||
                    p.groupName.toLowerCase().contains(q) ||
                    p.level.toLowerCase().contains(q) ||
                    p.description.toLowerCase().contains(q))
                .toList(),
          ));
    }

    // Remove empty groups
    display.removeWhere((_, list) => list.isEmpty);

    if (display.isEmpty) {
      return Center(
        child: Text(
          q.isNotEmpty
              ? l.storeNoPackagesMatchSearch
              : l.storeNoPackagesAvailable,
        ),
      );
    }

    final groups = display.entries.toList();
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (_, i) {
        final group = groups[i];
        return _GroupSection(
          groupName: group.key,
          products: group.value,
          l: l,
          cardBuilder: (product) => ProductCard(
            product: product,
            l: l,
            isInCart: cart.contains(product.productId),
            onAddToCart: (iapSupported &&
                    !product.isPurchased &&
                    !product.isImported)
                ? () => ref
                    .read(cartProvider.notifier)
                    .add(product.productId)
                : null,
            onRemoveFromCart: (iapSupported &&
                    !product.isPurchased &&
                    !product.isImported)
                ? () => ref
                    .read(cartProvider.notifier)
                    .remove(product.productId)
                : null,
            onDownload: (product.isPurchased &&
                    !product.isImported &&
                    !product.isDownloading)
                ? () => onDownload(product)
                : null,
          ),
        );
      },
    );
  }
}

// ── Group section ──────────────────────────────────────────────────────────────

class _GroupSection extends StatefulWidget {
  final String groupName;
  final List<StoreProduct> products;
  final AppLocalizations l;
  final Widget Function(StoreProduct) cardBuilder;

  const _GroupSection({
    required this.groupName,
    required this.products,
    required this.l,
    required this.cardBuilder,
  });

  @override
  State<_GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<_GroupSection> {
  // Start expanded so products are visible immediately without requiring a tap.
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final installedCount = widget.products.where((p) => p.isImported).length;

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.groupName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.l
                        .storeInstalledCount(installedCount, widget.products.length),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
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
        if (_expanded) ...widget.products.map(widget.cardBuilder),
      ],
    );
  }
}

// ── Platform banner ────────────────────────────────────────────────────────────

class _PlatformBanner extends StatefulWidget {
  final AppLocalizations l;
  const _PlatformBanner({required this.l});

  @override
  State<_PlatformBanner> createState() => _PlatformBannerState();
}

class _PlatformBannerState extends State<_PlatformBanner> {
  bool _dismissed = false;

  String get _platformName {
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    return 'Desktop';
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    return MaterialBanner(
      padding: const EdgeInsets.all(12),
      content: Text(
          '${widget.l.storeIapNotAvailableMessage} ($_platformName)'),
      leading: const Icon(Icons.info_outline_rounded),
      actions: [
        TextButton(
          onPressed: () {/* TODO: open web store URL */},
          child: Text(widget.l.storeOpenWebsite),
        ),
        TextButton(
          onPressed: () => setState(() => _dismissed = true),
          child: Text(widget.l.storeDismiss),
        ),
      ],
    );
  }
}

// ── Error view ─────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final AppLocalizations l;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.l,
    required this.onRetry,
  });

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
            Text(l.storeLoadErrorTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.storeRetry),
            ),
          ],
        ),
      ),
    );
  }
}
