// lib/presentation/pages/packages/package_group_admin_page.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/language_package_group.dart';
import '../../../data/repositories/language_package_group_repository.dart';
import '../../../data/repositories/language_package_repository.dart';


/// Page for managing language package groups (add, edit, delete)
class PackageGroupAdminPage extends StatefulWidget {
  const PackageGroupAdminPage({super.key});

  @override
  State<PackageGroupAdminPage> createState() => _PackageGroupAdminPageState();
}

class _PackageGroupAdminPageState extends State<PackageGroupAdminPage> {
  final _groupRepo = LanguagePackageGroupRepository();
  final _packageRepo = LanguagePackageRepository();
  List<LanguagePackageGroup> _groups = [];
  Map<String, int> _packageCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final groups = await _groupRepo.getAllGroups();

      // Load package counts for each group
      final counts = <String, int>{};
      for (final group in groups) {
        final packages = await _packageRepo.getPackagesByGroupId(group.id);
        counts[group.id] = packages.length;
      }

      setState(() {
        _groups = groups;
        _packageCounts = counts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading groups: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // Consider 600dp+ as tablet

    return Scaffold(
      appBar: isTablet ? AppBar(
        title: Text(
          'Manage Package Groups',
          style: theme.textTheme.titleLarge,
        ),
      ) : null,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _groups.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      final group = _groups[index];
                      final packageCount = _packageCounts[group.id] ?? 0;
                      final canDelete = packageCount == 0;

                      return Card(
                        margin: EdgeInsets.only(bottom: AppTheme.spacing12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.folder,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            group.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '$packageCount package${packageCount != 1 ? 's' : ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editGroup(group),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: canDelete
                                      ? colorScheme.error
                                      : colorScheme.onSurface.withOpacity(0.3),
                                ),
                                onPressed: canDelete ? () => _deleteGroup(group) : null,
                                tooltip: canDelete
                                    ? 'Delete'
                                    : 'Cannot delete (has packages)',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addGroup,
        icon: const Icon(Icons.add),
        label: const Text('Add Group'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off,
            size: 64,
            color: colorScheme.outline,
          ),
          SizedBox(height: AppTheme.spacing16),
          Text(
            'No package groups',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Create your first package group',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addGroup() async {
    final newGroupName = await _showGroupNameDialog(
      context,
      title: 'Add Package Group',
      initialName: '',
    );

    if (newGroupName == null || newGroupName.trim().isEmpty) {
      return;
    }

    // Check for duplicate name (case-insensitive)
    final normalizedName = newGroupName.trim().toLowerCase();
    final duplicate = _groups.any(
      (g) => g.name.toLowerCase() == normalizedName,
    );

    if (duplicate) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Duplicate Name',
        'A group with the name "$newGroupName" already exists.',
      );
      return;
    }

    try {
      final newGroup = LanguagePackageGroup(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: newGroupName.trim(),
      );

      await _groupRepo.insertGroup(newGroup);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group "${newGroup.name}" created successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      await _loadGroups();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Error',
        'Failed to create group: $e',
      );
    }
  }

  Future<void> _editGroup(LanguagePackageGroup group) async {
    final newGroupName = await _showGroupNameDialog(
      context,
      title: 'Edit Package Group',
      initialName: group.name,
    );

    if (newGroupName == null || newGroupName.trim().isEmpty) {
      return;
    }

    // Check if name changed
    if (newGroupName.trim() == group.name) {
      return;
    }

    // Check for duplicate name (case-insensitive)
    final normalizedName = newGroupName.trim().toLowerCase();
    final duplicate = _groups.any(
      (g) => g.id != group.id && g.name.toLowerCase() == normalizedName,
    );

    if (duplicate) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Duplicate Name',
        'A group with the name "$newGroupName" already exists.',
      );
      return;
    }

    try {
      final updatedGroup = LanguagePackageGroup(
        id: group.id,
        name: newGroupName.trim(),
      );

      await _groupRepo.updateGroup(updatedGroup);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group renamed to "${updatedGroup.name}"'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      await _loadGroups();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Error',
        'Failed to update group: $e',
      );
    }
  }

  Future<void> _deleteGroup(LanguagePackageGroup group) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Delete Group',
      message: 'Are you sure you want to delete the group "${group.name}"?\n\nThis action cannot be undone.',
    );

    if (confirmed != true) {
      return;
    }

    // Double-check that group has no packages
    final packages = await _packageRepo.getPackagesByGroupId(group.id);
    if (packages.isNotEmpty) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Cannot Delete',
        'This group still has ${packages.length} package(s). Please move or delete them first.',
      );
      return;
    }

    try {
      await _groupRepo.deleteGroup(group.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group "${group.name}" deleted'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      await _loadGroups();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        context,
        'Error',
        'Failed to delete group: $e',
      );
    }
  }

  Future<String?> _showGroupNameDialog(
    BuildContext context, {
    required String title,
    required String initialName,
  }) {
    final controller = TextEditingController(text: initialName);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              hintText: 'Enter group name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Group name is required';
              }
              return null;
            },
            onFieldSubmitted: (value) {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(value.trim());
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

