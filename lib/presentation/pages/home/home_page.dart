import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/clickable_text.dart';
import '../packages/package_list_page.dart';
import '../packages/package_form_page.dart';
import '../training/training_settings_page.dart';
import '../dev/test_data_page.dart';
import '../settings/app_settings_page.dart';
import '../app_tour/app_tour_page.dart';
import '../../../core/utils/debug_print.dart';
import '../dev/bulk_package_import_page.dart';
import '../items/global_search_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _welcomePanelScrollController = ScrollController();

  @override
  void dispose() {
    _welcomePanelScrollController.dispose();
    super.dispose();
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          // Watch the theme provider to rebuild dialog when theme changes
          final currentConfig = ref.watch(themeProvider);

          // Use fixed text styles to prevent size changes when theme switches
          const titleTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0.5,
          );

          const subtitleTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.33,
            letterSpacing: 0.4,
          );

          const headerTextStyle = TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
            letterSpacing: 0.15,
          );

          return AlertDialog(
            title: const Text('Choose Theme'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dark/Light mode toggle
                    SwitchListTile(
                      title: const Text('Dark Mode', style: titleTextStyle),
                      subtitle: const Text('Toggle between light and dark', style: subtitleTextStyle),
                      value: currentConfig.isDarkMode,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).setDarkMode(value);
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Color Theme:', style: headerTextStyle),
                    const SizedBox(height: 8),
                    // Theme options
                    ...AppThemeOption.values.map((option) {
                      return RadioListTile<AppThemeOption>(
                        title: Text(option.displayName, style: titleTextStyle),
                        subtitle: Text(option.description, style: subtitleTextStyle),
                        value: option,
                        // ignore: deprecated_member_use
                        groupValue: currentConfig.themeOption,
                        // ignore: deprecated_member_use
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(themeProvider.notifier).setThemeOption(value);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeConfig = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 900;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTabletLandscape = isTablet && isLandscape;
    final isTabletPortrait = isTablet && !isLandscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeConfig.isDarkMode
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest,
                  ]
                : [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    theme.colorScheme.surface,
                    theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
                  ],
          ),
        ),
        child: isTabletLandscape
            ? _buildTabletLandscapeLayout(context, ref, localizations, theme, themeConfig)
            : isTabletPortrait
                ? _buildTabletPortraitLayout(context, ref, localizations, theme, themeConfig)
                : _buildPhoneLayout(context, ref, localizations, theme, themeConfig),
      ),
    );
  }

  Widget _buildTabletLandscapeLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    ThemeConfig themeConfig,
  ) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Main content (buttons vertically centered)
          SizedBox(
            width: 450, // Fixed width for button area
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(context, ref, localizations, theme, themeConfig),
                    const SizedBox(height: AppTheme.spacing32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildMainButtons(context, localizations, theme, isTablet: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side - Welcome panel (fixed height card with internal scrolling)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: _buildWelcomePanel(context, localizations, theme, isTablet: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    ThemeConfig themeConfig,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing12), // Reduced padding for phones
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, ref, localizations, theme, themeConfig),
            const SizedBox(height: AppTheme.spacing16), // Reduced spacing for phones
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildMainButtons(context, localizations, theme, isTablet: false),
              ),
            ),
            const SizedBox(height: AppTheme.spacing16), // Reduced spacing for phones
            _buildWelcomePanel(context, localizations, theme, isTablet: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletPortraitLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    ThemeConfig themeConfig,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, ref, localizations, theme, themeConfig),
            const SizedBox(height: AppTheme.spacing32),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildMainButtons(context, localizations, theme, isTablet: true),
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),
            _buildWelcomePanel(context, localizations, theme, isTablet: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    ThemeConfig themeConfig,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.appTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              // const SizedBox(height: AppTheme.spacing8),
              // Text(
              //  localizations.welcome,
              //  style: theme.textTheme.titleMedium?.copyWith(
              //    color: theme.colorScheme.onSurfaceVariant,
              //  ),
              //),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme brightness toggle button
            IconButton(
              icon: Icon(themeConfig.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle brightness',
              onPressed: () {
                ref.read(themeProvider.notifier).toggleBrightness();
              },
            ),
            // Theme selector button
            IconButton(
              icon: const Icon(Icons.palette),
              tooltip: 'Change theme',
              onPressed: () => _showThemeSelector(context, ref),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainButtons(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme, {
    required bool isTablet,
  }) {
    // For phones: half the padding and smaller font size
    final buttonPadding = isTablet
        ? const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing24,
            vertical: AppTheme.spacing16,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing8,
          );

    final iconSize = isTablet ? 24.0 : 20.0;
    final fontSize = isTablet ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Package List Button (First - Primary Action)
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PackageListPage()),
            );
          },
          icon: Icon(Icons.library_books, size: iconSize),
          label: Text(
            localizations.viewPackages,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),

        // Global Search Button
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GlobalSearchPage()),
            );
          },
          icon: Icon(Icons.manage_search, size: iconSize),
          label: Text(
            localizations.globalSearch,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrainingSettingsPage()),
            );
          },
          icon: Icon(Icons.school, size: iconSize),
          label: Text(
            localizations.startTrainingRally,
            style: TextStyle(fontSize: fontSize),
          ),
          style: FilledButton.styleFrom(
            padding: buttonPadding,
            elevation: 4,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),

        // Practice Pronunciation Button (Third)
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TrainingSettingsPage(isPronunciationMode: true),
              ),
            );
          },
          icon: Icon(Icons.record_voice_over, size: iconSize),
          label: Text(
            localizations.practicePronunciation,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),

        // Create Package Button
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PackageFormPage()),
            );
          },
          icon: Icon(Icons.add_circle_outline, size: iconSize),
          label: Text(
            localizations.createNewPackage,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),

        // Browse Store Button
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to package store page when implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${localizations.browseStore} - Coming soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: Icon(Icons.storefront, size: iconSize),
          label: Text(
            localizations.browseStore,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),

        // Settings Button
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppSettingsPage()),
            );
          },
          icon: Icon(Icons.settings, size: iconSize),
          label: Text(
            localizations.settings,
            style: TextStyle(fontSize: fontSize),
          ),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
          ),
        ),

    if (PRINT_DEBUG) ...[
        const SizedBox(height: AppTheme.spacing12),

        // Test Data Generator Button (Dev Tool)
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TestDataPage()),
            );
          },
          icon: Icon(Icons.science, size: iconSize),
          label: Text(
            localizations.generateTestData,
            style: TextStyle(fontSize: fontSize),
          ),
          style: OutlinedButton.styleFrom(
            padding: buttonPadding,
            side: BorderSide(
              color: theme.colorScheme.secondary,
              width: 2,
            ),
            foregroundColor: theme.colorScheme.secondary,
          ),
        ),
        ],


        // Bulk Package Import – admin tool, only shown in debug builds
        if (PRINT_DEBUG) ...[
          const SizedBox(height: AppTheme.spacing12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BulkPackageImportPage(),
                ),
              );
            },
            icon: Icon(Icons.download_for_offline_outlined, size: iconSize),
            label: Text(
              'Bulk Package Import',
              style: TextStyle(fontSize: fontSize),
            ),
            style: OutlinedButton.styleFrom(
              padding: buttonPadding,
              side: BorderSide(color: theme.colorScheme.error, width: 2),
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWelcomePanel(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme, {
    required bool isTablet,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Calculate card height only for tablets
    double? cardHeight;
    if (isTablet) {
      final screenHeight = mediaQuery.size.height;
      if (isLandscape) {
        // Landscape mode: subtract padding for SafeArea
        cardHeight = screenHeight - 48.0;
      } else {
        // Portrait mode: calculate available height more carefully
        // Account for: SafeArea top/bottom, header, spacing, and buttons area
        final estimatedButtonsHeight = 600.0; // Approximate height of buttons and header
        cardHeight = screenHeight - estimatedButtonsHeight;
        // Ensure minimum height
        if (cardHeight < 300) cardHeight = 300;
      }
    }

    final contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App icon
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/app_icons/language_rally_race.png',
              width: 96,
              height: 96,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing24),

        // Title
        Text(
          localizations.welcomeTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        // Subtitle
        Text(
          localizations.welcomeSubtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        // Intro
        Text(
          localizations.welcomeIntro,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: Play Your Game
        _buildWelcomeSection(
          theme,
          localizations.sectionPlayYourGame,
          localizations.sectionPlayYourGameDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: AI Teammate
        _buildWelcomeSection(
          theme,
          localizations.sectionAITeammate,
          localizations.sectionAITeammateDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: Train Smart
        _buildWelcomeSection(
          theme,
          localizations.sectionTrainSmart,
          localizations.sectionTrainSmartDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: Real Examples
        _buildWelcomeSection(
          theme,
          localizations.sectionRealExamples,
          localizations.sectionRealExamplesDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: Teachers Welcome
        _buildWelcomeSection(
          theme,
          localizations.sectionTeachersWelcome,
          localizations.sectionTeachersWelcomeDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Section: Unlock AI Power
        _buildWelcomeSection(
          theme,
          localizations.sectionUnlockAI,
          localizations.sectionUnlockAIDesc,
        ),
        const SizedBox(height: AppTheme.spacing24),
        const Divider(),
        const SizedBox(height: AppTheme.spacing24),

        // Ready to start
        Center(
          child: Text(
            localizations.readyToStart,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Start App Tour button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              _showAppTour(context, localizations, theme);
            },
            icon: const Icon(Icons.tour),
            label: Text(localizations.startAppTour),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacing16,
              ),
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );

    // For tablets: use fixed height with scrollbar
    if (isTablet && cardHeight != null) {
      return Card(
        elevation: 4,
        child: SizedBox(
          height: cardHeight,
          child: Scrollbar(
            controller: _welcomePanelScrollController,
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(4),
            child: SingleChildScrollView(
              controller: _welcomePanelScrollController,
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: contentWidget,
            ),
          ),
        ),
      );
    }

    // For phones: no fixed height, no scrollbar (parent SingleChildScrollView handles scrolling)
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: contentWidget,
      ),
    );
  }

  Widget _buildWelcomeSection(
    ThemeData theme,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        ClickableText(
          text: description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  void _showAppTour(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AppTourPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
