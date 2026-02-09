# Language Rally Design System

A calm, modern, language-learning focused design system built with Material 3.

## Overview

The Language Rally design system prioritizes:
- **Calm aesthetics** - Soft colors that reduce cognitive load
- **Rounded corners** - Friendly, approachable UI elements
- **Minimal clutter** - Clean, focused interfaces
- **Language learning context** - Visual cues for learning states

## Color Palette

### Philosophy
Our color scheme uses soft teal/blue-green as primary (calming, focus-promoting) with warm coral accents for actions and soft purple for tertiary elements.

### Light Theme
- **Primary**: Soft Teal `#4A9B8E` - Main brand color, calm and professional
- **Secondary**: Warm Coral `#E27D60` - Call-to-action, warm and inviting
- **Tertiary**: Soft Purple `#8B7AB8` - Accent elements, creative touch
- **Background**: Off-white `#F8FAF9` - Easy on the eyes
- **Surface**: Pure white `#FFFFFF` - Cards and elevated elements

### Dark Theme
- **Primary**: Light Teal `#9DD4C8` - Softer for dark backgrounds
- **Secondary**: Soft Coral `#FFB4A1` - Warm accent
- **Tertiary**: Lavender `#D0BCFF` - Gentle accent
- **Background**: Dark Gray `#191C1B` - True dark mode
- **Surface**: Dark Surface `#1F2221` - Elevated elements

### Learning State Colors
- **Known Item**: Green `#66BB6A` - Mastered vocabulary
- **Unknown Item**: Red `#EF5350` - Needs practice
- **Learning Item**: Yellow `#FFCA28` - In progress

## Typography

### Font Family: Inter
A highly readable, modern sans-serif designed for UI. Excellent legibility at all sizes.

### Type Scale (Material 3)

#### Display
- **Display Large**: 57px, Regular - Hero text
- **Display Medium**: 45px, Regular - Large emphasis
- **Display Small**: 36px, Regular - Moderate emphasis

#### Headlines
- **Headline Large**: 32px, SemiBold - Page titles
- **Headline Medium**: 28px, SemiBold - Section headers
- **Headline Small**: 24px, SemiBold - Subsection headers

#### Titles
- **Title Large**: 22px, Medium - Card titles
- **Title Medium**: 16px, SemiBold - List items, prominent labels
- **Title Small**: 14px, SemiBold - Dense list items

#### Body
- **Body Large**: 16px, Regular - Primary body text
- **Body Medium**: 14px, Regular - Secondary body text
- **Body Small**: 12px, Regular - Caption text

#### Labels
- **Label Large**: 14px, SemiBold - Buttons, prominent labels
- **Label Medium**: 12px, SemiBold - Chips, tags
- **Label Small**: 11px, Medium - Small labels

## Components

### Buttons

#### Rounded Design
All buttons use 12px border radius for a soft, friendly feel.

#### Types
- **Filled Button**: Primary actions (training, saving)
- **Outlined Button**: Secondary actions (cancel, skip)
- **Text Button**: Tertiary actions (dismiss, learn more)

#### Padding
- Horizontal: 24px
- Vertical: 16px

### Cards

#### Style
- Border radius: 12px (medium)
- Elevation: 0 (flat with subtle border)
- Border: 1px outline variant color
- Margin: 8px

#### Use Cases
- Language package cards
- Vocabulary item cards
- Statistics summaries
- Training session cards

### Chips

#### Style
- Border radius: 8px (small)
- Padding: 12px horizontal, 8px vertical
- No border (flat style)
- Selected state uses secondary container color

#### Use Cases
- Category filters
- Language tags
- Difficulty levels
- Learning status indicators

### Text Fields

#### Style
- Border radius: 12px (medium)
- Filled variant (background color)
- 16px padding
- 2px focus border

#### States
- Default: Subtle border, surface background
- Focused: Primary color border (2px)
- Error: Error color border

### Dialogs & Bottom Sheets

#### Style
- Border radius: 24px (extra large) for modern look
- Elevation: 3 (subtle shadow)
- Surface background color

## Spacing System

Consistent spacing using 4px base unit:

- **4px**: Minimal gaps (chip internal padding)
- **8px**: Small gaps (card margins, list items)
- **12px**: Medium gaps (button padding)
- **16px**: Standard gaps (section padding, input fields)
- **20px**: Large gaps (between sections)
- **24px**: Extra large gaps (button horizontal padding)
- **32px**: Huge gaps (major section separators)

## Border Radius Scale

- **Small (8px)**: Chips, small elements
- **Medium (12px)**: Buttons, cards, text fields
- **Large (16px)**: FABs, larger cards
- **Extra Large (24px)**: Dialogs, bottom sheets

## Usage Examples

### Accessing Colors
```dart
// In widgets
final primary = Theme.of(context).colorScheme.primary;

// Direct access (avoid in widgets)
final knownColor = AppColors.knownItem;
```

### Accessing Text Styles
```dart
// Preferred method
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineLarge,
)

// Direct access
Text(
  'Hello',
  style: AppFonts.headlineLarge,
)
```

### Using Spacing
```dart
// With constants
Padding(
  padding: EdgeInsets.all(AppTheme.spacing16),
  child: ...
)

// For rounded corners
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
  ),
)
```

## Installation

### Inter Font Setup

1. Download Inter font from [Google Fonts](https://fonts.google.com/specimen/Inter)
2. Extract the following font files to `assets/fonts/`:
   - Inter-Regular.ttf (400 weight)
   - Inter-Medium.ttf (500 weight)
   - Inter-SemiBold.ttf (600 weight)
   - Inter-Bold.ttf (700 weight)

3. The fonts are already configured in `pubspec.yaml`

### Quick Download Commands

```bash
# Create fonts directory if it doesn't exist
mkdir -p assets/fonts

# Download from Google Fonts or use a package manager
# Alternatively, manually download from https://fonts.google.com/specimen/Inter
```

## Accessibility

- **Contrast ratios**: All text meets WCAG AA standards (4.5:1 for normal text, 3:1 for large text)
- **Touch targets**: Minimum 48x48dp for all interactive elements
- **Font sizes**: Minimum 12px for any readable text
- **Color independence**: Never rely solely on color to convey information

## Best Practices

1. **Always use theme colors** - Never hardcode colors
2. **Use semantic names** - `Theme.of(context).colorScheme.primary` not `AppColors.primaryLight`
3. **Consistent spacing** - Use the spacing constants
4. **Consistent radius** - Use the radius constants for corners
5. **Test both themes** - Always verify light and dark mode
6. **Use Material 3 components** - Prefer new Material 3 widgets

## Files

- `app_theme.dart` - Main theme configuration
- `app_colors.dart` - Color palette definitions
- `app_fonts.dart` - Typography system

