# Training from Home Page Feature

## Overview
Added the ability to start a training session directly from the home page. The app now remembers the last trained package and allows users to quickly resume training or select a different package.

## Changes Made

### 1. AppSettings Model (`app_settings.dart`)
- Added `lastTrainedPackageId` field to store the ID of the last trained package
- Updated `copyWith()` method to include the new field
- Updated `props` getter for proper equality comparison

### 2. AppSettings Repository (`app_settings_repository.dart`)
- Added `_keyLastTrainedPackageId` constant for SharedPreferences key
- Updated `loadSettings()` to load the last trained package ID
- Added `saveLastTrainedPackageId()` method to persist the package ID
- Updated `saveSettings()` to save the last trained package ID

### 3. Training Settings Page (`training_settings_page.dart`)
- Made `package` parameter optional (can be null)
- Added `_currentPackage` and `_availablePackages` fields
- Added `_appSettingsRepo` and `_packageRepo` for data access
- Updated `_loadSettings()` to:
  - Load all available packages
  - Determine current package from:
    - Provided package parameter (from package list), OR
    - Last trained package (from app settings), OR
    - First available package (fallback)
- Updated `_saveSettings()`, `_clearSettings()`, and `_startTraining()` to use `_currentPackage`
- Updated `_startTraining()` to save the last trained package ID
- Updated `_buildPackageInfo()` to show:
  - Dropdown for package selection when coming from home page
  - Static package info when coming from package list
- Updated `_buildDisplayLanguageSection()` to use `_currentPackage`

### 4. Home Page (`home_page.dart`)
- Added import for `TrainingSettingsPage`
- Added "Start Training Rally" button as a prominent FilledButton with icon
- Positioned button at the top of the action list for easy access

### 5. Localization Files
**English (`app_en.arb`):**
- Added `"selectPackage": "Select Package"`
- Added `"noPackagesAvailable": "No packages available"`

**Hungarian (`app_hu.arb`):**
- Added `"selectPackage": "Csomag Kiválasztása"`
- Added `"noPackagesAvailable": "Nincsenek elérhető csomagok"`

## User Experience

### From Home Page
1. User clicks "Start Training Rally" button on home page
2. Training settings page opens with:
   - Package dropdown showing all available packages
   - Default selection: last trained package (or first available)
   - User can change package selection
   - Settings are loaded for the selected package
3. User configures training settings and starts training
4. Package ID is saved as "last trained package"

### From Package List
1. User clicks training icon on a specific package card
2. Training settings page opens with:
   - Fixed package (no dropdown)
   - Settings for that specific package
3. User configures settings and starts training
4. Package ID is saved as "last trained package"

## Benefits
- **Quick Access**: Users can start training immediately from home page
- **Context Preservation**: App remembers last training session
- **Flexibility**: Users can still change packages if needed
- **Seamless Experience**: Works with both entry points (home page and package list)

## Technical Notes
- Package selection is only shown when `widget.package == null`
- Settings are automatically reloaded when package selection changes
- Null safety properly handled throughout
- Uses existing localization infrastructure
- No breaking changes to existing functionality

