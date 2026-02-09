# Default Package Icon

This folder contains the default dictionary icon used when a package doesn't have a custom icon.

## Files

- `default_package_icon.svg` - SVG version (recommended)
- `default_package_icon.png` - PNG version (128x128, fallback)

## Usage

```dart
// Display package icon with fallback to default
Widget buildPackageIcon(LanguagePackage package) {
  if (package.icon != null && package.icon!.isNotEmpty) {
    // Custom icon provided
    return Image.asset(
      package.icon!,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
    );
  } else {
    // Use default dictionary icon
    return Image.asset(
      'assets/images/default_package_icon.png',
      width: 64,
      height: 64,
      fit: BoxFit.contain,
    );
  }
}
```

## Custom Icons

To use a custom icon for a package:

1. Add your icon image to `assets/images/` (or subdirectory)
2. Update `pubspec.yaml` if needed
3. Set the `icon` field when creating the package:

```dart
LanguagePackage(
  // ...other fields
  icon: 'assets/images/flags/german_flag.png',
  // ...
)
```

## Recommended Icon Specifications

- **Format**: PNG or SVG
- **Size**: 128x128 pixels (or higher resolution for retina displays)
- **Style**: Simple, clear, recognizable
- **Colors**: Match app theme (soft teal #4A9B8E preferred)
- **Background**: Transparent

## TODO

Replace `default_package_icon.png` with a professionally designed dictionary icon if needed.
The current icon is a placeholder created for development.

