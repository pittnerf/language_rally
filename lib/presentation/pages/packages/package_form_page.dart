// lib/presentation/pages/packages/package_form_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/language_codes.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/language_package_group.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/language_package_group_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/import_export_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/package_icon.dart';
import '../ai_import/ai_text_analysis_page.dart';

/// Page for creating or editing a language package
class PackageFormPage extends ConsumerStatefulWidget {
  final LanguagePackage? package; // null for create, non-null for edit

  const PackageFormPage({super.key, this.package});

  @override
  ConsumerState<PackageFormPage> createState() => _PackageFormPageState();
}

class _PackageFormPageState extends ConsumerState<PackageFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _packageRepo = LanguagePackageRepository();
  final _groupRepo = LanguagePackageGroupRepository();
  final _categoryRepo = CategoryRepository();
  final _itemRepo = ItemRepository();
  late final ImportExportRepository _importExportRepo;

  // Form controllers
  late final TextEditingController _packageNameController;
  late final TextEditingController _languageCode1Controller;
  late final TextEditingController _languageName1Controller;
  late final TextEditingController _languageCode2Controller;
  late final TextEditingController _languageName2Controller;
  late final TextEditingController _descriptionController;
  late final TextEditingController _authorNameController;
  late final TextEditingController _authorEmailController;
  late final TextEditingController _authorWebpageController;
  late final TextEditingController _versionController;

  String? _selectedIcon;
  bool _isLoading = false;
  bool _isEditingEnabled = false; // Controls whether fields are editable
  bool get _isEditMode => widget.package != null;
  bool get _isReadOnly => widget.package?.isReadonly ?? false;
  bool get _isPurchased => widget.package?.isPurchased ?? false;

  // Helper method to determine if fields should be enabled
  bool get _fieldsEnabled => !_isPurchased && _isEditingEnabled;

  // Helper method to determine if export buttons should be enabled
  // Export buttons are always enabled for non-purchased packages, regardless of edit status
  bool get _exportEnabled => !_isPurchased;

  // Package groups
  List<LanguagePackageGroup> _groups = [];
  LanguagePackageGroup? _selectedGroup;

  // Available icons from assets
  List<String?> _availableIcons = [
    null, // Default icon
    'assets/images/package_icons/default_package_icon.svg',
    'assets/images/package_icons/package_icon_v1.svg',
    'assets/images/package_icons/package_icon_v2.png',
    'assets/images/package_icons/package_icon_v3.png',
  ];

  @override
  void initState() {
    super.initState();
    // Enable editing by default for new packages, disable for existing ones
    _isEditingEnabled = !_isEditMode;
    _importExportRepo = ImportExportRepository(
      packageRepo: _packageRepo,
      groupRepo: _groupRepo,
      categoryRepo: _categoryRepo,
      itemRepo: _itemRepo,
    );
    _initializeControllers();
    _loadCustomIcons();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final groups = await _groupRepo.getAllGroups();
      setState(() {
        _groups = groups;
        // If editing, set the current group
        if (_isEditMode && widget.package != null) {
          _selectedGroup = groups.firstWhere(
            (g) => g.id == widget.package!.groupId,
            orElse: () => groups.first,
          );
        } else {
          // For new packages, select the first group (usually "Default")
          _selectedGroup = groups.isNotEmpty ? groups.first : null;
        }
      });
    } catch (e) {
      debugPrint('Error loading groups: $e');
    }
  }

  void _initializeControllers() {
    final pkg = widget.package;
    _packageNameController = TextEditingController(
      text: pkg?.packageName ?? '',
    );
    _languageCode1Controller = TextEditingController(
      text: pkg?.languageCode1 ?? '',
    );
    _languageName1Controller = TextEditingController(
      text: pkg?.languageName1 ?? '',
    );
    _languageCode2Controller = TextEditingController(
      text: pkg?.languageCode2 ?? '',
    );
    _languageName2Controller = TextEditingController(
      text: pkg?.languageName2 ?? '',
    );
    _descriptionController = TextEditingController(
      text: pkg?.description ?? '',
    );
    _authorNameController = TextEditingController(text: pkg?.authorName ?? '');
    _authorEmailController = TextEditingController(
      text: pkg?.authorEmail ?? '',
    );
    _authorWebpageController = TextEditingController(
      text: pkg?.authorWebpage ?? '',
    );
    _versionController = TextEditingController(text: pkg?.version ?? '1.0');
    _selectedIcon = pkg?.icon;
  }

  Future<void> _loadCustomIcons() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final customIconsDir = Directory(
        path.join(appDir.path, 'custom_package_icons'),
      );

      // Start with asset icons only
      final assetIcons = [
        null, // Default icon
        'assets/images/package_icons/default_package_icon.svg',
        'assets/images/package_icons/package_icon_v1.svg',
        'assets/images/package_icons/package_icon_v2.png',
        'assets/images/package_icons/package_icon_v3.png',
      ];

      // Use a Set to collect custom icons (prevents duplicates)
      final customIconsSet = <String>{};

      if (await customIconsDir.exists()) {
        final files = await customIconsDir.list().toList();
        for (final entity in files) {
          if (entity is File) {
            final ext = path.extension(entity.path).toLowerCase();
            if (ext == '.png' ||
                ext == '.jpg' ||
                ext == '.jpeg' ||
                ext == '.svg') {
              customIconsSet.add(entity.path);
            }
          }
        }
      }

      // If current selected icon is custom, ensure it's in the set
      if (_selectedIcon != null && !_selectedIcon!.startsWith('assets/')) {
        customIconsSet.add(_selectedIcon!);
      }

      setState(() {
        // Rebuild the entire list: asset icons + custom icons
        _availableIcons = [...assetIcons, ...customIconsSet];
      });
    } catch (e) {
      // Silently fail - custom icons directory might not exist yet
    }
  }

  @override
  void dispose() {
    _packageNameController.dispose();
    _languageCode1Controller.dispose();
    _languageName1Controller.dispose();
    _languageCode2Controller.dispose();
    _languageName2Controller.dispose();
    _descriptionController.dispose();
    _authorNameController.dispose();
    _authorEmailController.dispose();
    _authorWebpageController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // Consider 600dp+ as tablet

    // Only block truly readonly packages that are NOT purchased
    // Purchased packages can open with restrictions
    if (_isReadOnly && !_isPurchased) {
      return _buildReadOnlyWarning(context, l10n, theme);
    }

    return Scaffold(
      appBar: isTablet ? _buildAppBar(context, theme, l10n) : null,
      body: Stack(
        children: [
          _buildBody(context, l10n),
          // Add back button for non-tablet devices (where AppBar is hidden)
          if (!isTablet)
            Positioned(
              top: AppTheme.spacing8,
              left: AppTheme.spacing8,
              child: SafeArea(
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  color: theme.colorScheme.surface,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      child: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: orientation == Orientation.portrait
          ? _buildFloatingActionButton(l10n)
          : null,
    );
  }

  Widget _buildFloatingActionButton(AppLocalizations l10n) {
    return FloatingActionButton(
      onPressed: _savePackage,
      tooltip: l10n.save,
      child: const Icon(Icons.save),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Text(
        _isEditMode ? l10n.editPackage : l10n.createPackage,
        style: theme.textTheme.titleLarge,
      ),
      actions: _isEditMode ? [_buildDeleteButton(l10n)] : null,
    );
  }

  Widget _buildDeleteButton(AppLocalizations l10n) {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: _confirmDelete,
      tooltip: l10n.delete,
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppTheme.spacing8),
          children: _buildFormFields(context, l10n),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context, AppLocalizations l10n) {
    return [
      // Package Group selector with icon selector integrated
      _buildGroupSelector(context, l10n),
      SizedBox(height: AppTheme.spacing8),
      // Package details section with background
      _buildPackageDetailsSection(context, l10n),
      SizedBox(height: AppTheme.spacing16),
      // Author details section with background
      _buildAuthorDetailsSection(context, l10n),
      SizedBox(height: AppTheme.spacing16),
      _buildActionButtons(context, l10n),
      SizedBox(height: AppTheme.spacing8),
    ];
  }

  Widget _buildPackageDetailsSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTextField(
            context,
            l10n,
            _packageNameController,
            l10n.packageName,
            hint: l10n.packageNameHint,
            enabled: _fieldsEnabled,
            bold: true,
          ),
          SizedBox(height: AppTheme.spacing8),
          _buildResponsiveLanguageFields(context, l10n),
          SizedBox(height: AppTheme.spacing8),
          _buildTextField(
            context,
            l10n,
            _descriptionController,
            l10n.description,
            maxLines: 2,
            hint: l10n.descriptionHint,
            enabled: _fieldsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorDetailsSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildResponsiveAuthorFields(context, l10n),
          SizedBox(height: AppTheme.spacing8),
          _buildTextField(
            context,
            l10n,
            _authorWebpageController,
            l10n.authorWebpage,
            keyboardType: TextInputType.url,
            validator: _validateUrl,
            enabled: _fieldsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveLanguageFields(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Wide layout: Both language name fields in one row
        // Threshold: ~700px for comfortable 2-field layout
        if (availableWidth >= 700) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLanguageNameAutocomplete(
                      context,
                      l10n,
                      _languageName1Controller,
                      l10n.languageName1,
                      true,
                      enabled: _fieldsEnabled,
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: _buildLanguageNameAutocomplete(
                      context,
                      l10n,
                      _languageName2Controller,
                      l10n.languageName2,
                      false,
                      enabled: _fieldsEnabled,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        // Medium/Narrow layout: Each language name field in its own row
        else {
          return Column(
            children: [
              _buildLanguageNameAutocomplete(
                context,
                l10n,
                _languageName1Controller,
                l10n.languageName1,
                true,
                enabled: _fieldsEnabled,
              ),
              SizedBox(height: AppTheme.spacing8),
              _buildLanguageNameAutocomplete(
                context,
                l10n,
                _languageName2Controller,
                l10n.languageName2,
                false,
                enabled: _fieldsEnabled,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildResponsiveAuthorFields(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Wide layout: Name, Email, and Version in one row
        // Threshold: ~900px for comfortable 3-field layout
        if (availableWidth >= 900) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  context,
                  l10n,
                  _authorNameController,
                  l10n.authorName,
                  enabled: _fieldsEnabled,
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  context,
                  l10n,
                  _authorEmailController,
                  l10n.authorEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  enabled: _fieldsEnabled,
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                flex: 1,
                child: _buildTextField(
                  context,
                  l10n,
                  _versionController,
                  l10n.version,
                  required: true,
                  enabled: _fieldsEnabled,
                ),
              ),
            ],
          );
        }
        // Medium layout: Name and Email in one row, Version in another
        // Threshold: ~600px for comfortable 2-field layout
        else if (availableWidth >= 600) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context,
                      l10n,
                      _authorNameController,
                      l10n.authorName,
                      enabled: _fieldsEnabled,
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: _buildTextField(
                      context,
                      l10n,
                      _authorEmailController,
                      l10n.authorEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: _fieldsEnabled,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing8),
              _buildTextField(
                context,
                l10n,
                _versionController,
                l10n.version,
                required: true,
                enabled: _fieldsEnabled,
              ),
            ],
          );
        }
        // Narrow layout: Each field gets its own row
        else {
          return Column(
            children: [
              _buildTextField(
                context,
                l10n,
                _authorNameController,
                l10n.authorName,
                enabled: _fieldsEnabled,
              ),
              SizedBox(height: AppTheme.spacing8),
              _buildTextField(
                context,
                l10n,
                _authorEmailController,
                l10n.authorEmail,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                enabled: _fieldsEnabled,
              ),
              SizedBox(height: AppTheme.spacing8),
              _buildTextField(
                context,
                l10n,
                _versionController,
                l10n.version,
                required: true,
                enabled: _fieldsEnabled,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildReadOnlyWarning(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editPackage)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: theme.colorScheme.outline,
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  _isPurchased ? l10n.purchasedPackage : l10n.readOnlyPackage,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppTheme.spacing8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSelector(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          // If width < 900px, split into two rows
          if (availableWidth < 900) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row: Group selector only
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: DropdownButtonFormField<LanguagePackageGroup>(
                        initialValue: _selectedGroup,
                        decoration: InputDecoration(
                          labelText: l10n.packageGroup,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing8,
                            vertical: AppTheme.spacing8,
                          ),
                        ),
                        items: _groups.map((group) {
                          return DropdownMenuItem<LanguagePackageGroup>(
                            value: group,
                            child: Text(
                              group.name,
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: _fieldsEnabled
                            ? (newGroup) {
                                setState(() {
                                  _selectedGroup = newGroup;
                                });
                              }
                            : null,
                        validator: (value) {
                          if (value == null) {
                            return l10n.pleaseSelectPackageGroup;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing8),
                // Second row: Icon selector and upload button
                Row(
                  children: [
                    Expanded(
                      child: _buildIconDropdown(context, colorScheme, l10n),
                    ),
                    SizedBox(width: AppTheme.spacing8),
                    _buildUploadIconButton(context, colorScheme, l10n),
                  ],
                ),
              ],
            );
          }

          // Wide screens (>= 900px): All in one row
          return Row(
            children: [
              // Group icon (no label)
              Icon(Icons.folder_outlined, size: 20, color: colorScheme.primary),
              SizedBox(width: AppTheme.spacing8),
              // Group dropdown
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<LanguagePackageGroup>(
                  initialValue: _selectedGroup,
                  decoration: InputDecoration(
                    labelText: l10n.packageGroup,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing8,
                    ),
                  ),
                  items: _groups.map((group) {
                    return DropdownMenuItem<LanguagePackageGroup>(
                      value: group,
                      child: Text(
                        group.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: _fieldsEnabled
                      ? (newGroup) {
                          setState(() {
                            _selectedGroup = newGroup;
                          });
                        }
                      : null,
                  validator: (value) {
                    if (value == null) {
                      return l10n.pleaseSelectPackageGroup;
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
              // Package icon dropdown (moved here, no label)
              Expanded(
                flex: 2,
                child: _buildIconDropdown(context, colorScheme, l10n),
              ),
              SizedBox(width: AppTheme.spacing8),
              // Upload icon button (moved here)
              _buildUploadIconButton(context, colorScheme, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconDropdown(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String?>(
      initialValue: _availableIcons.contains(_selectedIcon)
          ? _selectedIcon
          : null,
      decoration: InputDecoration(
        labelText: l10n.packageIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing8,
        ),
      ),
      style: theme.textTheme.bodyMedium,
      hint: _selectedIcon != null && !_availableIcons.contains(_selectedIcon)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.only(right: AppTheme.spacing8),
                  child: PackageIcon(iconPath: _selectedIcon, size: 20),
                ),
                Text(
                  l10n.customIconLabel,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : null,
      items: _availableIcons.map((iconPath) {
        return DropdownMenuItem<String?>(
          value: iconPath,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.only(right: AppTheme.spacing8),
                child: PackageIcon(iconPath: iconPath, size: 20),
              ),
              Flexible(
                child: Text(
                  iconPath == null ? l10n.defaultIconLabel : _getIconLabel(iconPath),
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: _fieldsEnabled
          ? (newValue) {
              setState(() {
                _selectedIcon = newValue;
              });
            }
          : null,
    );
  }

  String _getIconLabel(String iconPath) {
    final l10n = AppLocalizations.of(context)!;
    // Extract a friendly name from the path
    final fileName = path.basenameWithoutExtension(iconPath);

    // Handle asset icons
    if (fileName == 'default_package_icon') return l10n.defaultIconLabel;
    if (fileName == 'package_icon_v1') return l10n.icon1Label;
    if (fileName == 'package_icon_v2') return l10n.icon2Label;
    if (fileName == 'package_icon_v3') return l10n.icon3Label;

    // Handle custom icons - show "Custom Icon" for uploaded ones
    if (iconPath.contains('custom_package_icons') ||
        fileName.startsWith('custom_icon_')) {
      return l10n.customIconFile;
    }
    if (iconPath.contains('custom_package_icons') ||
        fileName.startsWith('imported_icon_')) {
      return l10n.importedIconFile;
    }

    return fileName;
  }

  Widget _buildUploadIconButton(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Tooltip(
      message: l10n.uploadCustomIcon,
      child: ElevatedButton.icon(
        onPressed: _fieldsEnabled ? _uploadCustomIcon : null,
        icon: const Icon(Icons.upload_file, size: 20),
        label: Text(l10n.upload),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? AppTheme.spacing8 : AppTheme.spacing8,
            vertical: isPortrait ? AppTheme.spacing8 : AppTheme.spacing8,
          ),
        ),
      ),
    );
  }

  Future<void> _uploadCustomIcon() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Pick image from gallery or camera
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90,
      );

      if (image == null) return;

      // Read and validate image dimensions
      final bytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) {
        if (!mounted) return;
        _showErrorDialog(
          AppLocalizations.of(context)!,
          AppLocalizations.of(context)!.unableToReadImageFile,
        );
        return;
      }

      // Validate dimensions (max 512x512)
      if (decodedImage.width > 512 || decodedImage.height > 512) {
        if (!mounted) return;
        _showErrorDialog(
          AppLocalizations.of(context)!,
          AppLocalizations.of(context)!.iconDimensionsTooLarge(
            decodedImage.width,
            decodedImage.height,
          ),
        );
        return;
      }

      // Validate file size (max 1MB)
      final file = File(image.path);
      final fileSize = await file.length();
      if (fileSize > 1024 * 1024) {
        if (!mounted) return;
        _showErrorDialog(
          AppLocalizations.of(context)!,
          AppLocalizations.of(context)!.iconFileTooLarge,
        );
        return;
      }

      // Create custom icons directory
      final appDir = await getApplicationDocumentsDirectory();
      final customIconsDir = Directory(
        path.join(appDir.path, 'custom_package_icons'),
      );
      if (!await customIconsDir.exists()) {
        await customIconsDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.path);
      final newFileName = 'custom_icon_$timestamp$extension';
      final newPath = path.join(customIconsDir.path, newFileName);

      // Copy file to custom icons directory
      await file.copy(newPath);

      setState(() {
        _selectedIcon = newPath;
      });

      // Reload custom icons to include the newly uploaded icon in the dropdown
      await _loadCustomIcons();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.customIconUploaded),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        AppLocalizations.of(context)!,
        AppLocalizations.of(context)!.failedToUploadIcon(e.toString()),
      );
    }
  }

  /// Build autocomplete language name dropdown field
  /// This replaces the language code field and updates the code in the background
  Widget _buildLanguageNameAutocomplete(
    BuildContext context,
    AppLocalizations l10n,
    TextEditingController controller,
    String label,
    bool isSource, {
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get all languages sorted by name
    final allLanguages = LanguageCodes.getSortedLanguages();

    return Autocomplete<MapEntry<String, String>>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return allLanguages;
        }
        // Filter languages based on user input
        final query = textEditingValue.text.toLowerCase();
        return allLanguages.where((entry) {
          return entry.value.toLowerCase().contains(query) ||
              entry.key.toLowerCase().contains(query);
        });
      },
      displayStringForOption: (MapEntry<String, String> option) => option.value,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            // Sync the text controller with our controller
            if (textEditingController.text != controller.text) {
              textEditingController.text = controller.text;
            }

            textEditingController.addListener(() {
              if (controller.text != textEditingController.text) {
                controller.text = textEditingController.text;
              }
            });

            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: label,
                hintText: l10n.typeToSearchLanguages,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.primary,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing8,
                ),
              ),
              style: theme.textTheme.bodyMedium,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                // Check if selected language name matches a valid language
                final matchingLanguage = allLanguages.firstWhere(
                  (entry) => entry.value == value.trim(),
                  orElse: () => const MapEntry('', ''),
                );
                if (matchingLanguage.key.isEmpty) {
                  return l10n.pleaseSelectValidLanguage;
                }
                return null;
              },
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300, maxWidth: 500),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option.value,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      option.key,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (MapEntry<String, String> selection) {
        // Update the name controller
        controller.text = selection.value;

        // Update the language code in the background
        if (isSource) {
          _languageCode1Controller.text = selection.key;
        } else {
          _languageCode2Controller.text = selection.key;
        }

        // No need to call setState as the form field will update automatically
      },
    );
  }

  Widget _buildTextField(
    BuildContext context,
    AppLocalizations l10n,
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
    bool bold = false,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing8,
        ),
      ),
      style: bold
          ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
          : theme.textTheme.bodyMedium,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator:
          validator ??
          (required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.fieldRequired;
                  }
                  return null;
                }
              : null),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final urlRegex = RegExp(
      r'^(https?://)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*/?$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.invalidUrl;
    }
    return null;
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // In edit mode, we need to check if 4 buttons fit
        // Threshold: ~550px for comfortable 4-button layout with icons and labels
        final buttonsCanFitInOneRow = _isEditMode
            ? availableWidth >= 550
            : true;
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;

        return Column(
          children: [
            // Export, Import, and AI Text Analysis buttons (if editing)
            if (_isEditMode) ...[
              // In landscape mode: all three buttons in one row
              // In portrait mode: stack them vertically
              if (!isPortrait)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportEnabled ? _exportPackage : null,
                        icon: const Icon(Icons.file_download),
                        label: Text(l10n.exportPackage),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onTertiary,
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportEnabled ? _exportItemsJson : null,
                        icon: const Icon(Icons.download),
                        label: Text(l10n.exportItemsJson),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onTertiary,
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _fieldsEnabled ? _importItems : null,
                        icon: const Icon(Icons.file_upload),
                        label: Text(l10n.importItems),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onTertiary,
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),

                    SizedBox(width: AppTheme.spacing8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _fieldsEnabled ? _openAITextAnalysis : null,
                        icon: const Icon(Icons.psychology),
                        label: Text(l10n.aiTextAnalysis),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Portrait mode: stack vertically
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _exportEnabled ? _exportPackage : null,
                            icon: const Icon(Icons.file_download),
                            label: Text(l10n.exportPackage),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onTertiary,
                              disabledBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              disabledForegroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.38),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _exportEnabled ? _exportItemsJson : null,
                            icon: const Icon(Icons.download),
                            label: Text(l10n.exportItemsJson),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onTertiary,
                              disabledBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              disabledForegroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.38),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: AppTheme.spacing8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _fieldsEnabled ? _importItems : null,
                            icon: const Icon(Icons.file_upload),
                            label: Text(l10n.importItems),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onTertiary,
                              disabledBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              disabledForegroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.38),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacing8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _fieldsEnabled ? _openAITextAnalysis : null,
                        icon: const Icon(Icons.psychology),
                        label: Text(l10n.aiTextAnalysis),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.38),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: AppTheme.spacing8),
            ],
            // Main action buttons - responsive layout
            if (buttonsCanFitInOneRow)
              _buildButtonsInOneRow(context, l10n)
            else
              _buildButtonsInTwoRows(context, l10n),
          ],
        );
      },
    );
  }

  Widget _buildButtonsInOneRow(BuildContext context, AppLocalizations l10n) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Row(
      children: [
        if (_isEditMode) ...[
          // Clear Counters button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _confirmClearCounters,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.clearCounters),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: isPortrait
                    ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                    : null,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacing8),
          // Delete All Data button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _confirmDeleteAllData,
              icon: const Icon(Icons.delete_forever),
              label: Text(l10n.deleteAll),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                padding: isPortrait
                    ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                    : null,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacing8),
        ],
        // Cancel button
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: isPortrait
                  ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                  : null,
            ),
            child: Text(l10n.cancel),
          ),
        ),
        SizedBox(width: AppTheme.spacing8),
        // Edit button (only in edit mode)
        if (_isEditMode) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: !_isPurchased
                  ? () {
                      setState(() {
                        _isEditingEnabled = !_isEditingEnabled;
                      });
                    }
                  : null,
              icon: Icon(_isEditingEnabled ? Icons.lock_open : Icons.edit),
              label: Text(l10n.edit),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEditingEnabled
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: _isEditingEnabled
                    ? Theme.of(context).colorScheme.onTertiary
                    : Theme.of(context).colorScheme.onPrimary,
                padding: isPortrait
                    ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                    : null,
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacing8),
        ],
        // Save button
        Expanded(
          flex: _isEditMode ? 1 : 2,
          child: ElevatedButton(
            onPressed: _fieldsEnabled ? _savePackage : null,
            style: ElevatedButton.styleFrom(
              padding: isPortrait
                  ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                  : null,
            ),
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsInTwoRows(BuildContext context, AppLocalizations l10n) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        // First row: Clear Counters and Delete All Data
        if (_isEditMode) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _confirmClearCounters,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.clearCounters),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: isPortrait
                        ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                        : null,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _confirmDeleteAllData,
                  icon: const Icon(Icons.delete_forever),
                  label: Text(l10n.deleteAll),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    padding: isPortrait
                        ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing8),
        ],
        // Second row: Cancel, Edit (if editing), and Save
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: isPortrait
                      ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                      : null,
                ),
                child: Text(l10n.cancel),
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            // Edit button (only in edit mode)
            if (_isEditMode) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: !_isPurchased
                      ? () {
                          setState(() {
                            _isEditingEnabled = !_isEditingEnabled;
                          });
                        }
                      : null,
                  icon: Icon(_isEditingEnabled ? Icons.lock_open : Icons.edit),
                  label: Text(l10n.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditingEnabled
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: _isEditingEnabled
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onPrimary,
                    padding: isPortrait
                        ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                        : null,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacing8),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _fieldsEnabled ? _savePackage : null,
                style: ElevatedButton.styleFrom(
                  padding: isPortrait
                      ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
                      : null,
                ),
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final wasCreating = !_isEditMode;

    try {
      final package = LanguagePackage(
        id: widget.package?.id ?? const Uuid().v4(),
        groupId:
            _selectedGroup?.id ?? widget.package?.groupId ?? 'default-group-id',
        packageName: _packageNameController.text.trim().isEmpty
            ? null
            : _packageNameController.text.trim(),
        languageCode1: _languageCode1Controller.text.trim(),
        languageName1: _languageName1Controller.text.trim(),
        languageCode2: _languageCode2Controller.text.trim(),
        languageName2: _languageName2Controller.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        icon: _selectedIcon,
        authorName: _authorNameController.text.trim().isEmpty
            ? null
            : _authorNameController.text.trim(),
        authorEmail: _authorEmailController.text.trim().isEmpty
            ? null
            : _authorEmailController.text.trim(),
        authorWebpage: _authorWebpageController.text.trim().isEmpty
            ? null
            : _authorWebpageController.text.trim(),
        version: _versionController.text.trim(),
        packageType: PackageType.userCreated,
        isPurchased: false,
        isReadonly: false,
        isCompactView: widget.package?.isCompactView ?? false,
        purchasedAt: null,
        createdAt: widget.package?.createdAt ?? DateTime.now(),
        price: 0.0,
      );

      if (_isEditMode) {
        await _packageRepo.updatePackage(package);
      } else {
        await _packageRepo.insertPackage(package);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.packageSaved),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        if (wasCreating) {
          // If we just created the package, navigate to edit mode with the new package
          // This will make all import/export/delete buttons visible
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PackageFormPage(package: package),
            ),
          );
        } else {
          // If editing, just pop back
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorSavingPackage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDelete),
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

    if (confirmed == true && mounted) {
      await _deletePackage();
    }
  }

  Future<void> _deletePackage() async {
    if (widget.package == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _packageRepo.deletePackage(widget.package!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.packageDeleted),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorDeletingPackage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmClearCounters() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCounters),
        content: Text(l10n.confirmClearCounters),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _clearCounters();
    }
  }

  Future<void> _clearCounters() async {
    if (widget.package == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _packageRepo.clearPackageCounters(widget.package!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.countersCleared),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorClearingCounters),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDeleteAllData() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAll),
        content: Text(l10n.confirmDeleteAllData),
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
            child: Text(l10n.deleteAll),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteAllData();
    }
  }

  Future<void> _deleteAllData() async {
    if (widget.package == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _packageRepo.deletePackageWithAllData(widget.package!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.allDataDeleted),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorDeletingPackage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(AppLocalizations l10n, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPackage() async {
    if (widget.package == null) return;

    final l10n = AppLocalizations.of(context)!;

    // Let user select destination folder
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10n.selectExportLocation,
    );

    if (selectedDirectory == null) {
      // User cancelled
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final zipPath = await _importExportRepo.exportPackageToZip(
        widget.package!.id,
        selectedDirectory,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.packageExported}\n$zipPath'),
            duration: const Duration(seconds: 5),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorExportingPackage}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _importItems() async {
    if (widget.package == null) return;

    final l10n = AppLocalizations.of(context)!;

    // Let user select JSON file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: l10n.selectImportFile,
    );

    if (result == null || result.files.single.path == null) {
      // User cancelled
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();

      // Parse JSON
      final dynamic jsonData = jsonDecode(content);

      if (jsonData is! List) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorImportingItems}: JSON must be an array'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      final List<Map<String, dynamic>> items = jsonData
          .whereType<Map<String, dynamic>>()
          .toList();

      if (items.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorImportingItems}: No valid items found in JSON'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Check for language mismatch (only once)
      bool shouldContinue = true;
      if (items.isNotEmpty) {
        shouldContinue = await _checkLanguageMismatch(items.first);
        if (!shouldContinue) {
          return;
        }
      }

      // Create a ValueNotifier for progress updates
      final progressNotifier = ValueNotifier<_ImportProgress>(
        _ImportProgress(current: 0, total: items.length),
      );

      // Show progress dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              _ImportProgressDialog(progressNotifier: progressNotifier),
        );
      }

      final importResult = await _processJsonImportItems(
        items,
        onProgress: (current, total) {
          progressNotifier.value = _ImportProgress(
            current: current,
            total: total,
          );
        },
      );

      // Close progress dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        _showImportResultDialog(l10n, importResult);
      }
    } catch (e) {
      // Close progress dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorImportingItems}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _exportItemsJson() async {
    if (widget.package == null) return;

    final package = widget.package!;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get all categories for the package
      final categories = await _categoryRepo.getCategoriesForPackage(package.id);

      if (categories.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.noCategoriesInPackage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Get all items from all categories
      final categoryIds = categories.map((c) => c.id).toList();
      final items = await _itemRepo.getItemsForCategories(categoryIds);

      if (items.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.noItemsToExport),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Create category map for lookups
      final categoryMap = <String, Category>{};
      for (final cat in categories) {
        categoryMap[cat.id] = cat;
      }

      // Convert items to JSON format
      final List<Map<String, dynamic>> jsonItems = [];

      // Normalize language codes to 2-letter format (e.g., "en-US" -> "EN")
      String normalizeLanguageCodeForExport(String code) {
        return code.split('-').first.toUpperCase();
      }

      final sourceLang = normalizeLanguageCodeForExport(package.languageCode1);
      final targetLang = normalizeLanguageCodeForExport(package.languageCode2);

      for (final item in items) {
        final Map<String, dynamic> jsonItem = {};

        // Add language codes
        jsonItem['source_language'] = sourceLang;
        jsonItem['target_language'] = targetLang;

        // Add source fields
        jsonItem['source_pre'] = item.language1Data.preItem ?? '';
        jsonItem['source_expression'] = item.language1Data.text;
        jsonItem['source_post'] = item.language1Data.postItem ?? '';

        // Add target fields
        jsonItem['target_pre'] = item.language2Data.preItem ?? '';
        jsonItem['target_expression'] = item.language2Data.text;
        jsonItem['target_post'] = item.language2Data.postItem ?? '';

        // Add examples
        if (item.examples.isNotEmpty) {
          jsonItem['examples'] = item.examples
              .map((ex) => {
                    'source': ex.textLanguage1,
                    'target': ex.textLanguage2,
                  })
              .toList();
        } else {
          jsonItem['examples'] = [];
        }

        // Add categories
        final itemCategories = item.categoryIds
            .where((id) => categoryMap.containsKey(id))
            .map((id) => categoryMap[id]!.name)
            .toList();
        jsonItem['categories'] = itemCategories;

        jsonItems.add(jsonItem);
      }

      // Convert to pretty JSON
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(jsonItems);

      // Let user select destination folder and filename
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Items as JSON',
        fileName: '${package.packageName ?? "items"}_export.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputPath == null) {
        // User cancelled
        return;
      }

      // Ensure .json extension
      if (!outputPath.toLowerCase().endsWith('.json')) {
        outputPath = '$outputPath.json';
      }

      // Write JSON to file
      final file = File(outputPath);
      await file.writeAsString(jsonString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.itemsExportedSuccessfully(items.length, outputPath)),
            duration: const Duration(seconds: 5),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorExportingItems}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Check if JSON languages differ from package languages and warn user
  Future<bool> _checkLanguageMismatch(Map<String, dynamic> firstItem) async {
    final package = widget.package!;
    final l10n = AppLocalizations.of(context)!;

    // Extract language codes from JSON (if present)
    final jsonSourceLang = firstItem['source_language'] as String?;
    final jsonTargetLang = firstItem['target_language'] as String?;

    if (jsonSourceLang == null || jsonTargetLang == null) {
      // No language info in JSON, proceed without warning
      return true;
    }

    // Normalize language codes for comparison (e.g., "EN" -> "en", "en-US" -> "en")
    String normalizeLanguageCode(String code) {
      return code.toLowerCase().split('-').first;
    }

    final packageLang1 = normalizeLanguageCode(package.languageCode1);
    final packageLang2 = normalizeLanguageCode(package.languageCode2);
    final jsonLang1 = normalizeLanguageCode(jsonSourceLang);
    final jsonLang2 = normalizeLanguageCode(jsonTargetLang);

    // Check if languages match
    if (packageLang1 != jsonLang1 || packageLang2 != jsonLang2) {
      // Show warning dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(l10n.languageMismatch),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.languageMismatchDescription,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(l10n.packageLanguages(packageLang1, packageLang2)),
              Text(l10n.jsonFileLanguages(jsonLang1, jsonLang2)),
              const SizedBox(height: AppTheme.spacing16),
              Text(l10n.continueImportQuestion),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(l10n.continueImport),
            ),
          ],
        ),
      );

      return result ?? false;
    }

    return true;
  }

  /// Process JSON import items
  Future<_ImportResult> _processJsonImportItems(
    List<Map<String, dynamic>> jsonItems, {
    void Function(int current, int total)? onProgress,
  }) async {
    final successfulItems = <String>[];
    final failedItems = <String>[];
    final package = widget.package!;

    // Get existing items to check for duplicates
    final existingCategories = await _categoryRepo.getCategoriesForPackage(
      package.id,
    );
    final categoryMap = <String, Category>{};
    for (final cat in existingCategories) {
      categoryMap[cat.name.toLowerCase()] = cat;
    }

    // Get existing items
    final categoryIds = existingCategories.map((c) => c.id).toList();
    final existingItems = categoryIds.isNotEmpty
        ? await _itemRepo.getItemsForCategories(categoryIds)
        : <Item>[];

    final existingItemKeys = <String>{};
    for (final item in existingItems) {
      final key =
          '${item.language1Data.text.toLowerCase()}|${item.language2Data.text.toLowerCase()}';
      existingItemKeys.add(key);
    }

    for (int itemIndex = 0; itemIndex < jsonItems.length; itemIndex++) {
      final jsonItem = jsonItems[itemIndex];

      // Report progress
      onProgress?.call(itemIndex + 1, jsonItems.length);

      try {
        // Extract fields from JSON
        final sourceExpression = jsonItem['source_expression'] as String?;

        // Validate: source_expression is mandatory
        if (sourceExpression == null || sourceExpression.trim().isEmpty) {
          failedItems.add(
            'Item ${itemIndex + 1}: Missing mandatory field "source_expression"',
          );
          continue;
        }

        // Optional fields
        final sourcePre = (jsonItem['source_pre'] as String?)?.trim();
        final sourcePost = (jsonItem['source_post'] as String?)?.trim();
        final targetExpression = (jsonItem['target_expression'] as String?)?.trim();
        final targetPre = (jsonItem['target_pre'] as String?)?.trim();
        final targetPost = (jsonItem['target_post'] as String?)?.trim();

        // Examples (optional)
        final examplesJson = jsonItem['examples'] as List<dynamic>?;
        final examples = <ExampleSentence>[];
        if (examplesJson != null) {
          for (final exJson in examplesJson) {
            if (exJson is Map<String, dynamic>) {
              final sourceText = exJson['source'] as String? ?? '';
              final targetText = exJson['target'] as String? ?? '';
              examples.add(
                ExampleSentence(
                  id: const Uuid().v4(),
                  textLanguage1: sourceText,
                  textLanguage2: targetText,
                ),
              );
            }
          }
        }

        // Categories (optional)
        final categoriesJson = jsonItem['categories'] as List<dynamic>?;
        final categoryNames = <String>[];
        if (categoriesJson != null) {
          for (final catName in categoriesJson) {
            if (catName is String && catName.trim().isNotEmpty) {
              categoryNames.add(catName.trim());
            }
          }
        }

        // If no categories specified, add to default "Imported" category
        if (categoryNames.isEmpty) {
          categoryNames.add('Imported');
        }

        // Use empty string for target if not provided
        final targetText = targetExpression ?? '';

        // Check for duplicate
        final itemKey = '${sourceExpression.toLowerCase()}|${targetText.toLowerCase()}';
        if (existingItemKeys.contains(itemKey)) {
          failedItems.add(
            'Item ${itemIndex + 1}: Duplicate item "$sourceExpression | $targetText"',
          );
          continue;
        }

        // Create/get categories
        final itemCategoryIds = <String>[];
        for (final catName in categoryNames) {
          final catKey = catName.toLowerCase();

          if (!categoryMap.containsKey(catKey)) {
            // Create new category
            final newCat = Category(
              id: const Uuid().v4(),
              packageId: package.id,
              name: catName,
              description: null,
            );
            await _categoryRepo.insertCategory(newCat);
            categoryMap[catKey] = newCat;
          }

          itemCategoryIds.add(categoryMap[catKey]!.id);
        }

        // Create item
        final item = Item(
          id: const Uuid().v4(),
          packageId: package.id,
          categoryIds: itemCategoryIds,
          language1Data: ItemLanguageData(
            languageCode: package.languageCode1,
            text: sourceExpression.trim(),
            preItem: sourcePre?.isNotEmpty == true ? sourcePre : null,
            postItem: sourcePost?.isNotEmpty == true ? sourcePost : null,
          ),
          language2Data: ItemLanguageData(
            languageCode: package.languageCode2,
            text: targetText,
            preItem: targetPre?.isNotEmpty == true ? targetPre : null,
            postItem: targetPost?.isNotEmpty == true ? targetPost : null,
          ),
          examples: examples,
          isKnown: false,
          isFavourite: false,
          isImportant: false,
          dontKnowCounter: 1,
          lastReviewedAt: null,
        );

        await _itemRepo.insertItem(item);
        existingItemKeys.add(itemKey);

        final displayText = targetText.isNotEmpty
            ? '$sourceExpression | $targetText'
            : sourceExpression;
        successfulItems.add('$displayText (${categoryNames.join(", ")})');
      } catch (e) {
        failedItems.add('Item ${itemIndex + 1}: $e');
      }
    }

    return _ImportResult(successful: successfulItems, failed: failedItems);
  }

  Future<void> _openAITextAnalysis() async {
    if (widget.package == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AITextAnalysisPage(package: widget.package!),
      ),
    );
  }


  void _showImportResultDialog(AppLocalizations l10n, _ImportResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importResults),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${l10n.successfullyImported}: ${result.successful.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (result.successful.isNotEmpty) ...[
                  SizedBox(height: AppTheme.spacing8),
                  ...result.successful
                      .take(10)
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(
                            left: AppTheme.spacing8,
                            bottom: AppTheme.spacing8,
                          ),
                          child: Text(
                            '✓ $item',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                  if (result.successful.length > 10)
                    Padding(
                      padding: EdgeInsets.only(left: AppTheme.spacing8),
                      child: Text(
                        '... ${l10n.successfullyImported} ${result.successful.length - 10} ${l10n.items}',
                      ),
                    ),
                ],
                SizedBox(height: AppTheme.spacing8),
                Text(
                  '${l10n.failedToImport}: ${result.failed.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                if (result.failed.isNotEmpty) ...[
                  SizedBox(height: AppTheme.spacing8),
                  ...result.failed
                      .take(10)
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(
                            left: AppTheme.spacing8,
                            bottom: AppTheme.spacing8,
                          ),
                          child: Text(
                            '✗ $item',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                  if (result.failed.length > 10)
                    Padding(
                      padding: EdgeInsets.only(left: AppTheme.spacing8),
                      child: Text(
                        '... ${l10n.failedToImport} ${result.failed.length - 10} ${l10n.items}',
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _ImportResult {
  final List<String> successful;
  final List<String> failed;

  _ImportResult({required this.successful, required this.failed});
}

class _ImportProgress {
  final int current;
  final int total;

  _ImportProgress({required this.current, required this.total});

  double get progress => total > 0 ? current / total : 0.0;
}

class _ImportProgressDialog extends StatelessWidget {
  final ValueNotifier<_ImportProgress> progressNotifier;

  const _ImportProgressDialog({required this.progressNotifier});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.importingPackage),
      content: ValueListenableBuilder<_ImportProgress>(
        valueListenable: progressNotifier,
        builder: (context, progress, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: progress.progress, minHeight: 8),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                l10n.importProgress(progress.current, progress.total),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          );
        },
      ),
    );
  }
}

// Language Code Picker Dialog
class _LanguageCodePickerDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final void Function(String code, String name) onLanguageSelected;

  const _LanguageCodePickerDialog({
    required this.l10n,
    required this.onLanguageSelected,
  });

  @override
  State<_LanguageCodePickerDialog> createState() =>
      _LanguageCodePickerDialogState();
}

class _LanguageCodePickerDialogState extends State<_LanguageCodePickerDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languages = LanguageCodes.search(_searchQuery);

    return AlertDialog(
      title: Text(widget.l10n.selectLanguageCode),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: AppTheme.spacing8),
            _buildLanguageList(languages, theme),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      decoration: InputDecoration(
        hintText: l10n.search,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing8,
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildLanguageList(
    List<MapEntry<String, String>> languages,
    ThemeData theme,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) =>
            _buildLanguageListItem(languages[index], theme),
      ),
    );
  }

  Widget _buildLanguageListItem(
    MapEntry<String, String> entry,
    ThemeData theme,
  ) {
    return ListTile(
      title: Text(entry.value, style: theme.textTheme.bodyMedium),
      subtitle: Text(entry.key, style: theme.textTheme.bodySmall),
      onTap: () {
        widget.onLanguageSelected(entry.key, entry.value);
        Navigator.of(context).pop();
      },
    );
  }
}

