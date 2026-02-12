// lib/presentation/pages/font_test_page.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Simple page to verify Inter fonts are loaded correctly
class FontTestPage extends StatelessWidget {
  const FontTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inter Font Test'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          children: [
          _buildFontTest(
            context,
            'Regular (400)',
            'The quick brown fox jumps over the lazy dog',
            FontWeight.w400,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildFontTest(
            context,
            'Medium (500)',
            'The quick brown fox jumps over the lazy dog',
            FontWeight.w500,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildFontTest(
            context,
            'SemiBold (600)',
            'The quick brown fox jumps over the lazy dog',
            FontWeight.w600,
          ),
          const SizedBox(height: AppTheme.spacing24),
          _buildFontTest(
            context,
            'Bold (700)',
            'The quick brown fox jumps over the lazy dog',
            FontWeight.w700,
          ),
          const SizedBox(height: AppTheme.spacing32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'If you see Inter font rendering above (not system default), '
                    'the fonts are correctly installed!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: Text(
                          'Inter fonts loaded successfully',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildFontTest(
    BuildContext context,
    String label,
    String text,
    FontWeight weight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: weight,
          ),
        ),
      ],
    );
  }
}

