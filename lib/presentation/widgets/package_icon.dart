// lib/presentation/widgets/package_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show File;

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
    final bool isSvg = iconPath!.toLowerCase().endsWith('.svg');

    // Check if it's an asset path or file path
    if (iconPath!.startsWith('assets/')) {
      // Asset image - works on all platforms
      if (isSvg) {
        return SvgPicture.asset(
          iconPath!,
          width: size,
          height: size,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _buildDefaultIcon(context),
        );
      } else {
        return Image.asset(
          iconPath!,
          width: size,
          height: size,
          fit: fit,
          color: color,
          errorBuilder: (ctx, error, stackTrace) {
            return _buildDefaultIcon(ctx);
          },
        );
      }
    } else {
      // File path (for user-uploaded icons) - only supported on native platforms
      if (kIsWeb) {
        // On web, we cannot access local file system, show default icon
        return _buildDefaultIcon(context);
      } else {
        // Native platforms only
        return _buildFileIcon(context, isSvg);
      }
    }
  }

  Widget _buildFileIcon(BuildContext context, bool isSvg) {
    // This method is only called on native platforms, not on web
    try {
      final file = File(iconPath!);
      if (!file.existsSync()) {
        return _buildDefaultIcon(context);
      }

      if (isSvg) {
        return SvgPicture.file(
          file,
          width: size,
          height: size,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _buildDefaultIcon(context),
        );
      } else {
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
      }
    } catch (e) {
      // If any error occurs (e.g., file access denied), show default
      return _buildDefaultIcon(context);
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

