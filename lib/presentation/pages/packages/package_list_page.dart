// lib/presentation/pages/packages/package_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/language_package.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../widgets/package_icon.dart';
import '../../providers/package_order_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package_form_page.dart';

/// Package list page displaying all language packages as cards
class PackageListPage extends ConsumerStatefulWidget {
  const PackageListPage({super.key});

  @override
  ConsumerState<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends ConsumerState<PackageListPage> {
  List<LanguagePackage> _packages = [];
  bool _isLoading = true;
  final _packageRepo = LanguagePackageRepository();
  final _categoryRepo = CategoryRepository();

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _toggleCompactMode(LanguagePackage package) async {
    // Update in database
    final updatedPackage = package.copyWith(isCompactView: !package.isCompactView);
    await _packageRepo.updatePackage(updatedPackage);

    // Update local state
    setState(() {
      final index = _packages.indexWhere((p) => p.id == package.id);
      if (index != -1) {
        _packages[index] = updatedPackage;
      }
    });
  }

  Future<void> _loadPackages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load packages from repository
      final packages = await _packageRepo.getAllPackages();

      setState(() {
        _packages = packages;
        _isLoading = false;
      });

      await _applySavedOrder();
    } catch (e) {
      debugPrint('Error loading packages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _applySavedOrder() async {
    if (_packages.isEmpty) return;

    final orderAsync = ref.read(packageOrderNotifierProvider);
    orderAsync.whenData((order) {
      if (order != null && order.packageIds.isNotEmpty) {
        setState(() {
          _packages = _reorderPackages(_packages, order.packageIds);
        });
      }
    });
  }

  List<LanguagePackage> _reorderPackages(
      List<LanguagePackage> packages, List<String> orderedIds) {
    final packageMap = {for (var p in packages) p.id: p};
    final reordered = <LanguagePackage>[];

    // Add packages in saved order
    for (final id in orderedIds) {
      if (packageMap.containsKey(id)) {
        reordered.add(packageMap[id]!);
        packageMap.remove(id);
      }
    }

    // Add any new packages not in saved order
    reordered.addAll(packageMap.values);

    return reordered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language Packages',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPackages,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PackageFormPage(),
                ),
              );
              // Reload packages if a package was created
              if (result == true) {
                _loadPackages();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppTheme.spacing16),
                  Text('Loading packages...'),
                ],
              ),
            )
          : _packages.isEmpty
              ? _buildEmptyState()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine if we should use multi-column layout (landscape mode)
                    final bool isLandscape = constraints.maxWidth > 600;
                    final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;

                    return Column(
                      children: [
                        Expanded(
                          child: isLandscape
                              ? _buildGridView(crossAxisCount)
                              : _buildListView(),
                        ),
                        // Hint for drag and drop
                        _buildHintBar(context, isLandscape),
                      ],
                    );
                  },
                ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final package = _packages.removeAt(oldIndex);
      _packages.insert(newIndex, package);
    });

    // Save the new order
    final packageIds = _packages.map((p) => p.id).toList();
    ref.read(packageOrderNotifierProvider.notifier).updateOrder(packageIds);
  }

  Widget _buildListView() {
    return ReorderableListView.builder(
      padding: EdgeInsets.all(AppTheme.spacing16),
      itemCount: _packages.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final package = _packages[index];

        return PackageCard(
          key: ValueKey(package.id),
          package: package,
          index: index,
          isCompact: package.isCompactView,
          onTap: () => _onPackageTap(package),
          onToggleCompact: () => _toggleCompactMode(package),
          showToggleButton: true, // Show toggle button in portrait/list mode
        );
      },
    );
  }

  Widget _buildGridView(int crossAxisCount) {
    return ReorderableGridView.builder(
      padding: EdgeInsets.all(AppTheme.spacing16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.spacing16,
        mainAxisSpacing: AppTheme.spacing16,
        childAspectRatio: 1.2, // Adjusted for content that may expand
      ),
      itemCount: _packages.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final package = _packages[index];

        return PackageCard(
          key: ValueKey(package.id),
          package: package,
          index: index,
          isCompact: false, // Always expanded in landscape/grid mode
          onTap: () => _onPackageTap(package),
          onToggleCompact: () => _toggleCompactMode(package),
          isInGrid: true,
          showToggleButton: false, // Hide toggle button in landscape/grid mode
        );
      },
    );
  }

  Widget _buildHintBar(BuildContext context, bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppTheme.spacing8),
          Flexible(
            child: Text(
              isLandscape
                  ? 'Tap and hold to reorder cards'
                  : 'Tap and hold ≡ to reorder • Tap ⋮ to toggle compact view',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: AppTheme.spacing16),
          Text(
            'No packages yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Create your first language package',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  void _onPackageTap(LanguagePackage package) async {
    // Only allow editing user-created packages
    if (package.packageType == PackageType.userCreated && !package.isReadonly && !package.isPurchased) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PackageFormPage(package: package),
        ),
      );
      // Reload packages if changes were made
      if (result == true) {
        _loadPackages();
      }
    } else {
      // TODO: Navigate to package detail/view for non-editable packages
      debugPrint('Tapped package: ${package.id}');
    }
  }
}

/// Card widget displaying a language package
class PackageCard extends StatelessWidget {
  final LanguagePackage package;
  final int index;
  final bool isCompact;
  final VoidCallback onTap;
  final VoidCallback onToggleCompact;
  final bool isInGrid;
  final bool showToggleButton;

  const PackageCard({
    required Key key,
    required this.package,
    required this.index,
    required this.isCompact,
    required this.onTap,
    required this.onToggleCompact,
    this.isInGrid = false,
    this.showToggleButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: isInGrid ? EdgeInsets.zero : EdgeInsets.only(bottom: AppTheme.spacing16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: isCompact ? _buildCompactCard(context) : _buildExpandedCard(context),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompactHeader(context),
          if (package.description != null && package.description!.isNotEmpty)
            _buildCompactDescription(context),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Row(
      children: [
        if (!isInGrid) _buildDragHandle(context, size: 20),
        if (!isInGrid) SizedBox(width: AppTheme.spacing8),
        _buildPackageIcon(size: 32),
        SizedBox(width: AppTheme.spacing8),
        _buildLanguageInfo(context, isCompact: true),
        if (package.isPurchased) _buildCompactPurchasedBadge(context),
        if (showToggleButton) _buildToggleButton(context, isExpanded: false),
      ],
    );
  }

  Widget _buildCompactDescription(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.spacing8,
        left: !isInGrid ? 48.0 : 0,
      ),
      child: Text(
        package.description!,
        style: theme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCompactPurchasedBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(right: AppTheme.spacing4),
      child: Icon(
        Icons.shopping_bag,
        size: 18,
        color: colorScheme.tertiary,
      ),
    );
  }

  Widget _buildExpandedCard(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildExpandedHeader(context),
        if (package.description != null && package.description!.isNotEmpty)
          _buildExpandedDescription(context),
        if (_hasAuthorInfo()) _buildExpandedAuthorSection(context),
        _buildExpandedVersion(context),
      ],
    );

    return isInGrid
        ? SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.spacing16),
            child: content,
          )
        : Padding(
            padding: EdgeInsets.all(AppTheme.spacing16),
            child: content,
          );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    return Row(
      children: [
        if (!isInGrid) _buildDragHandle(context, size: 24),
        if (!isInGrid) SizedBox(width: AppTheme.spacing12),
        _buildPackageIcon(size: 48),
        SizedBox(width: AppTheme.spacing12),
        _buildLanguageInfo(context, isCompact: false),
        if (package.isPurchased) _buildExpandedPurchasedBadge(context),
        if (showToggleButton) SizedBox(width: AppTheme.spacing8),
        if (showToggleButton) _buildToggleButton(context, isExpanded: true),
      ],
    );
  }

  Widget _buildExpandedDescription(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing12),
      child: Text(
        package.description!,
        style: theme.textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpandedAuthorSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing12),
      child: _buildAuthorInfo(context, package),
    );
  }

  Widget _buildExpandedVersion(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing12),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppTheme.spacing4),
          Text(
            'Version ${package.version}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildExpandedPurchasedBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag,
            size: 14,
            color: colorScheme.onTertiaryContainer,
          ),
          SizedBox(width: AppTheme.spacing4),
          Text(
            'Purchased',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasAuthorInfo() {
    return package.authorName != null ||
        package.authorEmail != null ||
        package.authorWebpage != null;
  }

  // Shared UI Components
  Widget _buildDragHandle(BuildContext context, {required double size}) {
    final colorScheme = Theme.of(context).colorScheme;
    return ReorderableDragStartListener(
      index: index,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(
          Icons.drag_handle,
          color: colorScheme.onSurfaceVariant,
          size: size,
        ),
      ),
    );
  }

  Widget _buildPackageIcon({required double size}) {
    return PackageIcon(
      iconPath: package.icon,
      size: size,
    );
  }

  Widget _buildLanguageInfo(BuildContext context, {required bool isCompact}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${package.languageCode1.toUpperCase()} → ${package.languageCode2.toUpperCase()}',
            style: (isCompact
                    ? theme.textTheme.titleSmall
                    : theme.textTheme.titleMedium)
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isCompact) SizedBox(height: AppTheme.spacing4),
          Text(
            '${package.languageName1} → ${package.languageName2}',
            style: (isCompact
                    ? theme.textTheme.labelLarge
                    : theme.textTheme.bodySmall)
                ?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, {required bool isExpanded}) {
    return IconButton(
      icon: Icon(
        isExpanded ? Icons.unfold_less : Icons.unfold_more,
        size: 20,
      ),
      onPressed: onToggleCompact,
      tooltip: isExpanded ? 'Compact view' : 'Expand',
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  Widget _buildAuthorInfo(BuildContext context, LanguagePackage package) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (package.authorName != null)
            _buildAuthorName(context, package.authorName!),
          if (package.authorEmail != null)
            _buildAuthorEmail(context, package.authorEmail!,
                hasNameAbove: package.authorName != null),
          if (package.authorWebpage != null)
            _buildAuthorWebpage(context, package.authorWebpage!,
                hasContentAbove: package.authorName != null || package.authorEmail != null),
        ],
      ),
    );
  }

  Widget _buildAuthorName(BuildContext context, String name) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorEmail(BuildContext context, String email, {required bool hasNameAbove}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        if (hasNameAbove) SizedBox(height: AppTheme.spacing4),
        InkWell(
          onTap: () => _launchEmail(email),
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: colorScheme.primary,
              ),
              SizedBox(width: AppTheme.spacing4),
              Expanded(
                child: Text(
                  email,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorWebpage(BuildContext context, String webpage, {required bool hasContentAbove}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        if (hasContentAbove) SizedBox(height: AppTheme.spacing4),
        InkWell(
          onTap: () => _launchUrl(webpage),
          child: Row(
            children: [
              Icon(
                Icons.link,
                size: 14,
                color: colorScheme.primary,
              ),
              SizedBox(width: AppTheme.spacing4),
              Expanded(
                child: Text(
                  webpage,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

