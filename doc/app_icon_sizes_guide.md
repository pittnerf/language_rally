 # App Icon — Required Sizes & Export Guide

## Icon Concepts

| File | Theme | Palette |
|---|---|---|
| `icon_concept_1_speech_rally.svg` | Two speech bubbles **L / R**, checkered racing strip | Indigo → Violet |
| `icon_concept_2_book_blaze.svg` | Open book with lightning bolt | Burnt-orange → Gold |
| `icon_concept_3_globe_connect.svg` | Globe + speech bubble with "..." | Dark teal → Forest green |

All three SVGs use a `1024 × 1024` viewBox and are fully vector — export them at any
resolution without quality loss.

---

## Recommended Export Tool

**Inkscape** (free, cross-platform) — `File → Export PNG Image → set width/height → Export`

Or use any of:
- **Figma** (import SVG, export PNG at 1×/2×/3× etc.)
- **Adobe Illustrator**
- Online: **svgtopng.com** or **cloudconvert.com**

> ⚠️ For **iOS / macOS** the PNG must have **no alpha channel** (no transparency in
> the background) — the SVGs already fulfil this since they have a solid `<rect>`
> background covering the full canvas.

---

## Google Play Store

| Asset | Size (px) | Notes |
|---|---|---|
| **Play Store icon** | **512 × 512** | Required for store listing |
| Adaptive icon — foreground | 108 × 108 dp → **432 × 432** (xxxhdpi) | Safe zone: centre 72dp |
| Adaptive icon — background | 108 × 108 dp → **432 × 432** (xxxhdpi) | Can be solid colour |
| xxxhdpi launcher | 192 × 192 | `mipmap-xxxhdpi/ic_launcher.png` |
| xxhdpi launcher  | 144 × 144 | `mipmap-xxhdpi/ic_launcher.png` |
| xhdpi launcher   | 96 × 96   | `mipmap-xhdpi/ic_launcher.png` |
| hdpi launcher    | 72 × 72   | `mipmap-hdpi/ic_launcher.png` |
| mdpi launcher    | 48 × 48   | `mipmap-mdpi/ic_launcher.png` |

---

## Apple App Store (iOS / iPadOS)

| Asset | Size (px) | Usage |
|---|---|---|
| **App Store listing** | **1024 × 1024** | Required; no rounded corners, no alpha |
| iPhone app icon @3× | 180 × 180 | iPhone (primary) |
| iPhone app icon @2× | 120 × 120 | iPhone |
| iPad app icon @2×   | 152 × 152 | iPad |
| iPad Pro icon @2×   | 167 × 167 | iPad Pro |
| Spotlight @3×       | 120 × 120 | Search results |
| Spotlight @2×       | 80 × 80   | Search results |
| Settings @3×        | 87 × 87   | Settings app |
| Settings @2×        | 58 × 58   | Settings app |
| Notification @3×    | 60 × 60   | Notification centre |
| Notification @2×    | 40 × 40   | Notification centre |

> Flutter tip: place the **1024 × 1024** PNG at `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
> and run `flutter_launcher_icons` to auto-generate all sizes.

---

## macOS App Store

| Asset | Size (px) |
|---|---|
| App Store listing | 1024 × 1024 |
| @2× icon          | 512 × 512   |
| @1× icon          | 256 × 256   |
| Dock / Finder     | 128 × 128   |
| Small             | 32 × 32     |
| Tiny              | 16 × 16     |

---

## Microsoft Store (Windows)

| Asset | Size (px) | Notes |
|---|---|---|
| **Store display icon**  | **300 × 300** | Required |
| Square 44 logo          | 44 × 44, 88 × 88, 176 × 176 | Scale 100 / 200 / 400 % |
| Square 150 logo         | 150 × 150, 300 × 300, 600 × 600 | |
| Wide 310 × 150 logo     | 310 × 150, 620 × 300 | Wide tile |
| Square 310 logo         | 310 × 310, 620 × 620 | Large tile |
| Splash screen           | 620 × 300 | |
| Badge logo              | 24 × 24   | Monochrome / white only |

> Windows icons must be **PNG** with transparent background *or* solid fill.
> The SVGs here use a solid fill so both work.

---

## Fastest Way to Generate All Sizes — `flutter_launcher_icons`

1. Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon_1024.png"   # your chosen concept at 1024×1024
  min_sdk_android: 21
  adaptive_icon_background: "#1A237E"             # match your icon background colour
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
  windows:
    generate: true
    image_path: "assets/images/app_icon_1024.png"
    icon_size: 48
  macos:
    generate: true
    image_path: "assets/images/app_icon_1024.png"
```

2. Run:

```bash
flutter pub get
dart run flutter_launcher_icons
```

This automatically creates every density variant for Android and iOS, and
places them in the correct platform folders.

