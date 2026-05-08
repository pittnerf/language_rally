import 'package:flutter/material.dart';
import 'package:language_rally/l10n/app_localizations.dart';
import '../../../../data/models/store_product.dart';

/// A card that displays a single [StoreProduct] in the store catalog.
///
/// States:
///  • **Not purchased** — shows price and an "Add to Cart" / "Remove" button
///  • **Purchased, not imported** — shows a "Download" button
///  • **Downloading** — shows a linear progress indicator
///  • **Imported** — shows a "✓ Installed" chip (greyed out)
///
/// The action is placed in the same row as the description to keep the card
/// as compact as possible.
class ProductCard extends StatelessWidget {
  final StoreProduct product;
  final AppLocalizations l;
  final bool isInCart;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;
  final VoidCallback? onDownload;

  const ProductCard({
    super.key,
    required this.product,
    required this.l,
    this.isInCart = false,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ─────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                _LevelBadge(level: product.level),
              ],
            ),

            const SizedBox(height: 4),

            // ── Description + action row ───────────────────────────────────
            if (product.isDownloading)
              _DownloadProgress(progress: product.downloadProgress, l: l)
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Description (takes all available space)
                  if (product.description.isNotEmpty)
                    Expanded(
                      child: Text(
                        product.description,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    const Spacer(),

                  // Action area
                  if (product.isImported)
                    _InstalledChip(colorScheme: colorScheme, l: l)
                  else if (product.isPurchased)
                    _CartIconButton(
                      tooltip: l.storeDownload,
                      icon: Icons.download_rounded,
                      active: false,
                      onPressed: onDownload,
                      colorScheme: colorScheme,
                    )
                  else ...[
                    if (product.localizedPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        product.localizedPrice!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    _CartIconButton(
                      tooltip: isInCart
                          ? l.storeRemoveFromCart
                          : l.storeAddToCart,
                      icon: isInCart
                          ? Icons.shopping_cart_rounded
                          : Icons.add_shopping_cart_rounded,
                      active: isInCart,
                      onPressed: isInCart ? onRemoveFromCart : onAddToCart,
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

// ── Helper widgets ──────────────────────────────────────────────────────────────

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
  final AppLocalizations l;
  const _InstalledChip({required this.colorScheme, required this.l});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.check_circle_rounded,
          size: 16, color: colorScheme.onSecondaryContainer),
      label: Text(l.storeInstalledLabel),
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Small icon button used inside the product card's action slot.
///
/// When [active] is true (item is in cart) the button uses the primary
/// container colour so it feels "selected".
class _CartIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool active;
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  const _CartIconButton({
    required this.tooltip,
    required this.icon,
    required this.active,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        foregroundColor: active
            ? colorScheme.onPrimaryContainer
            : colorScheme.primary,
        backgroundColor: active
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(6),
        minimumSize: const Size(36, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}

class _DownloadProgress extends StatelessWidget {
  final double progress;
  final AppLocalizations l;
  const _DownloadProgress({required this.progress, required this.l});

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
        Text(l.storeDownloading,
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
