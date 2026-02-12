// lib/data/repositories/import_export_repository.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/language_package.dart';
import '../models/language_package_group.dart';
import '../models/category.dart';
import '../models/item.dart';
import 'language_package_repository.dart';
import 'language_package_group_repository.dart';
import 'category_repository.dart';
import 'item_repository.dart';

/// Custom exception for duplicate package
class PackageAlreadyExistsException implements Exception {
  final String packageId;
  final String groupName;

  PackageAlreadyExistsException(this.packageId, this.groupName);

  @override
  String toString() => 'Package with ID $packageId already exists in group "$groupName"';
}

/// Result of package import operation
class ImportResult {
  final int itemCount;
  final String groupName;

  ImportResult(this.itemCount, this.groupName);
}

class ImportExportRepository {
  final LanguagePackageRepository _packageRepo;
  final LanguagePackageGroupRepository _groupRepo;
  final CategoryRepository _categoryRepo;
  final ItemRepository _itemRepo;

  ImportExportRepository({
    required LanguagePackageRepository packageRepo,
    required LanguagePackageGroupRepository groupRepo,
    required CategoryRepository categoryRepo,
    required ItemRepository itemRepo,
  })  : _packageRepo = packageRepo,
        _groupRepo = groupRepo,
        _categoryRepo = categoryRepo,
        _itemRepo = itemRepo;

  /// Export a package to JSON file
  /// Returns the file path or throws exception if package cannot be exported
  Future<String> exportPackage(String packageId) async {
    final package = await _packageRepo.getPackageById(packageId);
    if (package == null) {
      throw Exception('Package not found: $packageId');
    }

    // Check if package can be exported
    if (!package.canExport) {
      throw Exception('Cannot export purchased packages');
    }

    // Get categories for the package
    final categories = await _categoryRepo.getCategoriesForPackage(packageId);

    // Get all items for each category
    final categoryIds = categories.map((c) => c.id).toList();
    final items = await _itemRepo.getItemsForCategories(categoryIds);

    // Get the group information
    final group = await _groupRepo.getGroupById(package.groupId);
    final groupName = group?.name ?? 'Default';

    // Build export data structure
    final exportData = {
      'version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'package': {
        'id': package.id,
        'group_id': package.groupId,
        'group_name': groupName,
        'language_code1': package.languageCode1,
        'language_name1': package.languageName1,
        'language_code2': package.languageCode2,
        'language_name2': package.languageName2,
        'description': package.description,
        'icon': package.icon,
        'author_name': package.authorName,
        'author_email': package.authorEmail,
        'author_webpage': package.authorWebpage,
        'version': package.version,
        'package_type': package.packageType.name,
        'created_at': package.createdAt.toIso8601String(),
      },
      'categories': categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'description': c.description,
      }).toList(),
      'items': items.map((item) => item.toJson()).toList(),
    };

    // Write to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'package_${package.id}_$timestamp.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(exportData),
    );

    return file.path;
  }

  /// Import a package from JSON file
  /// Detects and skips duplicate items
  /// Returns number of items imported
  Future<int> importPackage(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Validate format
    if (data['version'] == null || data['package'] == null) {
      throw Exception('Invalid package file format');
    }

    final packageData = data['package'] as Map<String, dynamic>;

    // ALWAYS generate a new package ID to ensure independence
    final newPackageId = const Uuid().v4();
    packageData['id'] = newPackageId;

    // Generate new IDs for categories and items
    final categoriesData = data['categories'] as List<dynamic>;
    final itemsData = data['items'] as List<dynamic>;

    // Create mapping from old category IDs to new category IDs
    final categoryIdMap = <String, String>{};
    for (var catData in categoriesData) {
      final oldCategoryId = catData['id'] as String;
      final newCategoryId = const Uuid().v4();
      categoryIdMap[oldCategoryId] = newCategoryId;
      catData['id'] = newCategoryId; // Update category ID in place
    }

    // Generate new IDs for all items and update their category references
    for (var itemData in itemsData) {
      // Generate new item ID
      itemData['id'] = const Uuid().v4();

      // Update category IDs to reference new categories
      final oldCategoryIds = itemData['categoryIds'] as List<dynamic>;
      final newCategoryIds = oldCategoryIds.map((oldId) {
        return categoryIdMap[oldId as String] ?? oldId;
      }).toList();
      itemData['categoryIds'] = newCategoryIds;
    }

    final packageId = newPackageId;

    // Handle group: check if exists, create if not
    String groupId;
    final exportedGroupId = packageData['group_id'] as String?;
    final exportedGroupName = packageData['group_name'] as String?;

    if (exportedGroupId != null && exportedGroupName != null) {
      // PRIORITIZE NAME: Check if a group with the same name exists (case-insensitive)
      var group = await _groupRepo.getGroupByName(exportedGroupName);

      if (group == null) {
        // Group with this name doesn't exist, create new group with exported ID and name
        // Use a new UUID if the exported ID already exists
        var newGroupId = exportedGroupId;
        final existingGroupWithId = await _groupRepo.getGroupById(exportedGroupId);
        if (existingGroupWithId != null) {
          // ID exists but with different name, generate new ID
          newGroupId = const Uuid().v4();
          // print('  Group ID conflict: using new ID $newGroupId instead of $exportedGroupId');
        }

        group = LanguagePackageGroup(
          id: newGroupId,
          name: exportedGroupName,
        );
        await _groupRepo.insertGroup(group);
        // print('  ✓ Created new group: $newGroupId - ${exportedGroupName}');
      } else {
        // print('  ✓ Using existing group: ${group.id} - ${group.name}');
      }

      groupId = group.id;
    } else {
      // Fallback: use or create default group for old exports
      const defaultGroupId = 'default-group-id';
      const defaultGroupName = 'Default';

      var defaultGroup = await _groupRepo.getGroupById(defaultGroupId);
      if (defaultGroup == null) {
        defaultGroup = LanguagePackageGroup(
          id: defaultGroupId,
          name: defaultGroupName,
        );
        await _groupRepo.insertGroup(defaultGroup);
      }

      groupId = defaultGroupId;
    }

    // Create package with the correct group ID
    final package = LanguagePackage(
      id: packageId,
      groupId: groupId,
      languageCode1: packageData['language_code1'] as String,
      languageName1: packageData['language_name1'] as String,
      languageCode2: packageData['language_code2'] as String,
      languageName2: packageData['language_name2'] as String,
      description: packageData['description'] as String?,
      icon: packageData['icon'] as String?, // null = use default dictionary icon
      authorName: packageData['author_name'] as String?,
      authorEmail: packageData['author_email'] as String?,
      authorWebpage: packageData['author_webpage'] as String?,
      version: (packageData['version'] as String?) ?? '1.0.0',
      packageType: PackageType.userCreated, // Imported packages are always user-created
      createdAt: DateTime.now(), // Use current time for import
    );

    await _packageRepo.insertPackage(package);
    // print('Import: Package created with ID: $packageId, groupId: $groupId');

    // Import categories (IDs already updated above)
    // print('Import: Found ${categoriesData.length} categories in import data');

    for (final catData in categoriesData) {
      final category = Category(
        id: catData['id'] as String,
        packageId: packageId,
        name: catData['name'] as String,
        description: catData['description'] as String?,
      );
      await _categoryRepo.insertCategory(category);
      // print('  Imported category: ${category.id} - ${category.name}');
    }

    // Import items
    // print('Import: Found ${itemsData.length} items in import data');

    int importedCount = 0;
    for (final itemData in itemsData) {
      try {
        final item = Item.fromJson(itemData as Map<String, dynamic>);

        // Update item's packageId to match the imported package
        final updatedItem = item.copyWith(packageId: packageId);

        // Since we generated new IDs, no duplicates are possible
        await _itemRepo.insertItem(updatedItem);
        importedCount++;
        // print('  ✓ Item imported: ${updatedItem.id}');
      } catch (e) {
        // print('  ❌ Error importing item: $e');
        // print('  Stack trace: $stackTrace');
        // Continue with next item instead of failing entire import
      }
    }

    // print('Import completed: $importedCount items imported');
    return importedCount;
  }

  /// Import items into an existing package
  /// Skips duplicates based on item ID
  /// Returns number of items imported
  Future<int> importItems(String packageId, String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    // Verify package exists and is editable
    final package = await _packageRepo.getPackageById(packageId);
    if (package == null) {
      throw Exception('Package not found: $packageId');
    }

    if (!package.canEdit) {
      throw Exception('Cannot import items into purchased or readonly packages');
    }

    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Validate format
    if (data['items'] == null) {
      throw Exception('Invalid items file format');
    }

    final itemsData = data['items'] as List<dynamic>;
    int importedCount = 0;

    for (final itemData in itemsData) {
      final item = Item.fromJson(itemData as Map<String, dynamic>);

      // Check for duplicate
      final existingItem = await _itemRepo.getItemById(item.id);
      if (existingItem == null) {
        await _itemRepo.insertItem(item);
        importedCount++;
      }
    }


    return importedCount;
  }

  /// Export only items (without package structure)
  Future<String> exportItems(List<String> itemIds) async {
    if (itemIds.isEmpty) {
      throw Exception('No items selected for export');
    }

    final items = <Item>[];
    for (final itemId in itemIds) {
      final item = await _itemRepo.getItemById(itemId);
      if (item != null) {
        items.add(item);
      }
    }

    final exportData = {
      'version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'type': 'items_only',
      'items': items.map((item) => item.toJson()).toList(),
    };

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'items_$timestamp.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(exportData),
    );

    return file.path;
  }

  /// Get export directory path
  Future<String> getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Export a package to ZIP file including all data and icon
  /// Returns the file path of the created ZIP file
  Future<String> exportPackageToZip(String packageId, String destinationPath) async {
    final package = await _packageRepo.getPackageById(packageId);
    if (package == null) {
      throw Exception('Package not found: $packageId');
    }

    // Check if package can be exported
    if (!package.canExport) {
      throw Exception('Cannot export purchased packages');
    }

    // Get categories for the package
    final categories = await _categoryRepo.getCategoriesForPackage(packageId);

    // print('Export: Found ${categories.length} categories for package $packageId');


    // Get all items for each category
    final categoryIds = categories.map((c) => c.id).toList();
    final items = await _itemRepo.getItemsForCategories(categoryIds);

    // print('Export: Found ${items.length} items for ${categoryIds.length} categories');

    // Get the group information
    final group = await _groupRepo.getGroupById(package.groupId);
    final groupName = group?.name ?? 'Default';

    // Build export data structure
    bool isCustomIcon = false;

    // Check if we need to copy a custom icon
    if (package.icon != null && package.icon!.isNotEmpty && !package.icon!.startsWith('assets/')) {
      isCustomIcon = true;
    }

    final exportData = {
      'version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'package': {
        'id': package.id,
        'group_id': package.groupId,
        'group_name': groupName,
        'language_code1': package.languageCode1,
        'language_name1': package.languageName1,
        'language_code2': package.languageCode2,
        'language_name2': package.languageName2,
        'description': package.description,
        'icon': package.icon,
        'icon_is_custom': isCustomIcon,
        'author_name': package.authorName,
        'author_email': package.authorEmail,
        'author_webpage': package.authorWebpage,
        'version': package.version,
        'package_type': package.packageType.name,
        'created_at': package.createdAt.toIso8601String(),
      },
      'categories': categories.map((c) => {
        'id': c.id,
        'name': c.name,
        'description': c.description,
      }).toList(),
      'items': items.map((item) => item.toJson()).toList(),
    };

    // Create a temporary directory for building the ZIP
    final tempDir = await getTemporaryDirectory();
    final exportDir = Directory('${tempDir.path}/package_export_${DateTime.now().millisecondsSinceEpoch}');
    await exportDir.create(recursive: true);

    try {
      String? finalIconPath = package.icon;

      // Copy icon file if it exists
      if (package.icon != null && package.icon!.isNotEmpty) {
        try {
          if (isCustomIcon) {
            // Custom icon - copy from file system
            final iconFile = File(package.icon!);
            if (await iconFile.exists()) {
              final iconFileName = 'custom_icon${path.extension(package.icon!)}';
              final destIconFile = File('${exportDir.path}/$iconFileName');
              await iconFile.copy(destIconFile.path);

              // Update the icon path in export data to reference the file within the ZIP
              final packageMap = exportData['package'] as Map<String, dynamic>;
              packageMap['icon'] = iconFileName;
              finalIconPath = iconFileName;

              // print('Exported custom icon: $iconFileName');
            } else {
              // print('Warning: Custom icon file not found: ${package.icon}');
              // Set icon to null if file doesn't exist
              final packageMap = exportData['package'] as Map<String, dynamic>;
              packageMap['icon'] = null;
              packageMap['icon_is_custom'] = false;
              finalIconPath = null;
            }
          }
          // Asset icons don't need to be copied - they're part of the app
        } catch (e) {
          // print('Error copying icon: $e');
          // On error, set icon to null to avoid issues on import
          final packageMap = exportData['package'] as Map<String, dynamic>;
          packageMap['icon'] = null;
          packageMap['icon_is_custom'] = false;
          finalIconPath = null;
        }
      }

      // Write package data as JSON (after icon has been processed)
      final jsonFile = File('${exportDir.path}/package_data.json');
      await jsonFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(exportData),
      );

      // print('Package data written to: ${jsonFile.path}');
      // print('Icon in export: $finalIconPath');

      // Create ZIP archive
      final archive = Archive();

      // Add all files from export directory to archive
      final files = await exportDir.list(recursive: true).toList();
      // print('Files found in export directory:');
      for (final entity in files) {
        if (entity is File) {
          final relativePath = path.relative(entity.path, from: exportDir.path);
          final bytes = await entity.readAsBytes();
          final archiveFile = ArchiveFile(relativePath, bytes.length, bytes);
          archive.addFile(archiveFile);
          // print('  Added to ZIP: $relativePath (${bytes.length} bytes)');
        }
      }

      // Encode the archive to ZIP format
      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);

      // Write ZIP file to destination
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'package_${package.languageName1}_${package.languageName2}_$timestamp.zip';
      final zipFilePath = path.join(destinationPath, fileName);
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(zipData!);

      // print('ZIP file created: $zipFilePath');
      // print('Total files in archive: ${archive.files.length}');

      return zipFilePath;
    } finally {
      // Clean up temporary directory
      try {
        await exportDir.delete(recursive: true);
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  /// Import a package from ZIP file including custom icons
  /// Returns ImportResult with item count and group name
  Future<ImportResult> importPackageFromZip(String zipFilePath) async {
    final zipFile = File(zipFilePath);
    if (!await zipFile.exists()) {
      throw Exception('ZIP file not found: $zipFilePath');
    }

    // Create temporary directory for extraction
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory('${tempDir.path}/package_import_${DateTime.now().millisecondsSinceEpoch}');
    await extractDir.create(recursive: true);

    try {
      // Extract ZIP file
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract all files
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final extractedFile = File('${extractDir.path}/$filename');
          await extractedFile.create(recursive: true);
          await extractedFile.writeAsBytes(data);
        }
      }

      // Read package data JSON
      final jsonFile = File('${extractDir.path}/package_data.json');
      if (!await jsonFile.exists()) {
        throw Exception('Invalid package ZIP: missing package_data.json');
      }

      final jsonString = await jsonFile.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate format
      if (data['version'] == null || data['package'] == null) {
        throw Exception('Invalid package file format');
      }

      final packageData = data['package'] as Map<String, dynamic>;

      // Determine which group this package would be imported to
      final exportedGroupId = packageData['group_id'] as String?;
      final exportedGroupName = packageData['group_name'] as String?;
      String targetGroupId;
      String targetGroupName;

      if (exportedGroupId != null && exportedGroupName != null) {
        // Check if a group with the same name exists
        var group = await _groupRepo.getGroupByName(exportedGroupName);
        if (group != null) {
          targetGroupId = group.id;
          targetGroupName = group.name;
        } else {
          // New group would be created, check for duplicates based on content
          targetGroupId = exportedGroupId; // Tentative ID
          targetGroupName = exportedGroupName;
        }
      } else {
        // Would use default group
        const defaultGroupId = 'default-group-id';
        const defaultGroupName = 'Default';
        var defaultGroup = await _groupRepo.getGroupById(defaultGroupId);
        if (defaultGroup != null) {
          targetGroupId = defaultGroup.id;
          targetGroupName = defaultGroup.name;
        } else {
          // Default group doesn't exist yet, check for duplicates in default group
          targetGroupId = defaultGroupId;
          targetGroupName = defaultGroupName;
        }
      }

      // Check if package already exists in the target group
      final existingPackage = await _checkForDuplicatePackage(packageData, targetGroupId);
      if (existingPackage != null) {
        throw PackageAlreadyExistsException(existingPackage.id, targetGroupName);
      }

      // ALWAYS generate new IDs for package, categories, and items
      final newPackageId = const Uuid().v4();
      packageData['id'] = newPackageId;

      // Generate new IDs for categories and items
      final categoriesData = data['categories'] as List<dynamic>;
      final itemsData = data['items'] as List<dynamic>;

      // Create mapping from old category IDs to new category IDs
      final categoryIdMap = <String, String>{};
      for (var catData in categoriesData) {
        final oldCategoryId = catData['id'] as String;
        final newCategoryId = const Uuid().v4();
        categoryIdMap[oldCategoryId] = newCategoryId;
        catData['id'] = newCategoryId;
      }

      // Generate new IDs for all items and update their category references
      for (var itemData in itemsData) {
        itemData['id'] = const Uuid().v4();

        final oldCategoryIds = itemData['categoryIds'] as List<dynamic>;
        final newCategoryIds = oldCategoryIds.map((oldId) {
          return categoryIdMap[oldId as String] ?? oldId;
        }).toList();
        itemData['categoryIds'] = newCategoryIds;
      }

      return await _importPackageData(packageData, data, extractDir);
    } finally {
      // Clean up temporary directory
      try {
        await extractDir.delete(recursive: true);
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  /// Import a package from ZIP file with a new ID (for duplicate packages)
  /// Returns ImportResult with item count and group name
  Future<ImportResult> importPackageFromZipWithNewId(String zipFilePath) async {
    final zipFile = File(zipFilePath);
    if (!await zipFile.exists()) {
      throw Exception('ZIP file not found: $zipFilePath');
    }

    // Create temporary directory for extraction
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory('${tempDir.path}/package_import_${DateTime.now().millisecondsSinceEpoch}');
    await extractDir.create(recursive: true);

    try {
      // Extract ZIP file
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract all files
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final extractedFile = File('${extractDir.path}/$filename');
          await extractedFile.create(recursive: true);
          await extractedFile.writeAsBytes(data);
        }
      }

      // Read package data JSON
      final jsonFile = File('${extractDir.path}/package_data.json');
      if (!await jsonFile.exists()) {
        throw Exception('Invalid package ZIP: missing package_data.json');
      }

      final jsonString = await jsonFile.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate format
      if (data['version'] == null || data['package'] == null) {
        throw Exception('Invalid package file format');
      }

      final packageData = data['package'] as Map<String, dynamic>;

      // Generate new ID for the package
      final newPackageId = const Uuid().v4();
      packageData['id'] = newPackageId;

      // Generate new IDs for categories and update items accordingly
      final categoriesData = data['categories'] as List<dynamic>;
      final itemsData = data['items'] as List<dynamic>;

      // Create mapping from old category IDs to new category IDs
      final categoryIdMap = <String, String>{};
      for (var catData in categoriesData) {
        final oldCategoryId = catData['id'] as String;
        final newCategoryId = const Uuid().v4();
        categoryIdMap[oldCategoryId] = newCategoryId;
        catData['id'] = newCategoryId; // Update category ID in place
      }

      // Generate new IDs for all items and update their category references
      for (var itemData in itemsData) {
        // Generate new item ID
        itemData['id'] = const Uuid().v4();

        // Update category IDs to reference new categories
        final oldCategoryIds = itemData['categoryIds'] as List<dynamic>;
        final newCategoryIds = oldCategoryIds.map((oldId) {
          return categoryIdMap[oldId as String] ?? oldId;
        }).toList();
        itemData['categoryIds'] = newCategoryIds; // Update category IDs in place
      }

      return await _importPackageData(packageData, data, extractDir);
    } finally {
      // Clean up temporary directory
      try {
        await extractDir.delete(recursive: true);
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  /// Check if a package with the same content already exists in the same group
  /// Compares: language names (not codes), description, author info, version within the same group
  Future<LanguagePackage?> _checkForDuplicatePackage(
    Map<String, dynamic> packageData,
    String groupId,
  ) async {
    final allPackages = await _packageRepo.getAllPackages();

    // Extract and normalize fields from import data
    final langName1 = (packageData['language_name1'] as String).trim().toLowerCase();
    final langName2 = (packageData['language_name2'] as String).trim().toLowerCase();
    final description = (packageData['description'] as String?)?.trim().toLowerCase() ?? '';
    final authorName = (packageData['author_name'] as String?)?.trim().toLowerCase() ?? '';
    final authorEmail = (packageData['author_email'] as String?)?.trim().toLowerCase() ?? '';
    final version = (packageData['version'] as String?)?.trim().toLowerCase() ?? '';

    // Check each existing package IN THE SAME GROUP
    for (final pkg in allPackages) {
      // Skip packages in different groups
      if (pkg.groupId != groupId) continue;

      final pkgLangName1 = pkg.languageName1.trim().toLowerCase();
      final pkgLangName2 = pkg.languageName2.trim().toLowerCase();
      final pkgDescription = (pkg.description ?? '').trim().toLowerCase();
      final pkgAuthorName = (pkg.authorName ?? '').trim().toLowerCase();
      final pkgAuthorEmail = (pkg.authorEmail ?? '').trim().toLowerCase();
      final pkgVersion = pkg.version.trim().toLowerCase();

      // Check if all fields match (language names, not codes!)
      if (pkgLangName1 == langName1 &&
          pkgLangName2 == langName2 &&
          pkgDescription == description &&
          pkgAuthorName == authorName &&
          pkgAuthorEmail == authorEmail &&
          pkgVersion == version) {
        return pkg; // Found duplicate in same group
      }
    }

    return null; // No duplicate found
  }

  /// Common import logic for package data
  /// Returns ImportResult with item count and group name
  Future<ImportResult> _importPackageData(
    Map<String, dynamic> packageData,
    Map<String, dynamic> data,
    Directory extractDir,
  ) async {
    final packageId = packageData['id'] as String;

    // Handle custom icon if present
    String? iconPath = packageData['icon'] as String?;
    final isCustomIcon = packageData['icon_is_custom'] == true;

    if (isCustomIcon && iconPath != null && iconPath.isNotEmpty) {
      // Custom icon needs to be copied to app's custom icons directory
      final iconFile = File('${extractDir.path}/$iconPath');
      if (await iconFile.exists()) {
        final appDir = await getApplicationDocumentsDirectory();
        final customIconsDir = Directory(path.join(appDir.path, 'custom_package_icons'));
        if (!await customIconsDir.exists()) {
          await customIconsDir.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final extension = path.extension(iconPath);
        final newFileName = 'imported_icon_$timestamp$extension';
        final newIconPath = path.join(customIconsDir.path, newFileName);

        await iconFile.copy(newIconPath);
        iconPath = newIconPath;
      } else {
        // Icon file missing, use default
        iconPath = null;
      }
    }

    // Handle group: check if exists, create if not
    String groupId;
    String groupName;
    final exportedGroupId = packageData['group_id'] as String?;
    final exportedGroupName = packageData['group_name'] as String?;

    if (exportedGroupId != null && exportedGroupName != null) {
      // PRIORITIZE NAME: Check if a group with the same name exists (case-insensitive)
      var group = await _groupRepo.getGroupByName(exportedGroupName);

      if (group == null) {
        // Group with this name doesn't exist, create new group with exported ID and name
        // Use a new UUID if the exported ID already exists
        var newGroupId = exportedGroupId;
        final existingGroupWithId = await _groupRepo.getGroupById(exportedGroupId);
        if (existingGroupWithId != null) {
          // ID exists but with different name, generate new ID
          newGroupId = const Uuid().v4();
          // print('  Group ID conflict: using new ID $newGroupId instead of $exportedGroupId');
        }

        group = LanguagePackageGroup(
          id: newGroupId,
          name: exportedGroupName,
        );
        await _groupRepo.insertGroup(group);
        // print('  ✓ Created new group: $newGroupId - ${exportedGroupName}');
      } else {
        // print('  ✓ Using existing group: ${group.id} - ${group.name}');
      }

      groupId = group.id;
      groupName = group.name;
    } else {
      // Fallback: use or create default group for old exports
      const defaultGroupId = 'default-group-id';
      const defaultGroupName = 'Default';

      var defaultGroup = await _groupRepo.getGroupById(defaultGroupId);
      if (defaultGroup == null) {
        defaultGroup = LanguagePackageGroup(
          id: defaultGroupId,
          name: defaultGroupName,
        );
        await _groupRepo.insertGroup(defaultGroup);
      }

      groupId = defaultGroupId;
      groupName = defaultGroupName;
    }

    // Create package with the correct group ID
    final package = LanguagePackage(
      id: packageId,
      groupId: groupId,
      languageCode1: packageData['language_code1'] as String,
      languageName1: packageData['language_name1'] as String,
      languageCode2: packageData['language_code2'] as String,
      languageName2: packageData['language_name2'] as String,
      description: packageData['description'] as String?,
      icon: iconPath,
      authorName: packageData['author_name'] as String?,
      authorEmail: packageData['author_email'] as String?,
      authorWebpage: packageData['author_webpage'] as String?,
      version: (packageData['version'] as String?) ?? '1.0.0',
      packageType: PackageType.userCreated,
      createdAt: DateTime.now(),
    );

    await _packageRepo.insertPackage(package);
    // print('Import ZIP: Package created with ID: $packageId, groupId: $groupId');

    // Import categories
    final categoriesData = data['categories'] as List<dynamic>;
    // print('Import ZIP: Found ${categoriesData.length} categories in import data');

    for (final catData in categoriesData) {
      final category = Category(
        id: catData['id'] as String,
        packageId: packageId,
        name: catData['name'] as String,
        description: catData['description'] as String?,
      );
      await _categoryRepo.insertCategory(category);
      // print('  Imported category: ${category.id} - ${category.name}');
    }

    // Import items
    final itemsData = data['items'] as List<dynamic>;
    int importedCount = 0;
    int skippedCount = 0;

    // print('Import ZIP: Found ${itemsData.length} items in import data');

    for (final itemData in itemsData) {
      try {
        final item = Item.fromJson(itemData as Map<String, dynamic>);
        // print('  Processing item: ${item.id}, original packageId: ${item.packageId}');

        // Update item's packageId to match the imported package
        // This is crucial because the exported packageId might be different
        final updatedItem = item.copyWith(packageId: packageId);
        // print('    Updated packageId to: ${updatedItem.packageId}');

        // Check for duplicate: item with same ID in ANY package
        final existingItem = await _itemRepo.getItemById(updatedItem.id);
        if (existingItem != null) {
          // Item with this ID already exists (in any package)
          if (existingItem.packageId == packageId) {
            // Item exists in THIS package - skip it
            skippedCount++;
            // print('    ⚠ Item already exists in this package, skipped');
          } else {
            // Item exists in ANOTHER package - this shouldn't happen with proper ID generation
            // Skip to avoid database constraint violations
            skippedCount++;
            // print('    ⚠ Item ID collision with another package, skipped');
          }
        } else {
          // Item doesn't exist anywhere - safe to import
          await _itemRepo.insertItem(updatedItem);
          importedCount++;
          // print('    ✓ Item imported successfully');
        }
      } catch (e) {
        // print('    ❌ Error importing item: $e');
        // print('    Stack trace: $stackTrace');
        // Continue with next item instead of failing entire import
      }
    }

    // print('Import ZIP completed: $importedCount items imported, $skippedCount skipped');
    return ImportResult(importedCount, groupName);
  }
}

