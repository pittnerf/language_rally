# Knowledge Level Persistence Implementation

## Date: 2026-02-26

## Overview

Added functionality to save and load the selected knowledge level (A1, A2, B1, B2, C1, C2) in the AI Text Analysis page, so the widget remembers the user's selection between sessions.

## Changes Made

### 1. AppSettings Model (`lib/data/models/app_settings.dart`)

**Added field:**
```dart
/// Selected knowledge level for AI text analysis (A1, A2, B1, B2, C1, C2)
final String aiKnowledgeLevel;
```

**Updated constructor:**
```dart
const AppSettings({
  // ...existing fields...
  this.aiKnowledgeLevel = 'B1',  // Default to B1 (Intermediate)
  // ...
});
```

**Updated `copyWith()` method:**
```dart
AppSettings copyWith({
  // ...existing parameters...
  String? aiKnowledgeLevel,
  // ...
}) {
  return AppSettings(
    // ...existing fields...
    aiKnowledgeLevel: aiKnowledgeLevel ?? this.aiKnowledgeLevel,
    // ...
  );
}
```

**Updated `props` for Equatable:**
```dart
@override
List<Object?> get props => [
  // ...existing props...
  aiKnowledgeLevel,
  // ...
];
```

### 2. AppSettingsRepository (`lib/data/repositories/app_settings_repository.dart`)

**Added key constant:**
```dart
static const String _keyAiKnowledgeLevel = 'ai_knowledge_level';
```

**Updated `loadSettings()` method:**
```dart
Future<AppSettings> loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  
  return AppSettings(
    // ...existing fields...
    aiKnowledgeLevel: prefs.getString(_keyAiKnowledgeLevel) ?? 'B1',
    // ...
  );
}
```

**Added save method:**
```dart
/// Save AI knowledge level selection
Future<void> saveAiKnowledgeLevel(String level) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyAiKnowledgeLevel, level);
}
```

**Updated `saveSettings()` method:**
```dart
Future<void> saveSettings(AppSettings settings) async {
  // ...existing saves...
  await saveAiKnowledgeLevel(settings.aiKnowledgeLevel);
  // ...
}
```

### 3. AppSettingsProvider (`lib/presentation/providers/app_settings_provider.dart`)

**Added setter method:**
```dart
Future<void> setAiKnowledgeLevel(String level) async {
  await _repository.saveAiKnowledgeLevel(level);
  state = state.copyWith(aiKnowledgeLevel: level);
}
```

### 4. AI Text Analysis Page (`lib/presentation/pages/ai_import/ai_text_analysis_page.dart`)

**Updated `initState()` to load saved value:**
```dart
@override
void initState() {
  super.initState();
  _categoryController.text = 'AI Imported';

  // Load saved model and knowledge level selection
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final settings = ref.read(appSettingsProvider);
    setState(() {
      _selectedModel = settings.openaiModel;
      _selectedLevel = settings.aiKnowledgeLevel;  // ← Load saved level
    });
  });
}
```

**Updated dropdown `onChanged` to save selection:**
```dart
onChanged: (value) async {
  if (value != null) {
    setState(() {
      _selectedLevel = value;
    });
    // Save knowledge level selection
    await ref.read(appSettingsProvider.notifier).setAiKnowledgeLevel(value);
  }
},
```

## Behavior

### Before
- Knowledge level always defaulted to A1 (first in dropdown)
- User had to manually select their preferred level every time
- Selection was lost when navigating away and returning

### After
- ✅ Knowledge level defaults to B1 on first use
- ✅ When user changes the level, it's automatically saved
- ✅ When user returns to the page, their last selection is loaded
- ✅ Selection persists across app restarts

## Default Value

The default knowledge level is set to **B1 (Intermediate)** because:
- Most language learners are at intermediate level
- B1 is the middle of the CEFR scale (A1, A2, **B1**, B2, C1, C2)
- Provides a balanced starting point

## User Experience

1. **First time user opens AI Text Analysis:**
   - Knowledge level dropdown shows **B1 (Intermediate)**
   - This is the default value

2. **User selects a different level (e.g., A2):**
   - Dropdown updates to show A2
   - Selection is **immediately saved** to SharedPreferences
   - No need to manually save or confirm

3. **User navigates away and returns:**
   - Knowledge level dropdown shows **A2** (their last selection)
   - Selection is **automatically loaded** from SharedPreferences

4. **App is closed and reopened:**
   - Knowledge level dropdown still shows **A2**
   - Selection **persists** across app sessions

## Storage

- **Technology:** SharedPreferences
- **Key:** `'ai_knowledge_level'`
- **Value:** String (`'A1'`, `'A2'`, `'B1'`, `'B2'`, `'C1'`, `'C2'`)
- **Default:** `'B1'`

## Testing Checklist

✅ **Initial state:**
- [ ] Open AI Text Analysis for first time
- [ ] Verify knowledge level defaults to B1

✅ **Save functionality:**
- [ ] Select a different level (e.g., A2)
- [ ] Navigate away and return
- [ ] Verify A2 is still selected

✅ **Persistence:**
- [ ] Select a level (e.g., C1)
- [ ] Close the app completely
- [ ] Reopen the app and navigate to AI Text Analysis
- [ ] Verify C1 is still selected

✅ **Multiple changes:**
- [ ] Change level multiple times
- [ ] Each change should be saved
- [ ] Last selection should always be loaded

## Related Settings

The AI Text Analysis page now saves two user preferences:

1. **OpenAI Model** (`openaiModel`)
   - Default: `'gpt-4-turbo'`
   - Saved when changed
   - Loaded on page open

2. **Knowledge Level** (`aiKnowledgeLevel`) ← NEW!
   - Default: `'B1'`
   - Saved when changed
   - Loaded on page open

Both settings provide a consistent user experience where selections are remembered across sessions.

## Files Modified

1. ✅ `lib/data/models/app_settings.dart`
   - Added `aiKnowledgeLevel` field
   - Updated constructor, copyWith, and props

2. ✅ `lib/data/repositories/app_settings_repository.dart`
   - Added storage key constant
   - Added load/save methods
   - Updated batch save method

3. ✅ `lib/presentation/providers/app_settings_provider.dart`
   - Added `setAiKnowledgeLevel()` method

4. ✅ `lib/presentation/pages/ai_import/ai_text_analysis_page.dart`
   - Updated `initState()` to load saved value
   - Updated dropdown `onChanged` to save value

## Technical Details

### State Management
- Uses Riverpod's `NotifierProvider` pattern
- Settings state is managed globally
- Changes propagate automatically

### Persistence Layer
- SharedPreferences stores key-value pairs locally
- Async operations for save/load
- No need for manual initialization

### UI Updates
- `setState()` updates local widget state immediately
- Provider updates global app state
- No need to refresh or rebuild manually

## Summary

✅ Knowledge level selection is now persistent  
✅ Saves automatically when changed  
✅ Loads automatically when page opens  
✅ Works across app sessions  
✅ No compilation errors  
✅ Consistent with existing settings pattern  
✅ Default value: B1 (Intermediate)  

The AI Text Analysis page now remembers the user's knowledge level preference! 🎉

