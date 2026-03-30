// lib/presentation/pages/onboarding/onboarding_screen.dart
//
// First-launch onboarding wizard.
// Step 1: Welcome + UI language selection.
// Step 2: Choose which bundled language-package groups to import.
//
// Can also be opened standalone (startAtStep: 1) from PackageListPage
// to let the user import additional built-in packages at any time.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/app_initialization_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  /// Called once the wizard finishes (import done or skipped).
  /// When null the screen simply pops itself via Navigator.
  final VoidCallback? onComplete;

  /// Which step to start on.
  /// 0 = welcome + language selection (default, used for initial onboarding).
  /// 1 = package-group selection only (used when opened from PackageListPage).
  final int startAtStep;

  const OnboardingScreen({
    super.key,
    this.onComplete,
    this.startAtStep = 0,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // ── Wizard step ────────────────────────────────────────────────────────────
  late int _step;

  // ── Step 2: scan state ────────────────────────────────────────────────────
  bool _isScanning = false;
  bool _scanDone = false;
  Map<String, List<String>> _groupToAssets = {};
  Set<String> _selectedGroups = {};

  // ── Step 2: import state ──────────────────────────────────────────────────
  bool _isImporting = false;
  bool _importDone = false;
  late SeedingProgress _importProgress;

  // ── Supported UI languages ────────────────────────────────────────────────
  static const Map<String, String> _uiLanguages = {
    'en': 'English',
    'hu': 'Magyar (Hungarian)',
  };

  @override
  void initState() {
    super.initState();
    _step = widget.startAtStep;
    _importProgress = AppInitializationService.seedingProgress.value;
    AppInitializationService.seedingProgress.addListener(_onProgress);

    // If we're opening directly at the package-selection step, begin scanning
    // immediately so the user doesn't have to tap anything first.
    if (_step == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScan());
    }
  }

  @override
  void dispose() {
    AppInitializationService.seedingProgress.removeListener(_onProgress);
    super.dispose();
  }

  void _onProgress() {
    if (!mounted) return;
    setState(() {
      _importProgress = AppInitializationService.seedingProgress.value;
      if (_isImporting && !_importProgress.isActive) {
        _isImporting = false;
        _importDone = true;
      }
    });
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goToStep2() {
    setState(() => _step = 1);
    _startScan();
  }

  void _goBack() {
    if (widget.startAtStep == 1) {
      // Opened standalone – just close the screen.
      _finish();
    } else {
      setState(() {
        _step = 0;
        _scanDone = false;
        _groupToAssets = {};
        _selectedGroups = {};
        _isImporting = false;
        _importDone = false;
      });
    }
  }

  // ── Finish / completion ────────────────────────────────────────────────────

  /// Closes the wizard: calls [onComplete] if provided, otherwise pops.
  void _finish() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  // ── Scanning ───────────────────────────────────────────────────────────────

  Future<void> _startScan() async {
    setState(() => _isScanning = true);
    final groups = await AppInitializationService.scanSeedPackageGroups();
    if (!mounted) return;
    setState(() {
      _groupToAssets = groups;
      _selectedGroups = Set.from(groups.keys); // pre-select everything
      _isScanning = false;
      _scanDone = true;
    });
  }

  // ── Import ─────────────────────────────────────────────────────────────────

  Future<void> _startImport() async {
    setState(() => _isImporting = true);
    await AppInitializationService.importSelectedGroups(
      _selectedGroups,
      _groupToAssets,
    );
    // _onProgress() will flip _isImporting → false and _importDone → true
    // but guard here in case the notifier fires before we return
    if (mounted && !_importDone) {
      setState(() {
        _isImporting = false;
        _importDone = true;
      });
    }
  }

  Future<void> _skip() async {
    // Only mark onboarding complete when in the initial onboarding flow.
    if (widget.startAtStep == 0) {
      await AppInitializationService.markOnboardingComplete();
    }
    if (mounted) _finish();
  }

  void _getStarted() => _finish();

  // ── Toggle helpers ─────────────────────────────────────────────────────────

  void _toggleGroup(String group) {
    setState(() {
      if (_selectedGroups.contains(group)) {
        _selectedGroups.remove(group);
      } else {
        _selectedGroups.add(group);
      }
    });
  }

  void _selectAll() =>
      setState(() => _selectedGroups = Set.from(_groupToAssets.keys));

  void _deselectAll() => setState(() => _selectedGroups.clear());

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return _step == 0 ? _buildWelcomePage(context) : _buildPackagePage(context);
  }

  // ---------------------------------------------------------------------------
  // Step 1 – Welcome + language picker
  // ---------------------------------------------------------------------------

  Widget _buildWelcomePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: AppTheme.spacing32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo ──────────────────────────────────────────────────
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/app_icons/language_rally_race.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // ── Title ─────────────────────────────────────────────────
                  Text(
                    l10n.onboardingWelcomeTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    l10n.onboardingSetupSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // ── Divider ───────────────────────────────────────────────
                  Divider(color: theme.colorScheme.outlineVariant),
                  const SizedBox(height: AppTheme.spacing24),

                  // ── Language section header ────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.translate,
                          color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        l10n.onboardingSelectUiLanguage,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing12),

                  // ── Language dropdown ──────────────────────────────────────
                  DropdownButtonFormField<String>(
                    initialValue: currentLocale.languageCode,
                    decoration: InputDecoration(
                      labelText: l10n.uiLanguage,
                      prefixIcon: const Icon(Icons.language),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    items: _uiLanguages.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(entry.value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(localeProvider.notifier)
                            .setLocale(Locale(value));
                      }
                    },
                  ),
                  const SizedBox(height: AppTheme.spacing8),

                  // ── Note ──────────────────────────────────────────────────
                  Text(
                    l10n.onboardingUiLanguageNote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // ── Next button ───────────────────────────────────────────
                  FilledButton.icon(
                    onPressed: _goToStep2,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.onboardingNext),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacing16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2 – Package group selection + import
  // ---------------------------------------------------------------------------

  Widget _buildPackagePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.onboardingBack,
          // Disable back while importing; after import done only allow back
          // if we are in standalone mode (startAtStep==1).
          onPressed: _isImporting
              ? null
              : (_importDone && widget.startAtStep == 0)
                  ? null
                  : _goBack,
        ),
        title: Text(l10n.onboardingSelectPackagesTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: _buildPackagePageBody(context, l10n, theme),
              ),
            ),
            _buildBottomBar(context, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagePageBody(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (_isScanning) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              l10n.onboardingAnalyzingPackages,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isImporting) return _buildImportProgress(l10n, theme);
    if (_importDone) return _buildImportComplete(l10n, theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingSelectPackagesSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        if (_scanDone && _groupToAssets.isNotEmpty) ...[
          Row(
            children: [
              TextButton.icon(
                onPressed: _selectAll,
                icon: const Icon(Icons.check_box, size: 18),
                label: Text(l10n.onboardingSelectAll),
              ),
              const SizedBox(width: AppTheme.spacing8),
              TextButton.icon(
                onPressed: _deselectAll,
                icon: const Icon(Icons.check_box_outline_blank, size: 18),
                label: Text(l10n.onboardingDeselectAll),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
        ],

        if (_scanDone)
          ..._groupToAssets.entries.map(
            (entry) =>
                _buildGroupTile(entry.key, entry.value.length, l10n, theme),
          ),
      ],
    );
  }

  Widget _buildGroupTile(
    String groupName,
    int packageCount,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isChecked = _selectedGroups.contains(groupName);
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        side: BorderSide(
          color: isChecked
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: isChecked ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (_isImporting || _importDone)
            ? null
            : (_) => _toggleGroup(groupName),
        title: Text(
          groupName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          l10n.onboardingNPackages(packageCount),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        secondary: Icon(
          Icons.library_books_outlined,
          color: isChecked
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: theme.colorScheme.primary,
        checkColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildImportProgress(AppLocalizations l10n, ThemeData theme) {
    final fraction = _importProgress.fraction;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Text(
            l10n.onboardingImportSelected,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            child: LinearProgressIndicator(
              value: fraction > 0 ? fraction : null,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            '${_importProgress.current} / ${_importProgress.total}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'This only happens once.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportComplete(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            l10n.onboardingImportCompleteTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            '${_importProgress.current} / ${_importProgress.total} '
            '${l10n.onboardingNPackages(_importProgress.total)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (_isScanning) return const SizedBox.shrink();

    // After import – "Get Started" (initial onboarding) or "Close" (standalone)
    if (_importDone) {
      return Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _getStarted,
            icon: widget.startAtStep == 1
                ? const Icon(Icons.close)
                : const Icon(Icons.rocket_launch_outlined),
            label: Text(widget.startAtStep == 1
                ? l10n.onboardingBack
                : l10n.onboardingGetStarted),
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
        ),
      );
    }

    // During import – nothing
    if (_isImporting) return const SizedBox.shrink();

    // Normal state – Import Selected + Skip/Cancel
    final canImport = _selectedGroups.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing16,
        0,
        AppTheme.spacing16,
        AppTheme.spacing16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canImport ? _startImport : null,
              icon: const Icon(Icons.download_for_offline_outlined),
              label: Text(l10n.onboardingImportSelected),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          TextButton(
            onPressed: _skip,
            child: Text(l10n.onboardingSkipImport),
          ),
        ],
      ),
    );
  }
}

