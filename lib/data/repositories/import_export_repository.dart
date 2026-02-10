// lib/data/repositories/import_export_repository.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/language_package.dart';
import '../models/category.dart';
import '../models/item.dart';
import 'language_package_repository.dart';
import 'category_repository.dart';
import 'item_repository.dart';

/// Custom exception for duplicate package
class PackageAlreadyExistsException implements Exception {
  final String packageId;
  PackageAlreadyExistsException(this.packageId);

  @override
  String toString() => 'Package with ID $packageId already exists';
}

class ImportExportRepository {
  final LanguagePackageRepository _packageRepo;
  final CategoryRepository _categoryRepo;
  final ItemRepository _itemRepo;

  ImportExportRepository({
    required LanguagePackageRepository packageRepo,
    required CategoryRepository categoryRepo,
    required ItemRepository itemRepo,
  })  : _packageRepo = packageRepo,
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

    // Build export data structure
    final exportData = {
      'version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'package': {
        'id': package.id,
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
    final packageId = packageData['id'] as String;

    // Check if package already exists
    final existingPackage = await _packageRepo.getPackageById(packageId);
    if (existingPackage != null) {
      throw Exception(
        'Package already exists. Delete existing package first or use importItems() to merge.',
      );
    }

    // Create package
    final package = LanguagePackage(
      id: packageId,
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

    // Import categories
    final categoriesData = data['categories'] as List<dynamic>;
    for (final catData in categoriesData) {
      final category = Category(
        id: catData['id'] as String,
        packageId: packageId,
        name: catData['name'] as String,
        description: catData['description'] as String?,
      );
      await _categoryRepo.insertCategory(category);
    }

    // Import items
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

    // Get all items for each category
    final categoryIds = categories.map((c) => c.id).toList();
    final items = await _itemRepo.getItemsForCategories(categoryIds);

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

              print('Exported custom icon: $iconFileName');
            } else {
              print('Warning: Custom icon file not found: ${package.icon}');
              // Set icon to null if file doesn't exist
              final packageMap = exportData['package'] as Map<String, dynamic>;
              packageMap['icon'] = null;
              packageMap['icon_is_custom'] = false;
              finalIconPath = null;
            }
          }
          // Asset icons don't need to be copied - they're part of the app
        } catch (e) {
          print('Error copying icon: $e');
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

      print('Package data written to: ${jsonFile.path}');
      print('Icon in export: $finalIconPath');

      // Create ZIP archive
      final archive = Archive();

      // Add all files from export directory to archive
      final files = await exportDir.list(recursive: true).toList();
      print('Files found in export directory:');
      for (final entity in files) {
        if (entity is File) {
          final relativePath = path.relative(entity.path, from: exportDir.path);
          final bytes = await entity.readAsBytes();
          final archiveFile = ArchiveFile(relativePath, bytes.length, bytes);
          archive.addFile(archiveFile);
          print('  Added to ZIP: $relativePath (${bytes.length} bytes)');
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

      print('ZIP file created: $zipFilePath');
      print('Total files in archive: ${archive.files.length}');

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
  /// Returns number of items imported
  Future<int> importPackageFromZip(String zipFilePath) async {
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

      // Check if package already exists based on content (not ID)
      final existingPackage = await _checkForDuplicatePackage(packageData);
      if (existingPackage != null) {
        throw PackageAlreadyExistsException(existingPackage.id);
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
  Future<int> importPackageFromZipWithNewId(String zipFilePath) async {
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
      packageData['id'] = const Uuid().v4();

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

  /// Check if a package with the same content already exists
  /// Compares: source/target language codes, description, author name, author email, version
  Future<LanguagePackage?> _checkForDuplicatePackage(Map<String, dynamic> packageData) async {
    final allPackages = await _packageRepo.getAllPackages();

    // Extract and normalize fields from import data
    final langCode1 = (packageData['language_code1'] as String).trim().toLowerCase();
    final langCode2 = (packageData['language_code2'] as String).trim().toLowerCase();
    final description = (packageData['description'] as String?)?.trim().toLowerCase() ?? '';
    final authorName = (packageData['author_name'] as String?)?.trim().toLowerCase() ?? '';
    final authorEmail = (packageData['author_email'] as String?)?.trim().toLowerCase() ?? '';
    final version = (packageData['version'] as String?)?.trim().toLowerCase() ?? '';

    // Check each existing package
    for (final pkg in allPackages) {
      final pkgLangCode1 = pkg.languageCode1.trim().toLowerCase();
      final pkgLangCode2 = pkg.languageCode2.trim().toLowerCase();
      final pkgDescription = (pkg.description ?? '').trim().toLowerCase();
      final pkgAuthorName = (pkg.authorName ?? '').trim().toLowerCase();
      final pkgAuthorEmail = (pkg.authorEmail ?? '').trim().toLowerCase();
      final pkgVersion = pkg.version.trim().toLowerCase();

      // Check if all fields match
      if (pkgLangCode1 == langCode1 &&
          pkgLangCode2 == langCode2 &&
          pkgDescription == description &&
          pkgAuthorName == authorName &&
          pkgAuthorEmail == authorEmail &&
          pkgVersion == version) {
        return pkg; // Found duplicate
      }
    }

    return null; // No duplicate found
  }

  /// Common import logic for package data
  Future<int> _importPackageData(
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

    // Create package
    final package = LanguagePackage(
      id: packageId,
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

    // Import categories
    final categoriesData = data['categories'] as List<dynamic>;
    for (final catData in categoriesData) {
      final category = Category(
        id: catData['id'] as String,
        packageId: packageId,
        name: catData['name'] as String,
        description: catData['description'] as String?,
      );
      await _categoryRepo.insertCategory(category);
    }

    // Import items
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
}

