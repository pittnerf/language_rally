// lib/presentation/pages/packages/package_list_simplified_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
import '../../../data/repositories/app_settings_repository.dart';
import '../../widgets/package_icon.dart';
import '../../widgets/badge_widget.dart';
import 'package:flutter/services.dart';
import '../onboarding/onboarding_screen.dart';
import 'package_form_page.dart';
import 'package_group_admin_page.dart';
import '../items/item_browser_page.dart';
import '../training/training_settings_page.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/debug_print.dart';

/// Simplified package list page with filtered view and compact card design
class PackageListSimplifiedPage extends ConsumerStatefulWidget {
  const PackageListSimplifiedPage({super.key});

  @override
  ConsumerState<PackageListSimplifiedPage> createState() => _PackageListSimplifiedPageState();
}

class _PackageListSimplifiedPageState extends ConsumerState<PackageListSimplifiedPage> {
  List<LanguagePackage> _packages = [];
  List<LanguagePackage> _filteredPackages = [];
  List<LanguagePackageGroup> _groups = [];
  LanguagePackageGroup? _selectedGroup;
  bool _isLoading = true;
  String _filterText = '';

  final _packageRepo = LanguagePackageRepository();
  final _groupRepo = LanguagePackageGroupRepository();
  final _categoryRepo = CategoryRepository();
  final _itemRepo = ItemRepository();
  final _appSettingsRepo = AppSettingsRepository();
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

  Future<void> _loadGroupsAndPackages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all groups
      final groups = await _groupRepo.getAllGroups();
      final savedGroupId = await _appSettingsRepo.loadSelectedGroupId();

      setState(() {
        _groups = groups;

        // Validate that the currently selected group still exists
        if (_selectedGroup != null) {
          final groupStillExists = _groups.any((g) => g.id == _selectedGroup!.id);
          if (!groupStillExists) {
            _selectedGroup = _groups.isNotEmpty ? _groups.first : null;
          } else {
            _selectedGroup = _groups.firstWhere((g) => g.id == _selectedGroup!.id);
          }
        } else {
          // No group selected yet, try to load from saved preference
          if (savedGroupId != null && _groups.isNotEmpty) {
            try {
              _selectedGroup = _groups.firstWhere((g) => g.id == savedGroupId);
            } catch (e) {
              _selectedGroup = _groups.isNotEmpty ? _groups.first : null;
            }
          } else if (_groups.isNotEmpty) {
            _selectedGroup = _groups.first;
          }
        }
      });

      // Load packages for selected group
      await _loadPackages();
    } catch (e) {
      logDebug('Error loading groups and packages: $e');
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

      // Sort alphabetically by package name
      packages.sort((a, b) {
        final nameA = a.packageName ?? '${a.languageName1} → ${a.languageName2}';
        final nameB = b.packageName ?? '${b.languageName1} → ${b.languageName2}';
        return nameA.compareTo(nameB);
      });

      setState(() {
        _packages = packages;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      logDebug('Error loading packages: $e');
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
      _appSettingsRepo.saveSelectedGroupId(newGroup.id);
      _loadPackages();
    }
  }

  Future<void> _openGroupAdminPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PackageGroupAdminPage()),
    );

    // Refresh the entire page when returning from group admin
    await _loadGroupsAndPackages();
  }

  void _applyFilter() {
    if (_filterText.isEmpty) {
      _filteredPackages = _packages;
    } else {
      final lowerFilter = _filterText.toLowerCase();
      _filteredPackages = _packages.where((package) {
        final name = (package.packageName ?? '${package.languageName1} → ${package.languageName2}').toLowerCase();
        return name.contains(lowerFilter);
      }).toList();
    }
  }

  void _updateFilter(String text) {
    setState(() {
      _filterText = text;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final isPhone = mediaQuery.size.shortestSide < 600;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isPhoneLandscape = isPhone && isLandscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.languagePackages,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGroupsAndPackages,
          ),
        ],
      ),
      body: SafeArea(
        child: isPhoneLandscape
            ? _buildPhoneLandscapeLayout(context, l10n, isPhone)
            : _buildPortraitLayout(context, l10n, isPhone),
      ),
    );
  }

  Widget _buildPhoneLandscapeLayout(BuildContext context, AppLocalizations l10n, bool isPhone) {
    return Row(
      children: [
        // Left column with controls
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Group filter dropdown
                if (_groups.isNotEmpty) _buildGroupFilter(context, l10n),
                // Action buttons row
                _buildActionButtonsRow(context, l10n, isPhone: isPhone),
                // Filter/search field
                _buildFilterField(context, l10n),
              ],
            ),
          ),
        ),
        // Divider
        const VerticalDivider(width: 1),
        // Right column with cards
        Expanded(
          child: _buildMainContent(context, l10n, isPhone: isPhone),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(BuildContext context, AppLocalizations l10n, bool isPhone) {
    return Column(
      children: [
        // Group filter dropdown
        if (_groups.isNotEmpty) _buildGroupFilter(context, l10n),
        // Action buttons row
        _buildActionButtonsRow(context, l10n, isPhone: isPhone),
        // Filter/search field
        _buildFilterField(context, l10n),
        // Main content
        Expanded(child: _buildMainContent(context, l10n, isPhone: isPhone)),
      ],
    );
  }

  Widget _buildGroupFilter(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Text(
            l10n.groupLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: DropdownButton<LanguagePackageGroup>(
              value: _selectedGroup,
              isExpanded: true,
              isDense: false,
              underline: Container(height: 1, color: colorScheme.outline),
              items: _groups.map((group) {
                return DropdownMenuItem<LanguagePackageGroup>(
                  value: group,
                  child: Text(
                    group.name,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _onGroupChanged,
            ),
          ),
          const SizedBox(width: AppTheme.spacing8),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            onPressed: _openGroupAdminPage,
            tooltip: l10n.amendGroups,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow(
    BuildContext context,
    AppLocalizations l10n, {
    required bool isPhone,
  }) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTabletLandscape = !isPhone && isLandscape;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      child: isPhone
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildCompactActionButton(
                    context,
                    onPressed: _createNewPackage,
                    icon: Icons.add,
                    label: ' ',
                    iconSize: 18,
                    textStyle: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: _buildCompactActionButton(
                    context,
                    onPressed: _openBuiltInImport,
                    icon: Icons.inventory_2_outlined,
                    label: l10n.importBuiltInPkg,
                    iconSize: 18,
                    textStyle: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: _buildCompactActionButton(
                    context,
                    onPressed: _showImportDialog,
                    icon: Icons.file_upload,
                    label: l10n.importPackage,
                    iconSize: 18,
                    textStyle: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              scrollDirection: isTabletLandscape ? Axis.horizontal : Axis.vertical,
              child: isTabletLandscape
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _createNewPackage,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            l10n.createNewPackage,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        ElevatedButton.icon(
                          onPressed: _openBuiltInImport,
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          label: Text(
                            l10n.importBuiltInPkg,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        ElevatedButton.icon(
                          onPressed: _showImportDialog,
                          icon: const Icon(Icons.file_upload, size: 18),
                          label: Text(
                            l10n.importPackage,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing16),
                        SizedBox(
                          width: 250,
                          child: _buildSearchField(context, l10n),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _createNewPackage,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            l10n.createNewPackage,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        ElevatedButton.icon(
                          onPressed: _openBuiltInImport,
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          label: Text(
                            l10n.importBuiltInPkg,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        ElevatedButton.icon(
                          onPressed: _showImportDialog,
                          icon: const Icon(Icons.file_upload, size: 18),
                          label: Text(
                            l10n.importPackage,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildCompactActionButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required double iconSize,
    required TextStyle? textStyle,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      label: Text(label, style: textStyle),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
      ),
    );
  }

  Widget _buildFilterField(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isPhone = mediaQuery.size.shortestSide < 600;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTabletLandscape = !isPhone && isLandscape;

    // Skip filter field for tablet landscape (it's in the action buttons row)
    if (isTabletLandscape) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      child: _buildSearchField(context, l10n),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      decoration: InputDecoration(
        hintText: l10n.search,
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
        suffixIcon: _filterText.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                onPressed: () {
                  _updateFilter('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing12,
        ),
      ),
      onChanged: _updateFilter,
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    AppLocalizations l10n, {
    required bool isPhone,
  }) {
    if (_isLoading) {
      return _buildLoadingState(l10n);
    }

    if (_filteredPackages.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final isPhoneLandscape = isPhone && isLandscape;

        // Phone landscape and phone portrait: use vertical list
        if (isPhone || isPhoneLandscape) {
          return ListView.separated(
            padding: EdgeInsets.all(AppTheme.spacing12),
            itemCount: _filteredPackages.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTheme.spacing12),
            itemBuilder: (context, index) {
              final package = _filteredPackages[index];
              return SimplifiedPackageCard(
                key: ValueKey(package.id),
                package: package,
                onTap: () => _onPackageTap(package),
                onDelete: () => _deletePackage(package),
              );
            },
          );
        }

        // Tablets use a wrapping layout so cards can keep natural height and
        // category chips can span multiple rows without overflow.
        final columns = isLandscape ? 3 : 2;
        final horizontalPadding = AppTheme.spacing12;
        final totalSpacing = AppTheme.spacing12 * (columns - 1);
        final cardWidth = (constraints.maxWidth - horizontalPadding * 2 - totalSpacing) / columns;

        return SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Wrap(
            spacing: AppTheme.spacing12,
            runSpacing: AppTheme.spacing12,
            children: _filteredPackages.map((package) {
              return SizedBox(
                width: cardWidth,
                child: SimplifiedPackageCard(
                  key: ValueKey(package.id),
                  package: package,
                  onTap: () => _onPackageTap(package),
                  onDelete: () => _deletePackage(package),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: AppTheme.spacing8),
          Text(l10n.loadingPackages, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
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
    if (!package.isReadonly || package.isPurchased) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PackageFormPage(package: package),
        ),
      );
      if (result == true) {
        _loadPackages();
      }
    }
  }

  Future<void> _deletePackage(LanguagePackage package) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAll),
        content: Text(
          '${l10n.confirmDelete}\n\n'
          '"${package.languageName1} → ${package.languageName2}"',
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
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.packageDeleted),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      await _loadPackages();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(l10n.error, '${l10n.errorDeletingPackage}: $e');
    }
  }

  Future<void> _createNewPackage() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PackageFormPage()));
    await _loadGroupsAndPackages();
  }

  Future<void> _openBuiltInImport() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(startAtStep: 1),
      ),
    );
    await _loadGroupsAndPackages();
  }

  Future<void> _showImportDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final urlController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.importPackageDialogTitle),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _importPackageFromZip();
                  },
                  icon: const Icon(Icons.folder_open),
                  label: Text(l10n.importFromLocalFile),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                      child: Text(
                        l10n.orLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextField(
                  controller: urlController,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l10n.enterPackageUrl,
                    hintText: 'https://example.com/package.zip',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.content_paste),
                      tooltip: l10n.pasteFromClipboard,
                      onPressed: () async {
                        final data = await Clipboard.getData(Clipboard.kTextPlain);
                        if (data?.text != null) {
                          urlController.text = data!.text!;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                FilledButton.icon(
                  onPressed: () {
                    final url = urlController.text.trim();
                    if (url.isEmpty) return;
                    Navigator.of(dialogContext).pop();
                    _importPackageFromUrl(url);
                  },
                  icon: const Icon(Icons.download),
                  label: Text(l10n.importFromUrl),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );

    urlController.dispose();
  }

  Future<void> _importPackageFromUrl(String url) async {
    final l10n = AppLocalizations.of(context)!;

    final uri = Uri.tryParse(url);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      _showErrorDialog(l10n.importError, l10n.invalidUrl);
      return;
    }

    String? tempFilePath;
    try {
      _showLoadingDialog(l10n.downloadingPackage);

      final response = await http.get(uri);

      if (mounted) Navigator.of(context).pop();

      if (response.statusCode != 200) {
        logDebug('URL import: HTTP ${response.statusCode} for $url');
        _showErrorDialog(l10n.importError, l10n.downloadFailed);
        return;
      }

      final supportDir = await getApplicationSupportDirectory();
      final fileName = 'pkg_import_${DateTime.now().millisecondsSinceEpoch}.zip';
      tempFilePath = '${supportDir.path}/$fileName';
      await File(tempFilePath).writeAsBytes(response.bodyBytes);

      await _performPackageImport(tempFilePath, l10n);

      await _deleteUrlTempFile(tempFilePath);
      tempFilePath = null;
    } catch (e) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      await _deleteUrlTempFile(tempFilePath);
      tempFilePath = null;

      _handleImportError(e, l10n);
    }
  }

  Future<void> _deleteUrlTempFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      logDebug('URL import: could not delete temp file: $e');
    }
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
      return null;
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
    _showLoadingDialog(l10n.importingPackage);

    try {
      final importResult = await _importExportRepo.importPackageFromZip(filePath);

      if (mounted) Navigator.of(context).pop();

      await _showImportSuccess(importResult, l10n);
      await _loadGroupsAndPackages();
    } catch (e) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      rethrow;
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
            const CircularProgressIndicator(),
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
        content: Text(
          l10n.packageImportedWithGroup(
            importResult.itemCount,
            importResult.groupName,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleImportError(Object e, AppLocalizations l10n) {
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

/// Simplified package card with vertical layout (info on top, action buttons on bottom)
class SimplifiedPackageCard extends StatefulWidget {
  final LanguagePackage package;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const SimplifiedPackageCard({
    required Key key,
    required this.package,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  State<SimplifiedPackageCard> createState() => _SimplifiedPackageCardState();
}

class _SimplifiedPackageCardState extends State<SimplifiedPackageCard> {
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
    _loadPackageData();
  }

  Future<void> _loadPackageData() async {
    try {
      final itemCount = await _itemRepo.getItemCountForPackage(widget.package.id);
      final categories = await _categoryRepo.getCategoriesForPackage(widget.package.id);
      final stats = await _statsRepo.getStatisticsForPackage(widget.package.id);

      if (mounted) {
        setState(() {
          _itemCount = itemCount;
          _categories = categories;
          _highestBadgeId = stats?.currentBadge;
          _isLoading = false;
        });
      }
    } catch (e) {
      logDebug('Error loading package data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;
              final iconSize = isCompact ? 42.0 : 48.0;
              final actionIconSize = isCompact ? 18.0 : 20.0;
              final actionBoxSize = isCompact ? 36.0 : 40.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top row with package icon and info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package icon
                      PackageIcon(iconPath: widget.package.icon, size: iconSize),
                      SizedBox(width: AppTheme.spacing12),
                      // Package info (name, categories, item count)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.package.packageName ??
                                        '${widget.package.languageName1} → ${widget.package.languageName2}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacing8),
                                if (widget.package.isPurchased)
                                  Tooltip(
                                    message: AppLocalizations.of(context)!.purchased,
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: 18,
                                      color: colorScheme.tertiary,
                                    ),
                                  ),
                                if (_highestBadgeId != null && !_isLoading) ...[
                                  const SizedBox(width: AppTheme.spacing4),
                                  Tooltip(
                                    message: BadgeHelper.getBadgeDisplayName(_highestBadgeId!),
                                    child: BadgeWidget(badgeId: _highestBadgeId!, size: 24),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: AppTheme.spacing8),
                            if (!_isLoading)
                              Wrap(
                                spacing: AppTheme.spacing4,
                                runSpacing: AppTheme.spacing4,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ..._categories.take(6).map(
                                    (category) => _buildCategoryChip(context, category),
                                  ),
                                  if (_categories.length > 6) _buildMoreCategoriesChip(context),
                                  // Item count
                                  Padding(
                                    padding: EdgeInsets.only(left: AppTheme.spacing4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.format_list_numbered,
                                          size: 14,
                                          color: colorScheme.primary,
                                        ),
                                        SizedBox(width: AppTheme.spacing4),
                                        Text(
                                          '$_itemCount ${AppLocalizations.of(context)!.items}',
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Bottom row with action buttons
                  SizedBox(height: AppTheme.spacing12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.psychology,
                          color: colorScheme.onTertiaryContainer,
                          size: actionIconSize,
                          boxSize: actionBoxSize,
                          tooltip: AppLocalizations.of(context)!.trainingRally,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TrainingSettingsPage(package: widget.package),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.record_voice_over,
                          color: colorScheme.onSecondaryContainer,
                          size: actionIconSize,
                          boxSize: actionBoxSize,
                          tooltip: AppLocalizations.of(context)!.practicePronunciation,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TrainingSettingsPage(
                                  package: widget.package,
                                  isPronunciationMode: true,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.list_alt,
                          color: colorScheme.onPrimaryContainer,
                          size: actionIconSize,
                          boxSize: actionBoxSize,
                          tooltip: AppLocalizations.of(context)!.browseItems,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ItemBrowserPage(package: widget.package),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.edit_outlined,
                          color: colorScheme.primary,
                          size: actionIconSize,
                          boxSize: actionBoxSize,
                          tooltip: AppLocalizations.of(context)!.editPackage,
                          onPressed: widget.onTap,
                        ),
                        if (widget.onDelete != null)
                          _buildActionButton(
                            context,
                            icon: Icons.delete_outline,
                            color: colorScheme.onErrorContainer,
                            size: actionIconSize,
                            boxSize: actionBoxSize,
                            tooltip: AppLocalizations.of(context)!.deleteAll,
                            onPressed: widget.onDelete!,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required double size,
    required double boxSize,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: size, color: color),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(boxSize, boxSize)),
      onPressed: onPressed,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildCategoryChip(BuildContext context, Category category) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 140),
      child: Chip(
        label: Text(
          category.name,
          style: theme.textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildMoreCategoriesChip(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      label: Text(
        '...',
        style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      side: BorderSide(color: theme.colorScheme.outline, width: 1),
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}



