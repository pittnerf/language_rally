import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _versionLabel = '-';

  static const List<_AboutFeature> _features = [
    _AboutFeature(imagePath: 'assets/images/1_Language_power.webp', titleKey: 'featureLangPower'),
    _AboutFeature(imagePath: 'assets/images/2_AI_integration.webp', titleKey: 'featureAiIntegration'),
    _AboutFeature(imagePath: 'assets/images/3_Adaptive practice.webp', titleKey: 'featureAdaptivePractice'),
    _AboutFeature(imagePath: 'assets/images/4_Master_accent.webp', titleKey: 'featureMasterAccent'),
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _versionLabel = '${info.version}+${info.buildNumber}';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _versionLabel = '-';
      });
    }
  }

  Future<void> _openWebsite(String websiteUrl, AppLocalizations l10n) async {
    final uri = Uri.parse(websiteUrl);
    await _launchUri(uri, l10n);
  }

  Future<void> _sendEmail(String supportEmail, AppLocalizations l10n) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
    );
    await _launchUri(uri, l10n);
  }

  Future<void> _launchUri(Uri uri, AppLocalizations l10n) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutCouldNotOpen(uri.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final summaryVideoUrl = l10n.aboutSummaryVideoUrl;
    final websiteUrl = l10n.aboutWebsiteUrl;
    final supportEmail = l10n.aboutSupportEmailAddress;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        l10n.aboutVersionWithValue(_versionLabel),
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing20),
                      _SectionCard(
                        backgroundColor: colors.primaryContainer,
                        titleColor: colors.onPrimaryContainer,
                        title: l10n.aboutSummaryVideo,
                        child: InkWell(
                          onTap: () => _openWebsite(summaryVideoUrl, l10n),
                          child: Text(
                            summaryVideoUrl,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      _SectionCard(
                        backgroundColor: colors.primaryContainer,
                        titleColor: colors.onPrimaryContainer,
                        title: l10n.aboutWebsite,
                        child: InkWell(
                          onTap: () => _openWebsite(websiteUrl, l10n),
                          child: Text(
                            websiteUrl,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      _SectionCard(
                        backgroundColor: colors.tertiaryContainer,
                        titleColor: colors.onTertiaryContainer,
                        title: l10n.aboutLanguageRally,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = constraints.maxWidth >= 520 ? 2 : 1;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _features.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: AppTheme.spacing12,
                                mainAxisSpacing: AppTheme.spacing12,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final feature = _features[index];
                                final l10n = AppLocalizations.of(context)!;
                                final title = _featureTitle(l10n, feature.titleKey);
                                return _FeatureCard(
                                  imagePath: feature.imagePath,
                                  title: title,
                                  theme: theme,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      _SectionCard(
                        backgroundColor: colors.secondaryContainer,
                        titleColor: colors.onSecondaryContainer,
                        title: l10n.aboutSupportEmail,
                        child: InkWell(
                          onTap: () => _sendEmail(supportEmail, l10n),
                          child: Text(
                            supportEmail,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.secondary,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    required this.backgroundColor,
    required this.titleColor,
  });

  final String title;
  final Widget child;
  final Color backgroundColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            child,
          ],
        ),
      ),
    );
  }
}

class _AboutFeature {
  const _AboutFeature({
    required this.imagePath,
    required this.titleKey,
  });

  final String imagePath;
  final String titleKey;
}

String _featureTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'featureLangPower': return l10n.featureLangPower;
    case 'featureAiIntegration': return l10n.featureAiIntegration;
    case 'featureAdaptivePractice': return l10n.featureAdaptivePractice;
    case 'featureMasterAccent': return l10n.featureMasterAccent;
    default: return key;
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.imagePath,
    required this.title,
    required this.theme,
  });

  final String imagePath;
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: theme.colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(AppTheme.spacing12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          // ...existing gradient code...
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.68),
                ],
                stops: const [0.52, 0.76, 1.0],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: const [
                    Shadow(
                      blurRadius: 4,
                      offset: Offset(0, 1),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

