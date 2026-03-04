# Home Page Quick Reference

## Component Hierarchy

```
HomePage (ConsumerWidget)
│
├─ build()
│  ├─ Scaffold with gradient background
│  └─ SafeArea
│     ├─ _buildTabletLandscapeLayout() [if width ≥ 900px & landscape]
│     └─ _buildPhonePortraitLayout() [otherwise]
│
├─ _buildTabletLandscapeLayout()
│  └─ Row
│     ├─ Left: Main Content (flex: 2)
│     │  ├─ _buildHeader()
│     │  └─ _buildMainButtons()
│     └─ Right: Welcome Panel (flex: 1)
│        └─ _buildWelcomePanel()
│
├─ _buildPhonePortraitLayout()
│  └─ Column
│     ├─ _buildHeader()
│     ├─ _buildMainButtons()
│     └─ _buildWelcomePanel()
│
├─ _buildHeader()
│  └─ Row [App Title + Theme Controls]
│
├─ _buildMainButtons()
│  └─ Column [5 Navigation Buttons]
│     ├─ Start Training Rally (FilledButton)
│     ├─ View Packages (ElevatedButton)
│     ├─ Create New Package (ElevatedButton)
│     ├─ Settings (ElevatedButton)
│     └─ Generate Test Data (OutlinedButton)
│
├─ _buildWelcomePanel()
│  └─ Card
│     ├─ Header with icon
│     ├─ Description text
│     ├─ 4 × _buildFeatureItem()
│     └─ Start App Tour button
│
├─ _buildFeatureItem(icon, title, description)
│  └─ Row [Icon Container + Text Column]
│
├─ _showThemeSelector()
│  └─ AlertDialog [Dark/Light + Color Theme]
│
├─ _showAppTour()
│  └─ AlertDialog
│     ├─ 5 × _buildTourStep()
│     └─ Actions [Got it! | View Packages]
│
└─ _buildTourStep(number, title, description)
   └─ Row [Circular Badge + Text Column]
```

## Key Methods

| Method | Purpose | Returns |
|--------|---------|---------|
| `build()` | Main build method, determines layout | Widget |
| `_buildTabletLandscapeLayout()` | Two-column layout for tablets | Widget |
| `_buildPhonePortraitLayout()` | Single-column layout for phones | Widget |
| `_buildHeader()` | App title and theme controls | Widget |
| `_buildMainButtons()` | Navigation button column | Widget |
| `_buildWelcomePanel()` | Feature showcase card | Widget |
| `_buildFeatureItem()` | Individual feature row | Widget |
| `_showThemeSelector()` | Opens theme picker dialog | void |
| `_showAppTour()` | Opens quick start guide | void |
| `_buildTourStep()` | Tour step with number | Widget |

## Responsive Breakpoint

```dart
final isTabletLandscape = mediaQuery.size.width >= 900 && 
                          mediaQuery.orientation == Orientation.landscape;
```

## Navigation Routes

| Button | Destination | Type |
|--------|-------------|------|
| Start Training Rally | `TrainingSettingsPage` | Primary Action |
| View Packages | `PackageListPage` | Secondary Action |
| Create New Package | `PackageFormPage` | Secondary Action |
| Settings | `AppSettingsPage` | Secondary Action |
| Generate Test Data | `TestDataPage` | Dev Tool |
| Start App Tour → View Packages | `PackageListPage` | Tour Action |

## Theme Integration

### Gradient Colors (Light Mode)
```dart
colors: [
  theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
  theme.colorScheme.surface,
  theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
]
```

### Gradient Colors (Dark Mode)
```dart
colors: [
  theme.colorScheme.surface,
  theme.colorScheme.surfaceContainerHighest,
]
```

### Button Colors
- **Primary:** `theme.colorScheme.primary` (FilledButton)
- **Secondary:** `theme.colorScheme.secondary` (App Tour button)
- **Dev Tool:** `theme.colorScheme.secondary` (border)

## Spacing Constants

| Location | Spacing |
|----------|---------|
| Page padding | `AppTheme.spacing24` |
| Section gaps | `AppTheme.spacing32` |
| Button gaps | `AppTheme.spacing12` - `AppTheme.spacing16` |
| Card padding | `AppTheme.spacing24` |
| Header elements | `AppTheme.spacing8` - `AppTheme.spacing12` |

## Icon Sizes

| Element | Size |
|---------|------|
| Primary button icon | 28px |
| Secondary button icons | 24px |
| Welcome panel header icon | 32px |
| Feature item icons | 20px |
| Tour step badge | 32px circle |

## Button Styles

### Start Training Rally (Primary)
```dart
FilledButton.styleFrom(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spacing24,
    vertical: AppTheme.spacing20,
  ),
  elevation: 4,
)
```

### Secondary Actions
```dart
ElevatedButton.styleFrom(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spacing24,
    vertical: AppTheme.spacing16,
  ),
)
```

### Dev Tool
```dart
OutlinedButton.styleFrom(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spacing24,
    vertical: AppTheme.spacing16,
  ),
  side: BorderSide(
    color: theme.colorScheme.secondary,
    width: 2,
  ),
)
```

## Welcome Panel Features

1. **Interactive Training** - `Icons.school`
2. **Smart Organization** - `Icons.category`
3. **Track Progress** - `Icons.star`
4. **Import & Export** - `Icons.sync`

## App Tour Steps

1. **Create or Import Packages** - Get started
2. **Add Vocabulary Items** - Build materials
3. **Configure Training** - Customize experience
4. **Start Learning** - Begin sessions
5. **Review Statistics** - Track progress

## State Management

- Uses Riverpod's `ConsumerWidget`
- Watches `themeProvider` for theme changes
- No local state management needed
- All navigation via `Navigator.push()`

## Accessibility Features

✅ Large touch targets (48dp minimum)  
✅ Clear button hierarchy  
✅ Semantic widget structure  
✅ Theme-aware colors  
✅ Readable text sizes  
✅ Proper contrast ratios

