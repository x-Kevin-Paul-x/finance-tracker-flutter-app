import 'package:flutter/material.dart';
import '../models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryModel? category;
  const CategoryDialog({super.key, this.category});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _icon;
  late String _type;

  @override
  void initState() {
    super.initState();
    _name = widget.category?.name ?? '';
    _icon = widget.category?.icon ?? '❓';
    _type = widget.category?.type ?? 'expense';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'New Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (val) => val?.isEmpty == true ? 'Please enter a name' : null,
              onSaved: (val) => _name = val!,
            ),
            TextFormField(
              initialValue: _icon,
              decoration: const InputDecoration(labelText: 'Icon (emoji)'),
              validator: (val) => val?.isEmpty == true ? 'Please enter an icon' : null,
              onSaved: (val) => _icon = val!,
            ),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                DropdownMenuItem(value: 'income', child: Text('Income')),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final cat = CategoryModel(
                id: widget.category?.id ?? const Uuid().v4(),
                name: _name,
                icon: _icon,
                color: '#FFFFFF', // default color for now
                type: _type,
              );
              Navigator.of(context).pop(cat);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
