import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/category.dart';
import '../widgets/category_dialog.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < categories.length; i++)
            ListTile(
              key: ValueKey(categories[i].id),
              leading: CircleAvatar(
                child: Text(categories[i].icon),
              ),
              title: Text(categories[i].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final updatedCat = await showDialog<CategoryModel>(
                        context: context,
                        builder: (_) => CategoryDialog(category: categories[i]),
                      );
                      if (updatedCat != null) {
                        provider.updateCategory(updatedCat);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Category?'),
                          content: const Text('Are you sure you want to delete this category?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        provider.deleteCategory(categories[i].id);
                      }
                    },
                  ),
                  const Icon(Icons.drag_handle),
                ],
              ),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex -= 1;
          provider.reorderCategories(oldIndex, newIndex);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCat = await showDialog<CategoryModel>(
            context: context,
            builder: (_) => const CategoryDialog(),
          );
          if (newCat != null) {
            provider.addCategory(newCat);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
