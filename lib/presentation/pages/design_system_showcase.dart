// lib/presentation/pages/design_system_showcase.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

/// Design System Showcase
/// Visual reference for all theme components and colors
class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        children: [
          _buildSection(
            context,
            'Colors',
            _buildColorPalette(context),
          ),
          _buildSection(
            context,
            'Typography',
            _buildTypography(context),
          ),
          _buildSection(
            context,
            'Buttons',
            _buildButtons(context),
          ),
          _buildSection(
            context,
            'Cards',
            _buildCards(context),
          ),
          _buildSection(
            context,
            'Chips',
            _buildChips(context),
          ),
          _buildSection(
            context,
            'Input Fields',
            _buildInputs(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppTheme.spacing24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppTheme.spacing16),
        content,
      ],
    );
  }

  Widget _buildColorPalette(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [
        _colorSwatch(context, 'Primary', colorScheme.primary),
        _colorSwatch(context, 'Secondary', colorScheme.secondary),
        _colorSwatch(context, 'Tertiary', colorScheme.tertiary),
        _colorSwatch(context, 'Error', colorScheme.error),
        _colorSwatch(context, 'Surface', colorScheme.surface),
        _colorSwatch(context, 'Known', AppColors.knownItem),
        _colorSwatch(context, 'Unknown', AppColors.unknownItem),
        _colorSwatch(context, 'Learning', AppColors.learningItem),
      ],
    );
  }

  Widget _colorSwatch(BuildContext context, String label, Color color) {
    final isLight = color.computeLuminance() > 0.5;
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isLight
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTypography(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: AppTheme.spacing8),
        Text('Display Medium', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text('Display Small', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppTheme.spacing16),
        Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: AppTheme.spacing8),
        Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppTheme.spacing16),
        Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppTheme.spacing8),
        Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppTheme.spacing16),
        Text('Body Large - The quick brown fox jumps over the lazy dog.',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppTheme.spacing8),
        Text('Body Medium - The quick brown fox jumps over the lazy dog.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text('Body Small - The quick brown fox jumps over the lazy dog.',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppTheme.spacing16),
        Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppTheme.spacing8),
        Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: () {},
          child: const Text('Filled Button'),
        ),
        const SizedBox(height: AppTheme.spacing8),
        FilledButton.tonal(
          onPressed: () {},
          child: const Text('Filled Tonal Button'),
        ),
        const SizedBox(height: AppTheme.spacing8),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Elevated Button'),
        ),
        const SizedBox(height: AppTheme.spacing8),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined Button'),
        ),
        const SizedBox(height: AppTheme.spacing8),
        TextButton(
          onPressed: () {},
          child: const Text('Text Button'),
        ),
        const SizedBox(height: AppTheme.spacing16),
        Row(
          children: [
            FilledButton(
              onPressed: null,
              child: const Text('Disabled'),
            ),
            const SizedBox(width: AppTheme.spacing8),
            OutlinedButton(
              onPressed: null,
              child: const Text('Disabled'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'This is a card with rounded corners (12px radius) and a subtle border. Perfect for language packages and vocabulary items.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    'Colored Card with Container Color',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChips(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [
        Chip(
          label: const Text('Basic Chip'),
          onDeleted: () {},
        ),
        Chip(
          avatar: const Icon(Icons.check, size: 16),
          label: const Text('Known'),
          backgroundColor: AppColors.knownItem,
        ),
        Chip(
          avatar: const Icon(Icons.close, size: 16),
          label: const Text('Unknown'),
          backgroundColor: AppColors.unknownItem,
        ),
        Chip(
          avatar: const Icon(Icons.schedule, size: 16),
          label: const Text('Learning'),
          backgroundColor: AppColors.learningItem,
        ),
        FilterChip(
          label: const Text('Filter Chip'),
          selected: false,
          onSelected: (value) {},
        ),
        FilterChip(
          label: const Text('Selected'),
          selected: true,
          onSelected: (value) {},
        ),
        ActionChip(
          label: const Text('Action Chip'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Label',
            hintText: 'Hint text',
            helperText: 'Helper text',
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'With Prefix Icon',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Error State',
            errorText: 'This field is required',
            prefixIcon: Icon(Icons.error_outline),
          ),
        ),
      ],
    );
  }
}


