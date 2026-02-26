# Database Initialization Fix

## Problem Description

When the application is first installed on a device with an empty database, attempting to save a new language package manually would fail with a foreign key constraint error. This happened because:

1. Language packages require a `group_id` field (foreign key to `language_package_groups` table)
2. On fresh installations, the database tables were created but no default group existed
3. When trying to save a package, the foreign key constraint failed because there was no group to reference

## Root Cause Analysis

### Database Creation Flow

The application uses SQLite with `sqflite` package and has two paths for database setup:

1. **Fresh Installation (onCreate)**: 
   - Calls `createDatabase()` function
   - Creates all tables at current version (v6)
   - **BUG**: Did not create a default group

2. **Existing Installation (onUpgrade)**:
   - Runs migrations sequentially
   - Migration v4 creates the default group
   - **This worked fine for upgrades but not fresh installs**

### Why Test Data Population Worked

The test data population script (`populate_test_data_script.dart`) had its own logic to check and create the default group:

```dart
var defaultGroup = await groupRepo.getGroupById(defaultGroupId);
if (defaultGroup == null) {
  defaultGroup = LanguagePackageGroup(
    id: defaultGroupId,
    name: defaultGroupName,
  );
  await groupRepo.insertGroup(defaultGroup);
}
```

This is why populating test data never showed the issue.

## Solution Implemented

### 1. Fixed Database Creation (`database_migrations.dart`)

Added default group creation directly in the `createDatabase()` function:

```dart
static Future<void> createDatabase(Database db, int version) async {
  // Language Package Groups table
  await db.execute('''
    CREATE TABLE language_package_groups (
      id $idType,
      name $textType
    )
  ''');

  // Create default group immediately after table creation
  const defaultGroupId = 'default-group-id';
  const defaultGroupName = 'Default';
  await db.insert('language_package_groups', {
    'id': defaultGroupId,
    'name': defaultGroupName,
  });

  // ... rest of table creation
}
```

**Benefits**:
- Ensures default group exists on fresh installs
- Matches the behavior of the migration v4
- Uses the same group ID across the entire application

### 2. Added Safety Check in App Initialization (`app_initialization_service.dart`)

Added `_ensureDefaultGroupExists()` method that:
- Runs during app startup
- Checks if default group exists
- Creates it if missing (defensive programming)
- Won't interfere with test data population (uses same ID)

```dart
static Future<void> _ensureDefaultGroupExists() async {
  try {
    final groupRepo = LanguagePackageGroupRepository();
    
    // Check if default group exists
    final existingGroup = await groupRepo.getGroupById(defaultGroupId);
    
    if (existingGroup == null) {
      // Create default group if it doesn't exist
      final defaultGroup = LanguagePackageGroup(
        id: defaultGroupId,
        name: defaultGroupName,
      );
      await groupRepo.insertGroup(defaultGroup);
      debugPrint('  ✓ Created default package group');
    } else {
      debugPrint('  ✓ Default package group exists');
    }
  } catch (e) {
    debugPrint('  ⚠️  Error ensuring default group: $e');
    // Don't rethrow - this is a non-critical error
  }
}
```

**Benefits**:
- Extra safety layer for edge cases
- Handles corrupted database scenarios
- Non-blocking (doesn't throw if it fails)
- Logs clear messages for debugging

## Compatibility with Test Data Population

The fix is fully compatible with the test data population script because:

1. **Same Group ID**: All parts use `'default-group-id'`
2. **REPLACE Conflict Algorithm**: Repository uses `ConflictAlgorithm.replace`, so duplicate inserts are handled gracefully
3. **Check Before Create**: Test script checks if group exists first
4. **Safety Check is Non-Critical**: The `_ensureDefaultGroupExists()` doesn't throw errors

## Testing Recommendations

### 1. Fresh Installation Test
1. Uninstall the app completely
2. Delete database files if testing on desktop
3. Install and launch the app
4. Try to create a new language package manually
5. **Expected**: Package saves successfully

### 2. Existing Installation Test
1. Keep existing app installation
2. Update the app with this fix
3. **Expected**: Everything continues to work

### 3. Test Data Population Test
1. Fresh install
2. Run the populate test data script
3. **Expected**: Test data populates without errors
4. Check that only one "Default" group exists

### 4. Edge Case Test
1. Manually delete the default group from database
2. Restart the app
3. **Expected**: App recreates the default group automatically
4. Try creating a package
5. **Expected**: Package saves successfully

## Files Modified

### `lib/data/database_migrations.dart`
- Added default group creation in `createDatabase()` function
- Ensures fresh installs have the required default group

### `lib/core/services/app_initialization_service.dart`
- Added imports for group repository and model
- Added `defaultGroupId` and `defaultGroupName` constants
- Added `_ensureDefaultGroupExists()` method
- Called from `_initializeDatabase()` during app startup

## Rollback Plan

If issues arise, revert these changes:
1. The database will still be created (without default group)
2. Test data population will still work (it creates the group)
3. Manual package creation will fail again (the original issue)

## Future Improvements

Consider these enhancements:

1. **Default Group Localization**: Localize the "Default" group name
2. **Group Management UI**: Allow users to rename/delete the default group
3. **Smart Group Assignment**: Auto-assign packages to appropriate groups based on language pairs
4. **Database Health Check**: Add a database integrity check on startup

