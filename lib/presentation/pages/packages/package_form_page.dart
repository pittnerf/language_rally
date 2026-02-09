// lib/presentation/pages/packages/package_form_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/language_codes.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/language_package_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/import_export_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/package_icon.dart';

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
  final _categoryRepo = CategoryRepository();
  final _itemRepo = ItemRepository();
  late final ImportExportRepository _importExportRepo;

  // Form controllers
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
  bool get _isEditMode => widget.package != null;
  bool get _isReadOnly => widget.package?.isReadonly ?? false;
  bool get _isPurchased => widget.package?.isPurchased ?? false;

  // Available icons
  final List<String?> _availableIcons = [
    null, // Default icon
    'assets/images/package_icon_v1.svg',
    'assets/images/package_icon_v2.png',
  ];

  @override
  void initState() {
    super.initState();
    _importExportRepo = ImportExportRepository(
      packageRepo: _packageRepo,
      categoryRepo: _categoryRepo,
      itemRepo: _itemRepo,
    );
    _initializeControllers();
  }

  void _initializeControllers() {
    final pkg = widget.package;
    _languageCode1Controller = TextEditingController(text: pkg?.languageCode1 ?? '');
    _languageName1Controller = TextEditingController(text: pkg?.languageName1 ?? '');
    _languageCode2Controller = TextEditingController(text: pkg?.languageCode2 ?? '');
    _languageName2Controller = TextEditingController(text: pkg?.languageName2 ?? '');
    _descriptionController = TextEditingController(text: pkg?.description ?? '');
    _authorNameController = TextEditingController(text: pkg?.authorName ?? '');
    _authorEmailController = TextEditingController(text: pkg?.authorEmail ?? '');
    _authorWebpageController = TextEditingController(text: pkg?.authorWebpage ?? '');
    _versionController = TextEditingController(text: pkg?.version ?? '1.0');
    _selectedIcon = pkg?.icon;
  }

  @override
  void dispose() {
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

    if (_isPurchased || _isReadOnly) {
      return _buildReadOnlyWarning(context, l10n, theme);
    }

    return Scaffold(
      appBar: _buildAppBar(context, theme, l10n),
      body: _buildBody(context, l10n),
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

  AppBar _buildAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return AppBar(
      title: Text(
        _isEditMode ? l10n.editPackage : l10n.createPackage,
        style: theme.textTheme.headlineSmall,
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

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(AppTheme.spacing16),
        children: _buildFormFields(context, l10n),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context, AppLocalizations l10n) {
    return [
      _buildSectionHeader(context, l10n.packageDetails),
      SizedBox(height: AppTheme.spacing16),
      _buildIconSelector(context, l10n),
      SizedBox(height: AppTheme.spacing24),
      // Package details section with background
      _buildPackageDetailsSection(context, l10n),
      SizedBox(height: AppTheme.spacing24),
      // Author fields without section header
      _buildResponsiveAuthorFields(context, l10n),
      SizedBox(height: AppTheme.spacing16),
      _buildTextField(context, l10n, _authorWebpageController, l10n.authorWebpage, keyboardType: TextInputType.url, validator: _validateUrl),
      SizedBox(height: AppTheme.spacing32),
      _buildActionButtons(context, l10n),
      SizedBox(height: AppTheme.spacing16),
    ];
  }

  Widget _buildPackageDetailsSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing16),
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
          _buildResponsiveLanguageFields(context, l10n),
          SizedBox(height: AppTheme.spacing16),
          _buildTextField(context, l10n, _descriptionController, l10n.description, maxLines: 3, hint: l10n.descriptionHint),
        ],
      ),
    );
  }

  Widget _buildResponsiveLanguageFields(BuildContext context, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Wide layout: All 4 fields in one row (code1, name1, code2, name2)
        // Threshold: ~900px for comfortable 4-field layout
        if (availableWidth >= 900) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildLanguageCodeField(context, l10n, _languageCode1Controller, l10n.languageCode1, true),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    flex: 3,
                    child: _buildTextField(context, l10n, _languageName1Controller, l10n.languageName1, required: true),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    flex: 2,
                    child: _buildLanguageCodeField(context, l10n, _languageCode2Controller, l10n.languageCode2, false),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    flex: 3,
                    child: _buildTextField(context, l10n, _languageName2Controller, l10n.languageName2, required: true),
                  ),
                ],
              ),
            ],
          );
        }

        // Medium layout: Source language in one row, target in another
        // Threshold: ~600px for comfortable 2-field layout
        else if (availableWidth >= 600) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildLanguageCodeField(context, l10n, _languageCode1Controller, l10n.languageCode1, true),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    flex: 3,
                    child: _buildTextField(context, l10n, _languageName1Controller, l10n.languageName1, required: true),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildLanguageCodeField(context, l10n, _languageCode2Controller, l10n.languageCode2, false),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    flex: 3,
                    child: _buildTextField(context, l10n, _languageName2Controller, l10n.languageName2, required: true),
                  ),
                ],
              ),
            ],
          );
        }

        // Narrow layout: Each field gets its own row
        else {
          return Column(
            children: [
              _buildLanguageCodeField(context, l10n, _languageCode1Controller, l10n.languageCode1, true),
              SizedBox(height: AppTheme.spacing16),
              _buildTextField(context, l10n, _languageName1Controller, l10n.languageName1, required: true),
              SizedBox(height: AppTheme.spacing16),
              _buildLanguageCodeField(context, l10n, _languageCode2Controller, l10n.languageCode2, false),
              SizedBox(height: AppTheme.spacing16),
              _buildTextField(context, l10n, _languageName2Controller, l10n.languageName2, required: true),
            ],
          );
        }
      },
    );
  }

  Widget _buildResponsiveAuthorFields(BuildContext context, AppLocalizations l10n) {
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
                child: _buildTextField(context, l10n, _authorNameController, l10n.authorName),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                flex: 2,
                child: _buildTextField(context, l10n, _authorEmailController, l10n.authorEmail, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                flex: 1,
                child: _buildTextField(context, l10n, _versionController, l10n.version, required: true),
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
                    child: _buildTextField(context, l10n, _authorNameController, l10n.authorName),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: _buildTextField(context, l10n, _authorEmailController, l10n.authorEmail, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing16),
              _buildTextField(context, l10n, _versionController, l10n.version, required: true),
            ],
          );
        }

        // Narrow layout: Each field gets its own row
        else {
          return Column(
            children: [
              _buildTextField(context, l10n, _authorNameController, l10n.authorName),
              SizedBox(height: AppTheme.spacing16),
              _buildTextField(context, l10n, _authorEmailController, l10n.authorEmail, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              SizedBox(height: AppTheme.spacing16),
              _buildTextField(context, l10n, _versionController, l10n.version, required: true),
            ],
          );
        }
      },
    );
  }

  Widget _buildReadOnlyWarning(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editPackage),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: theme.colorScheme.outline,
              ),
              SizedBox(height: AppTheme.spacing24),
              Text(
                _isPurchased ? l10n.purchasedPackage : l10n.readOnlyPackage,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.spacing24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildIconSelector(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIconSelectorTitle(theme, colorScheme, l10n),
        SizedBox(height: AppTheme.spacing12),
        _buildIconGrid(colorScheme),
        SizedBox(height: AppTheme.spacing8),
        _buildIconDescription(theme, colorScheme, l10n),
      ],
    );
  }

  Widget _buildIconSelectorTitle(ThemeData theme, ColorScheme colorScheme, AppLocalizations l10n) {
    return Text(
      l10n.packageIcon,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildIconGrid(ColorScheme colorScheme) {
    return Wrap(
      spacing: AppTheme.spacing16,
      runSpacing: AppTheme.spacing16,
      children: _availableIcons.map((icon) => _buildIconItem(icon, colorScheme)).toList(),
    );
  }

  Widget _buildIconItem(String? icon, ColorScheme colorScheme) {
    final isSelected = _selectedIcon == icon;

    return GestureDetector(
      onTap: () => _onIconSelected(icon),
      child: Container(
        width: 80,
        height: 80,
        decoration: _buildIconItemDecoration(isSelected, colorScheme),
        child: Center(
          child: PackageIcon(iconPath: icon, size: 48),
        ),
      ),
    );
  }

  BoxDecoration _buildIconItemDecoration(bool isSelected, ColorScheme colorScheme) {
    return BoxDecoration(
      border: Border.all(
        color: isSelected ? colorScheme.primary : colorScheme.outline,
        width: isSelected ? 3 : 1,
      ),
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
    );
  }

  void _onIconSelected(String? icon) {
    setState(() {
      _selectedIcon = icon;
    });
  }

  Widget _buildIconDescription(ThemeData theme, ColorScheme colorScheme, AppLocalizations l10n) {
    return Text(
      _selectedIcon == null ? l10n.defaultIcon : l10n.customIcon,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildLanguageCodeField(
    BuildContext context,
    AppLocalizations l10n,
    TextEditingController controller,
    String label,
    bool isSource,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'e.g., en, hu, de',
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: colorScheme.primary),
          onPressed: () => _showLanguageCodePicker(context, controller, isSource),
          tooltip: l10n.selectLanguageCode,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      style: theme.textTheme.bodyLarge,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.fieldRequired;
        }
        return null;
      },
      onChanged: (value) {
        // Auto-fill language name if code is recognized
        final languageName = LanguageCodes.getLanguageName(value.trim());
        if (languageName != null) {
          if (isSource) {
            _languageName1Controller.text = languageName;
          } else {
            _languageName2Controller.text = languageName;
          }
        }
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
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      style: theme.textTheme.bodyLarge,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator ??
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
        final buttonsCanFitInOneRow = _isEditMode ? availableWidth >= 550 : true;

        return Column(
          children: [
            // Export and Import buttons (if editing)
            if (_isEditMode) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _exportPackage,
                      icon: const Icon(Icons.file_download),
                      label: Text(l10n.exportPackage),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _importItems,
                      icon: const Icon(Icons.file_upload),
                      label: Text(l10n.importItems),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing16),
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
              ),
            ),
          ),
          SizedBox(width: AppTheme.spacing8),
        ],
        // Cancel button
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ),
        SizedBox(width: AppTheme.spacing8),
        // Save button
        Expanded(
          flex: _isEditMode ? 1 : 2,
          child: ElevatedButton(
            onPressed: _savePackage,
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsInTwoRows(BuildContext context, AppLocalizations l10n) {
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
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing12),
        ],
        // Second row: Cancel and Save
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _savePackage,
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showLanguageCodePicker(
    BuildContext context,
    TextEditingController controller,
    bool isSource,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) => _LanguageCodePickerDialog(
        l10n: l10n,
        onLanguageSelected: (code, name) => _onLanguageCodeSelected(controller, isSource, code, name),
      ),
    );
  }

  void _onLanguageCodeSelected(
    TextEditingController controller,
    bool isSource,
    String code,
    String name,
  ) {
    controller.text = code;
    if (isSource) {
      _languageName1Controller.text = name;
    } else {
      _languageName2Controller.text = name;
    }
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final package = LanguagePackage(
        id: widget.package?.id ?? const Uuid().v4(),
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
        Navigator.of(context).pop(true); // Return true to indicate success
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

    // Let user select text file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv'],
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
      final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();

      if (lines.isEmpty) {
        _showImportFormatDialog(l10n);
        return;
      }

      final importResult = await _processImportLines(lines);

      if (mounted) {
        _showImportResultDialog(l10n, importResult);
      }
    } catch (e) {
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

  Future<_ImportResult> _processImportLines(List<String> lines) async {
    final successfulItems = <String>[];
    final failedItems = <String>[];
    final package = widget.package!;

    // Get existing items to check for duplicates
    final existingCategories = await _categoryRepo.getCategoriesForPackage(package.id);
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
      final key = '${item.language1Data.text.toLowerCase()}|${item.language2Data.text.toLowerCase()}';
      existingItemKeys.add(key);
    }

    for (final line in lines) {
      try {
        final parts = line.split('|');

        if (parts.length < 2) {
          failedItems.add('$line (Invalid format: missing fields)');
          continue;
        }

        final lang1Text = parts[0].trim();
        final lang2Text = parts[1].trim();

        if (lang1Text.isEmpty || lang2Text.isEmpty) {
          failedItems.add('$line (Invalid format: empty text)');
          continue;
        }

        // Check for duplicate
        final itemKey = '${lang1Text.toLowerCase()}|${lang2Text.toLowerCase()}';
        if (existingItemKeys.contains(itemKey)) {
          failedItems.add('$line (Duplicate item)');
          continue;
        }

        // Parse categories
        final categories = <String>[];
        if (parts.length >= 3 && parts[2].trim().isNotEmpty) {
          final catPart = parts[2].trim();
          categories.addAll(catPart.split(';').map((c) => c.trim()).where((c) => c.isNotEmpty));
        }

        // If no categories specified, add to a default "Imported" category
        if (categories.isEmpty) {
          categories.add('Imported');
        }

        // Create/get categories
        final itemCategoryIds = <String>[];
        for (final catName in categories) {
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
            text: lang1Text,
            preItem: null,
            postItem: null,
          ),
          language2Data: ItemLanguageData(
            languageCode: package.languageCode2,
            text: lang2Text,
            preItem: null,
            postItem: null,
          ),
          examples: [],
          isKnown: false,
          isFavourite: false,
          isImportant: false,
          dontKnowCounter: 0,
          lastReviewedAt: null,
        );

        await _itemRepo.insertItem(item);
        existingItemKeys.add(itemKey);
        successfulItems.add('$lang1Text | $lang2Text (${categories.join(", ")})');
      } catch (e) {
        failedItems.add('$line (Error: $e)');
      }
    }

    return _ImportResult(
      successful: successfulItems,
      failed: failedItems,
    );
  }

  void _showImportFormatDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importFormat),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.importFormatDescription),
              SizedBox(height: AppTheme.spacing16),
              Text(
                'Format:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppTheme.spacing8),
              Container(
                padding: EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  '<${widget.package!.languageName1}>|<${widget.package!.languageName2}>|<category1>;<category2>;',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              SizedBox(height: AppTheme.spacing16),
              Text(
                'Examples:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppTheme.spacing8),
              Container(
                padding: EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  'hello|hola|greetings;\ncat|gato|animals;pets;\nbook|libro|',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              SizedBox(height: AppTheme.spacing16),
              Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppTheme.spacing8),
              Text('• Each line represents one item'),
              Text('• Fields are separated by |'),
              Text('• Categories are separated by ;'),
              Text('• The last | is optional'),
              Text('• Empty lines are ignored'),
              Text('• Duplicates are skipped'),
            ],
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (result.successful.isNotEmpty) ...[
                  SizedBox(height: AppTheme.spacing8),
                  ...result.successful.take(10).map((item) => Padding(
                    padding: EdgeInsets.only(left: AppTheme.spacing8, bottom: 4),
                    child: Text('✓ $item', style: TextStyle(fontSize: 12)),
                  )),
                  if (result.successful.length > 10)
                    Padding(
                      padding: EdgeInsets.only(left: AppTheme.spacing8),
                      child: Text('... and ${result.successful.length - 10} more'),
                    ),
                ],
                SizedBox(height: AppTheme.spacing16),
                Text(
                  '${l10n.failedToImport}: ${result.failed.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                if (result.failed.isNotEmpty) ...[
                  SizedBox(height: AppTheme.spacing8),
                  ...result.failed.take(10).map((item) => Padding(
                    padding: EdgeInsets.only(left: AppTheme.spacing8, bottom: 4),
                    child: Text('✗ $item', style: TextStyle(fontSize: 12)),
                  )),
                  if (result.failed.length > 10)
                    Padding(
                      padding: EdgeInsets.only(left: AppTheme.spacing8),
                      child: Text('... and ${result.failed.length - 10} more'),
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

  _ImportResult({
    required this.successful,
    required this.failed,
  });
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
  State<_LanguageCodePickerDialog> createState() => _LanguageCodePickerDialogState();
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
            SizedBox(height: AppTheme.spacing16),
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
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildLanguageList(List<MapEntry<String, String>> languages, ThemeData theme) {
    return Expanded(
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) => _buildLanguageListItem(languages[index], theme),
      ),
    );
  }

  Widget _buildLanguageListItem(MapEntry<String, String> entry, ThemeData theme) {
    return ListTile(
      title: Text(entry.value, style: theme.textTheme.bodyLarge),
      subtitle: Text(entry.key.toUpperCase(), style: theme.textTheme.bodySmall),
      onTap: () {
        widget.onLanguageSelected(entry.key, entry.value);
        Navigator.of(context).pop();
      },
    );
  }
}
