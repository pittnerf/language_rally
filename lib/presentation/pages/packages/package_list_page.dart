// lib/presentation/pages/packages/package_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/badge_helper.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/language_package_group.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/language_package_group_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/import_export_repository.dart';
import '../../../data/repositories/training_statistics_repository.dart';
import '../../widgets/package_icon.dart';
import '../../widgets/badge_widget.dart';
import '../../providers/package_order_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package_form_page.dart';
import 'package_group_admin_page.dart';
import '../items/item_browser_page.dart';
import '../../../l10n/app_localizations.dart';

/// Package list page displaying all language packages as cards
class PackageListPage extends ConsumerStatefulWidget {
  const PackageListPage({super.key});

  @override
  ConsumerState<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends ConsumerState<PackageListPage> {
  List<LanguagePackage> _packages = [];
  List<LanguagePackageGroup> _groups = [];
  LanguagePackageGroup? _selectedGroup;
  bool _isLoading = true;
  final _packageRepo = LanguagePackageRepository();
  final _groupRepo = LanguagePackageGroupRepository();
  final _categoryRepo = CategoryRepository();
  final _itemRepo = ItemRepository();
  late final ImportExportRepository _importExportRepo;

  @override
  void initState() {
    super.initState();
    _importExportRepo = ImportExportRepository(
      packageRepo: _packageRepo,
      groupRepo: _groupRepo,
      categoryRepo: _categoryRepo,
      itemRepo: _itemRepo,
    );
    _loadGroupsAndPackages();
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

  Future<void> _loadGroupsAndPackages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all groups
      final groups = await _groupRepo.getAllGroups();

      setState(() {
        _groups = groups;

        // Validate that the currently selected group still exists
        if (_selectedGroup != null) {
          final groupStillExists = _groups.any((g) => g.id == _selectedGroup!.id);
          if (!groupStillExists) {
            // Selected group was deleted, reset to first available group
            _selectedGroup = _groups.isNotEmpty ? _groups.first : null;
          } else {
            // Update the selected group object to the one from the new list
            _selectedGroup = _groups.firstWhere((g) => g.id == _selectedGroup!.id);
          }
        } else {
          // No group selected yet, select first group by default if available
          if (_groups.isNotEmpty) {
            _selectedGroup = _groups.first;
          }
        }
      });

      // Load packages for selected group
      await _loadPackages();
    } catch (e) {
      debugPrint('Error loading groups and packages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPackages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load packages from repository - filtered by selected group
      final packages = _selectedGroup != null
          ? await _packageRepo.getPackagesByGroupId(_selectedGroup!.id)
          : await _packageRepo.getAllPackages();

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

  void _onGroupChanged(LanguagePackageGroup? newGroup) {
    if (newGroup != null && newGroup.id != _selectedGroup?.id) {
      setState(() {
        _selectedGroup = newGroup;
      });
      _loadPackages();
    }
  }

  Future<void> _openGroupAdminPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PackageGroupAdminPage(),
      ),
    );

    // Refresh the entire page when returning from group admin
    await _loadGroupsAndPackages();
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
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // Consider 600dp+ as tablet

    return Scaffold(
      appBar: isTablet ? AppBar(
        title: Text(
          l10n.languagePackages,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGroupsAndPackages,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewPackage,
          ),
        ],
      ) : null,
      body: SafeArea(
        child: Column(
          children: [
            // Group filter dropdown
            if (_groups.isNotEmpty) _buildGroupFilter(context),
            // Main content
            Expanded(
              child: _buildMainContent(l10n),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'createPackage',
            onPressed: _createNewPackage,
            tooltip: l10n.createNewPackage,
            child: const Icon(Icons.add),
          ),
          SizedBox(width: AppTheme.spacing8),
          FloatingActionButton.extended(
            heroTag: 'importPackage',
            onPressed: _importPackageFromZip,
            icon: const Icon(Icons.file_upload),
            label: Text(l10n.importPackage),
            tooltip: l10n.importPackageTooltip,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupFilter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppTheme.spacing8),
          Text(
            'Group:',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: DropdownButton<LanguagePackageGroup>(
              value: _selectedGroup,
              isExpanded: true,
              isDense: false,
              underline: Container(
                height: 1,
                color: colorScheme.outline,
              ),
              items: _groups.map((group) {
                return DropdownMenuItem<LanguagePackageGroup>(
                  value: group,
                  child: Text(
                    group.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }).toList(),
              onChanged: _onGroupChanged,
            ),
          ),
          SizedBox(width: AppTheme.spacing8),
          ElevatedButton.icon(
            onPressed: _openGroupAdminPage,
            icon: Icon(Icons.settings, size: 18),
            label: Text('Amend'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(AppLocalizations l10n) {
    if (_isLoading) {
      return _buildLoadingState(l10n);
    }

    if (_packages.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLandscape = constraints.maxWidth > 600;
        final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;

        return Column(
          children: [
            Expanded(
              child: isLandscape
                  ? _buildGridView(crossAxisCount, constraints.maxHeight)
                  : _buildListView(),
            ),
            _buildHintBar(context, isLandscape),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppTheme.spacing8),
          Text(l10n.loadingPackages, style: TextStyle(fontSize: 14)),
        ],
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
      padding: EdgeInsets.all(AppTheme.spacing8),
      physics: const AlwaysScrollableScrollPhysics(),
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
          onDelete: package.isPurchased ? () => _deletePackage(package) : null,
          showToggleButton: true, // Show toggle button in portrait/list mode
        );
      },
    );
  }

  Widget _buildGridView(int crossAxisCount, double maxHeight) {
    return ReorderableGridView.builder(
      padding: EdgeInsets.all(AppTheme.spacing8),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.spacing8,
        mainAxisSpacing: AppTheme.spacing8,
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
          onDelete: package.isPurchased ? () => _deletePackage(package) : null,
          isInGrid: true,
          showToggleButton: false, // Hide toggle button in landscape/grid mode
        );
      },
    );
  }

  Widget _buildHintBar(BuildContext context, bool isLandscape) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppTheme.spacing4),
          Flexible(
            child: Text(
              isLandscape
                  ? l10n.tapAndHoldToReorder
                  : l10n.tapAndHoldToReorderList,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 60,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            l10n.noPackagesYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            l10n.createFirstPackage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  void _onPackageTap(LanguagePackage package) async {
    // Allow opening package form for:
    // 1. User-created packages (full edit)
    // 2. Purchased packages (restricted edit - only group, counters, delete)
    // Block only truly readonly packages
    if (!package.isReadonly || package.isPurchased) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PackageFormPage(package: package),
        ),
      );
      // Reload packages if changes were made
      if (result == true) {
        _loadPackages();
      }
    }
    // For readonly packages that are NOT purchased, do nothing
  }

  Future<void> _deletePackage(LanguagePackage package) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await _showDeleteConfirmationDialog(package, l10n);
    if (confirmed != true) return;

    try {
      await _performPackageDeletion(package);
      await _showDeleteSuccessMessage();
      await _loadPackages();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Error', 'Failed to delete package: $e');
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(LanguagePackage package, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Package'),
        content: Text(
          'Are you sure you want to delete "${package.languageName1} → ${package.languageName2}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performPackageDeletion(LanguagePackage package) async {
    // Delete all items for this package
    final items = await _itemRepo.getItemsForPackage(package.id);
    for (final item in items) {
      await _itemRepo.deleteItem(item.id);
    }

    // Delete all categories for this package
    final categories = await _categoryRepo.getCategoriesForPackage(package.id);
    for (final category in categories) {
      await _categoryRepo.deleteCategory(category.id);
    }

    // Delete the package
    await _packageRepo.deletePackage(package.id);
  }

  Future<void> _showDeleteSuccessMessage() async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Package deleted successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }


  Future<void> _createNewPackage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PackageFormPage(),
      ),
    );
    // Always reload packages after returning from PackageFormPage
    // This ensures any new or edited packages are shown
    await _loadGroupsAndPackages();
  }

  Future<void> _importPackageFromZip() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final filePath = await _pickZipFile(l10n);
      if (filePath == null) return;

      await _performPackageImport(filePath, l10n);
    } catch (e) {
      _handleImportError(e, l10n);
    }
  }

  Future<String?> _pickZipFile(AppLocalizations l10n) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      dialogTitle: l10n.selectPackageZipFile,
    );

    if (result == null || result.files.isEmpty) {
      return null; // User cancelled
    }

    final filePath = result.files.first.path;
    if (filePath == null) {
      if (mounted) {
        _showErrorDialog(l10n.error, l10n.couldNotAccessFile);
      }
      return null;
    }

    return filePath;
  }

  Future<void> _performPackageImport(String filePath, AppLocalizations l10n) async {
    // Show loading dialog
    _showLoadingDialog(l10n.importingPackage);

    try {
      final importResult = await _attemptPackageImport(filePath, l10n);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      await _showImportSuccess(importResult, l10n);
      await _loadGroupsAndPackages();
    } catch (e) {
      // Close loading dialog if showing
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      rethrow;
    }
  }

  Future<ImportResult> _attemptPackageImport(String filePath, AppLocalizations l10n) async {
    try {
      return await _importExportRepo.importPackageFromZip(filePath);
    } on PackageAlreadyExistsException catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Ask user if they want to import as new package
      final importAsNew = await _showDuplicatePackageDialog(l10n, e.groupName);
      if (importAsNew != true) {
        throw Exception('Import cancelled by user');
      }

      // Show loading dialog again
      _showLoadingDialog(l10n.importingPackage);

      // Import with new ID
      return await _importExportRepo.importPackageFromZipWithNewId(filePath);
    }
  }

  void _showLoadingDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: AppTheme.spacing16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Future<void> _showImportSuccess(ImportResult importResult, AppLocalizations l10n) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.packageImportedWithGroup(
          importResult.itemCount,
          importResult.groupName,
        )),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleImportError(Object e, AppLocalizations l10n) {
    // Close loading dialog if it's showing
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (!mounted) return;
    if (e.toString().contains('Import cancelled by user')) return;

    String errorMessage = _getImportErrorMessage(e, l10n);
    _showErrorDialog(l10n.importError, errorMessage);
  }

  String _getImportErrorMessage(Object e, AppLocalizations l10n) {
    final errorString = e.toString();

    if (errorString.contains('ZIP file not found')) {
      return l10n.zipFileNotFound;
    } else if (errorString.contains('Invalid package ZIP')) {
      return l10n.invalidPackageZip;
    } else if (errorString.contains('Invalid package file format')) {
      return l10n.invalidPackageFormat;
    } else {
      return '${l10n.failedToImportPackage}: $e';
    }
  }

  Future<bool?> _showDuplicatePackageDialog(AppLocalizations l10n, String groupName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.packageAlreadyExists),
        content: Text(l10n.packageExistsMessage(groupName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.importAsNew),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}

/// Card widget displaying a language package
class PackageCard extends StatefulWidget {
  final LanguagePackage package;
  final int index;
  final bool isCompact;
  final VoidCallback onTap;
  final VoidCallback onToggleCompact;
  final VoidCallback? onDelete;
  final bool isInGrid;
  final bool showToggleButton;

  const PackageCard({
    required Key key,
    required this.package,
    required this.index,
    required this.isCompact,
    required this.onTap,
    required this.onToggleCompact,
    this.onDelete,
    this.isInGrid = false,
    this.showToggleButton = true,
  }) : super(key: key);

  @override
  State<PackageCard> createState() => _PackageCardState();
}


class _PackageCardState extends State<PackageCard> {
  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _statsRepo = TrainingStatisticsRepository();
  int _itemCount = 0;
  List<Category> _categories = [];
  String? _highestBadgeId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isCompact) {
      _loadPackageData();
    }
  }

  @override
  void didUpdateWidget(PackageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if expanded state changed
    if (widget.isCompact != oldWidget.isCompact) {
      if (!widget.isCompact) {
        _loadPackageData();
      }
    }
  }

  Future<void> _loadPackageData() async {
    try {
      // Get all items for this package
      final items = await _itemRepo.getItemsForPackage(widget.package.id);

      // Get unique category IDs from all items
      final categoryIds = <String>{};
      for (final item in items) {
        categoryIds.addAll(item.categoryIds);
      }

      // Get category details
      final categories = categoryIds.isNotEmpty
          ? await _categoryRepo.getCategoriesByIds(categoryIds.toList())
          : <Category>[];

      // Get the highest badge from training sessions
      final highestBadge = await _getHighestBadge();

      if (mounted) {
        setState(() {
          _itemCount = items.length;
          _categories = categories;
          _highestBadgeId = highestBadge;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading package data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _getHighestBadge() async {
    try {


      // Get all training sessions for this package
      final sessions = await _statsRepo.getSessionsForPackage(widget.package.id);



      if (sessions.isEmpty) {

        return null;
      }

      // Collect all earned badges from all sessions
      final allBadgeIds = <String>{};
      for (final session in sessions) {


        allBadgeIds.addAll(session.currentBadges);
      }



      if (allBadgeIds.isEmpty) {

        return null;
      }

      // Find the highest badge based on threshold
      String? highestBadge;
      double highestThreshold = 0.0;

      for (final badgeId in allBadgeIds) {
        final level = BadgeHelper.getBadgeLevelById(badgeId);
        if (level != null && level.threshold > highestThreshold) {
          highestThreshold = level.threshold;
          highestBadge = badgeId;

        }
      }


      return highestBadge;
    } catch (e) {

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: widget.isInGrid ? EdgeInsets.zero : EdgeInsets.only(bottom: AppTheme.spacing8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: widget.isCompact ? _buildCompactCard(context) : _buildExpandedCard(context),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompactHeader(context),
          if (widget.package.description != null && widget.package.description!.isNotEmpty)
            _buildCompactDescription(context),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Row(
      children: [
        if (!widget.isInGrid) _buildDragHandle(context, size: 18),
        if (!widget.isInGrid) SizedBox(width: AppTheme.spacing4),
        _buildPackageIcon(size: 28),
        SizedBox(width: AppTheme.spacing4),
        _buildLanguageInfo(context, isCompact: true),
        if (widget.package.isPurchased) _buildCompactPurchasedBadge(context),
        if (widget.showToggleButton) _buildToggleButton(context, isExpanded: false),
      ],
    );
  }

  Widget _buildCompactDescription(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.spacing4,
        left: !widget.isInGrid ? 40.0 : 0,
      ),
      child: Text(
        widget.package.description!,
        style: theme.textTheme.bodySmall?.copyWith(
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
        if (widget.package.description != null && widget.package.description!.isNotEmpty)
          _buildExpandedDescription(context),
        if (_hasAuthorInfo())
          _buildExpandedAuthorSection(context)
        else if (!_isLoading)
          // Show version/item count alone in same styled container if no author info
          Padding(
            padding: EdgeInsets.only(top: AppTheme.spacing12),
            child: _buildVersionOnlyCard(context),
          ),
        if (!_isLoading && _categories.isNotEmpty)
          _buildCategoryChips(context),
      ],
    );

    final mainContent = widget.isInGrid
        ? SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.spacing8),
            child: content,
          )
        : Padding(
            padding: EdgeInsets.all(AppTheme.spacing8),
            child: content,
          );

    return Stack(
      children: [
        mainContent,
        // Right side buttons (Training Rally, Browse Items, Delete)
        _buildFloatingActionButtons(context),
      ],
    );
  }

  Widget _buildVersionOnlyCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildVersionAndItemCount(context),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      bottom: AppTheme.spacing8,
      right: AppTheme.spacing8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Training Rally button (top)
          _buildTrainingRallyButton(context, l10n),
          SizedBox(height: AppTheme.spacing8),
          // Browse Items button (middle)
          _buildBrowseItemsButton(context, l10n),
          SizedBox(height: AppTheme.spacing8),
          // Delete button (bottom - only for purchased packages)
          if (widget.package.isPurchased && widget.onDelete != null)
            _buildDeleteButton(context),
        ],
      ),
    );
  }


  Widget _buildBrowseItemsButton(BuildContext context, AppLocalizations l10n) {
    return FloatingActionButton.small(
      heroTag: 'browse_${widget.package.id}',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemBrowserPage(package: widget.package),
          ),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      tooltip: l10n.browseItems,
      child: const Icon(Icons.list_alt, size: 20),
    );
  }

  Widget _buildTrainingRallyButton(BuildContext context, AppLocalizations l10n) {
    return FloatingActionButton.small(
      heroTag: 'training_${widget.package.id}',
      onPressed: () {
        // TODO: Navigate to Training Rally page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.trainingComingSoon),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      tooltip: l10n.trainingRally,
      child: const Icon(Icons.school, size: 20),
    );
  }


  Widget _buildDeleteButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'delete_${widget.package.id}',
      onPressed: widget.onDelete,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      tooltip: 'Delete package',
      child: const Icon(Icons.delete_outline, size: 20),
    );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    return Row(
      children: [
        if (!widget.isInGrid) _buildDragHandle(context, size: 20),
        if (!widget.isInGrid) SizedBox(width: AppTheme.spacing8),
        _buildPackageIcon(size: 40),
        SizedBox(width: AppTheme.spacing8),
        _buildLanguageInfo(context, isCompact: false),
        if (_highestBadgeId != null) ...[
          SizedBox(width: AppTheme.spacing4),
          _buildHighestBadge(context),
        ],
        if (widget.package.isPurchased) _buildExpandedPurchasedBadge(context),
        if (widget.showToggleButton) SizedBox(width: AppTheme.spacing4),
        if (widget.showToggleButton) _buildToggleButton(context, isExpanded: true),
      ],
    );
  }

  Widget _buildHighestBadge(BuildContext context) {
    if (_highestBadgeId == null) return const SizedBox.shrink();

    return Tooltip(
      message: BadgeHelper.getBadgeDisplayName(_highestBadgeId!),
      child: BadgeWidget(
        badgeId: _highestBadgeId!,
        size: 64,
      ),
    );
  }

  Widget _buildExpandedDescription(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing12),
      child: Text(
        widget.package.description!,
        style: theme.textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpandedAuthorSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing12),
      child: _buildAuthorInfoWithVersion(context, widget.package),
    );
  }

  Widget _buildAuthorInfoWithVersion(BuildContext context, LanguagePackage package) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info on the left
          Expanded(
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
          ),
          // Version and item count on the right
          if (!_isLoading)
            Padding(
              padding: EdgeInsets.only(left: AppTheme.spacing8),
              child: _buildVersionAndItemCount(context),
            ),
        ],
      ),
    );
  }

  Widget _buildVersionAndItemCount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildVersionInfo(context),
        if (_itemCount > 0) ...[
          SizedBox(height: AppTheme.spacing8),
          _buildItemCountInfo(context),
        ],
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info_outline,
          size: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppTheme.spacing4),
        Text(
          '${l10n.versionLabel} ${widget.package.version}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCountInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.format_list_numbered,
          size: 14,
          color: colorScheme.primary,
        ),
        SizedBox(width: AppTheme.spacing4),
        Text(
          '$_itemCount ${l10n.items}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final displayCategories = _categories.take(6).toList();
    final hasMore = _categories.length > 6;

    return Padding(
      padding: EdgeInsets.only(top: AppTheme.spacing8),
      child: Wrap(
        spacing: AppTheme.spacing8,
        runSpacing: AppTheme.spacing8,
        children: [
          ...displayCategories.map((category) => _buildCategoryChip(context, category)),
          if (hasMore) _buildMoreCategoriesChip(context),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, Category category) {
    final theme = Theme.of(context);

    return Chip(
      label: Text(
        category.name,
        style: theme.textTheme.bodySmall,
      ),
      backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildMoreCategoriesChip(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showAllCategoriesDialog(context),
      child: Chip(
        label: Text(
          '...',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        side: BorderSide(
          color: theme.colorScheme.outline,
          width: 1,
        ),
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  void _showAllCategoriesDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sortedCategories = _getSortedCategories();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.allCategories),
        content: _buildAllCategoriesContent(context, sortedCategories),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  List<Category> _getSortedCategories() {
    return List<Category>.from(_categories)
      ..sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
  }

  Widget _buildAllCategoriesContent(BuildContext context, List<Category> sortedCategories) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: sortedCategories
              .map((category) => _buildCategoryChip(context, category))
              .toList(),
        ),
      ),
    );
  }


  Widget _buildExpandedPurchasedBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: AppLocalizations.of(context)!.purchased,
      child: Icon(
        Icons.shopping_bag,
        size: 28,
        color: colorScheme.tertiary,
      ),
    );
  }

  bool _hasAuthorInfo() {
    return widget.package.authorName != null ||
        widget.package.authorEmail != null ||
        widget.package.authorWebpage != null;
  }

  // Shared UI Components
  Widget _buildDragHandle(BuildContext context, {required double size}) {
    final colorScheme = Theme.of(context).colorScheme;
    return ReorderableDragStartListener(
      index: widget.index,
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
      iconPath: widget.package.icon,
      size: size,
    );
  }

  Widget _buildLanguageInfo(BuildContext context, {required bool isCompact}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract short language codes (only first part before "-")
    String getShortCode(String fullCode) {
      return fullCode.split('-').first.toUpperCase();
    }

    final shortCode1 = getShortCode(widget.package.languageCode1);
    final shortCode2 = getShortCode(widget.package.languageCode2);
    final shortCodeDisplay = '$shortCode1-$shortCode2';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shortCodeDisplay,
            style: (isCompact
                    ? theme.textTheme.titleSmall
                    : theme.textTheme.titleSmall)
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isCompact) SizedBox(height: AppTheme.spacing4),
          // Always show package name (fallback to language names if null)
          Text(
            widget.package.packageName ?? '${widget.package.languageName1} → ${widget.package.languageName2}',
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
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      icon: Icon(
        isExpanded ? Icons.unfold_less : Icons.unfold_more,
        size: 20,
      ),
      onPressed: widget.onToggleCompact,
      tooltip: isExpanded ? l10n.compactView : l10n.expand,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
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
            style: theme.textTheme.bodySmall?.copyWith(
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
                  style: theme.textTheme.bodySmall?.copyWith(
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
                  style: theme.textTheme.bodySmall?.copyWith(
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

