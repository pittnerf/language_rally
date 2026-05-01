import 'package:flutter/material.dart';
import '../../../../data/models/store_product.dart';

/// A card that displays a single [StoreProduct] in the store catalog.
///
/// States:
///  • **Not purchased** — shows price and a "Buy" button
///  • **Purchased, not imported** — shows a "Download" button
///  • **Downloading** — shows a linear progress indicator
///  • **Imported** — shows a "✓ Installed" chip (greyed out)
class ProductCard extends StatelessWidget {
  final StoreProduct product;
  final VoidCallback? onBuy;
  final VoidCallback? onDownload;

  const ProductCard({
    super.key,
    required this.product,
    this.onBuy,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                _LevelBadge(level: product.level),
              ],
            ),

            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                product.description,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // ── Action row ───────────────────────────────────────────────
            if (product.isDownloading)
              _DownloadProgress(progress: product.downloadProgress)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (product.isImported)
                    _InstalledChip(colorScheme: colorScheme)
                  else if (product.isPurchased)
                    _ActionButton(
                      label: 'Download',
                      icon: Icons.download_rounded,
                      onPressed: onDownload,
                      colorScheme: colorScheme,
                    )
                  else ...[
                    if (product.localizedPrice != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          product.localizedPrice!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    _ActionButton(
                      label: 'Buy',
                      icon: Icons.shopping_cart_rounded,
                      onPressed: onBuy,
                      colorScheme: colorScheme,
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    if (level.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _InstalledChip extends StatelessWidget {
  final ColorScheme colorScheme;
  const _InstalledChip({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.check_circle_rounded,
          size: 16, color: colorScheme.onSecondaryContainer),
      label: const Text('Installed'),
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      padding: EdgeInsets.zero,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _DownloadProgress extends StatelessWidget {
  final double progress;
  const _DownloadProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              progress > 0 ? '${(progress * 100).round()}%' : '…',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Downloading…',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

