// lib/presentation/widgets/package_icon.dart
import 'package:flutter/material.dart';
import 'dart:io';

/// Widget to display a package icon with automatic fallback to default dictionary icon
class PackageIcon extends StatelessWidget {
  final String? iconPath;
  final double size;
  final BoxFit fit;
  final Color? color;

  const PackageIcon({
    super.key,
    this.iconPath,
    this.size = 64.0,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // If custom icon is provided, try to load it
    if (iconPath != null && iconPath!.isNotEmpty) {
      return _buildCustomIcon(context);
    }

    // Otherwise show default dictionary icon
    return _buildDefaultIcon(context);
  }

  Widget _buildCustomIcon(BuildContext context) {
    // Check if it's an asset path or file path
    if (iconPath!.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        iconPath!,
        width: size,
        height: size,
        fit: fit,
        color: color,
        errorBuilder: (ctx, error, stackTrace) {
          // If custom icon fails to load, show default
          return _buildDefaultIcon(ctx);
        },
      );
    } else {
      // File path (for user-uploaded icons)
      final file = File(iconPath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: fit,
          color: color,
          errorBuilder: (ctx, error, stackTrace) {
            return _buildDefaultIcon(ctx);
          },
        );
      } else {
        return _buildDefaultIcon(context);
      }
    }
  }

  Widget _buildDefaultIcon(BuildContext context) {
    // Default dictionary icon
    // Using Material Icons as fallback if image not available
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.1) ??
               Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.6,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Compact version for list items
class PackageIconSmall extends StatelessWidget {
  final String? iconPath;
  final Color? color;

  const PackageIconSmall({
    super.key,
    this.iconPath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PackageIcon(
      iconPath: iconPath,
      size: 40,
      color: color,
    );
  }
}

/// Large version for package cards
class PackageIconLarge extends StatelessWidget {
  final String? iconPath;
  final Color? color;

  const PackageIconLarge({
    super.key,
    this.iconPath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PackageIcon(
      iconPath: iconPath,
      size: 80,
      color: color,
    );
  }
}

