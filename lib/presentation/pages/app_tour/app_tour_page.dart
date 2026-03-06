// lib/presentation/pages/app_tour/app_tour_page.dart
//
// Full-screen App Tour - Multi-page walkthrough with navigation
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/clickable_text.dart';

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
    final isPhoneLandscape = !isTablet && isLandscape;

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
              // Header with close button (hidden on phone landscape to save space)
              if (!isPhoneLandscape) _buildHeader(l10n, theme),

              // Page content
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    // Swipe left (negative velocity) = next page
                    if (details.primaryVelocity! < -500) {
                      _nextPage();
                    }
                    // Swipe right (positive velocity) = previous page
                    else if (details.primaryVelocity! > 500) {
                      _previousPage();
                    }
                  },
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
    } else if (isTablet && !isLandscape) {
      // Tablet portrait: vertical layout with larger elements
      return _buildPortraitLayout(pageData, theme);
    } else {
      // Phone (both portrait and landscape): compact layout
      return _buildPhonePortraitLayout(pageData, theme);
    }
  }

  Widget _buildLandscapeTabletLayout(TourPageData pageData, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get available height (subtract padding)
        final availableHeight = constraints.maxHeight - (AppTheme.spacing24 * 2);

        return Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Icon, title, and description (vertically centered)
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIcon(pageData, theme, size: 120),
                        const SizedBox(height: AppTheme.spacing16),
                        Text(
                          pageData.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        _buildDescription(pageData, theme),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing32),
              // Right side: Screenshot (maximized with height constraint)
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: availableHeight,
                  child: _buildMaximizedScreenshot(theme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhonePortraitLayout(TourPageData pageData, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title and icon in a row
          Row(
            children: [
              Expanded(
                child: Text(
                  pageData.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              _buildIcon(pageData, theme, size: 50),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          _buildDescription(pageData, theme),
          const SizedBox(height: AppTheme.spacing8),
          _buildPlaceholderScreenshot(theme),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(TourPageData pageData, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(pageData, theme, size: 60),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              pageData.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing12),
            _buildDescription(pageData, theme),
            const SizedBox(height: AppTheme.spacing12),
            _buildPlaceholderScreenshot(theme),
          ],
        ),
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
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: ClickableText(
          text: pageData.description,
          style: theme.textTheme.bodyMedium,
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

  Widget _buildMaximizedScreenshot(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the constrained dimensions from parent
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Use 9:16 aspect ratio for a portrait screenshot
        final aspectRatio = 9 / 16;
        double width, height;

        if (maxWidth * (1 / aspectRatio) <= maxHeight) {
          // Width is the limiting factor
          width = maxWidth;
          height = width * (1 / aspectRatio);
        } else {
          // Height is the limiting factor
          height = maxHeight;
          width = height * aspectRatio;
        }

        return Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Screenshot placeholder',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationControls(AppLocalizations l10n, ThemeData theme) {
    final mediaQuery = MediaQuery.of(context);
    final isPhone = mediaQuery.size.shortestSide < 600;

    // For phones: reduce padding and use compact page indicator
    final padding = isPhone
        ? const EdgeInsets.all(AppTheme.spacing8)
        : const EdgeInsets.all(AppTheme.spacing16);

    final buttonPadding = isPhone
        ? const EdgeInsets.symmetric(horizontal: AppTheme.spacing8, vertical: AppTheme.spacing4)
        : const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing12);

    final buttonTextStyle = isPhone
        ? const TextStyle(fontSize: 12)
        : null;

    return Container(
      padding: padding,
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
              icon: Icon(Icons.arrow_back, size: isPhone ? 16 : 20),
              label: Text(l10n.previousPage, style: buttonTextStyle),
              style: OutlinedButton.styleFrom(
                padding: buttonPadding,
              ),
            ),
          ),
          SizedBox(width: isPhone ? AppTheme.spacing8 : AppTheme.spacing12),

          // Page indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isPhone ? AppTheme.spacing8 : AppTheme.spacing16,
              vertical: isPhone ? AppTheme.spacing4 : AppTheme.spacing8,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPhone
                  ? '${_currentPage + 1}/$_totalPages'
                  : l10n.pageIndicator(_currentPage + 1, _totalPages),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: isPhone ? 12 : null,
              ),
            ),
          ),

          SizedBox(width: isPhone ? AppTheme.spacing8 : AppTheme.spacing12),

          // Next button
          Expanded(
            child: FilledButton.icon(
              onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
              icon: Icon(Icons.arrow_forward, size: isPhone ? 16 : 20),
              label: Text(l10n.nextPage, style: buttonTextStyle),
              style: FilledButton.styleFrom(
                padding: buttonPadding,
              ),
            ),
          ),

          SizedBox(width: isPhone ? AppTheme.spacing8 : AppTheme.spacing12),

          // End Tour button (always visible)
          Expanded(
            child: FilledButton.icon(
              onPressed: _endTour,
              icon: Icon(Icons.check, size: isPhone ? 16 : 20),
              label: Text(l10n.endTour, style: buttonTextStyle),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: buttonPadding,
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

