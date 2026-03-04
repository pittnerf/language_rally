// lib/presentation/pages/app_tour/app_tour_page.dart
//
// Full-screen App Tour - Multi-page walkthrough with navigation
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class AppTourPage extends StatefulWidget {
  const AppTourPage({super.key});

  @override
  State<AppTourPage> createState() => _AppTourPageState();
}

class _AppTourPageState extends State<AppTourPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 8;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _endTour() {
    Navigator.of(context).pop();
  }

  List<TourPageData> _getTourPages(AppLocalizations l10n) {
    return [
      TourPageData(
        title: l10n.tourPage1Title,
        description: l10n.tourPage1Desc,
        icon: Icons.psychology,
        iconColor: Colors.purple,
      ),
      TourPageData(
        title: l10n.tourPage2Title,
        description: l10n.tourPage2Desc,
        icon: Icons.create,
        iconColor: Colors.blue,
      ),
      TourPageData(
        title: l10n.tourPage3Title,
        description: l10n.tourPage3Desc,
        icon: Icons.auto_awesome,
        iconColor: Colors.amber,
      ),
      TourPageData(
        title: l10n.tourPage4Title,
        description: l10n.tourPage4Desc,
        icon: Icons.translate,
        iconColor: Colors.teal,
      ),
      TourPageData(
        title: l10n.tourPage5Title,
        description: l10n.tourPage5Desc,
        icon: Icons.folder_special,
        iconColor: Colors.orange,
      ),
      TourPageData(
        title: l10n.tourPage6Title,
        description: l10n.tourPage6Desc,
        icon: Icons.record_voice_over,
        iconColor: Colors.pink,
      ),
      TourPageData(
        title: l10n.tourPage7Title,
        description: l10n.tourPage7Desc,
        icon: Icons.school,
        iconColor: Colors.green,
      ),
      TourPageData(
        title: l10n.tourPage8Title,
        description: l10n.tourPage8Desc,
        icon: Icons.key,
        iconColor: Colors.deepPurple,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet = mediaQuery.size.shortestSide >= 600;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: theme.colorScheme.surface,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header with close button
              _buildHeader(l10n, theme),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    final pages = _getTourPages(l10n);
                    return _buildTourPage(
                      context,
                      pages[index],
                      theme,
                      isLandscape,
                      isTablet,
                    );
                  },
                ),
              ),

              // Navigation controls
              _buildNavigationControls(l10n, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.tour,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appTourTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.appTourSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _endTour,
            tooltip: l10n.endTour,
          ),
        ],
      ),
    );
  }

  Widget _buildTourPage(
    BuildContext context,
    TourPageData pageData,
    ThemeData theme,
    bool isLandscape,
    bool isTablet,
  ) {
    if (isLandscape && isTablet) {
      // Tablet landscape: side-by-side layout
      return _buildLandscapeTabletLayout(pageData, theme);
    } else if (isLandscape && !isTablet) {
      // Phone landscape: compact side-by-side
      return _buildLandscapePhoneLayout(pageData, theme);
    } else {
      // Portrait: vertical layout
      return _buildPortraitLayout(pageData, theme);
    }
  }

  Widget _buildLandscapeTabletLayout(TourPageData pageData, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Icon and title
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(pageData, theme, size: 120),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  pageData.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacing32),
          // Right side: Description
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescription(pageData, theme),
                const SizedBox(height: AppTheme.spacing24),
                _buildPlaceholderScreenshot(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapePhoneLayout(TourPageData pageData, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Icon and title (compact)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(pageData, theme, size: 80),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  pageData.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          // Right side: Description (compact)
          Expanded(
            flex: 2,
            child: _buildDescription(pageData, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(TourPageData pageData, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(pageData, theme, size: 100),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            pageData.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildDescription(pageData, theme),
          const SizedBox(height: AppTheme.spacing24),
          _buildPlaceholderScreenshot(theme),
        ],
      ),
    );
  }

  Widget _buildIcon(TourPageData pageData, ThemeData theme, {double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: pageData.iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        pageData.icon,
        size: size * 0.5,
        color: pageData.iconColor,
      ),
    );
  }

  Widget _buildDescription(TourPageData pageData, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Text(
          pageData.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderScreenshot(ThemeData theme) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Screenshot placeholder',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentPage > 0 ? _previousPage : null,
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.previousPage),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),

          // Page indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.pageIndicator(_currentPage + 1, _totalPages),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacing12),

          // Next or End button
          Expanded(
            child: _currentPage < _totalPages - 1
                ? FilledButton.icon(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.nextPage),
                  )
                : FilledButton.icon(
                    onPressed: _endTour,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.endTour),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TourPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  TourPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

