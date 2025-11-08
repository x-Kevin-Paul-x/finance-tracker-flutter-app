import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import 'package:intl/intl.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _type = 'expense';
  String _category = 'Misc';
  final _noteCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _quickCategories = ['Food', 'Transport', 'Housing', 'Shopping', 'Subscriptions', 'Income', 'Misc'];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('New Transaction', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Expense')),
                  ButtonSegment(value: 'income', label: Text('Income')),
                ],
                selected: {_type},
                onSelectionChanged: (val) => setState(() => _type = val.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                  prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _type == 'expense' ? Colors.red : Colors.green),
                ),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _type == 'expense' ? Colors.red : Colors.green),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.category),
                title: Text(_category),
                onTap: () async {
                  final newCat = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Select Category'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: provider.categories.map((c) => ListTile(
                            title: Text(c.name),
                            onTap: () => Navigator.of(context).pop(c.name),
                          )).toList(),
                        ),
                      ),
                    ),
                  );
                  if (newCat != null) {
                    setState(() => _category = newCat);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat.yMMMd().format(_selectedDate)),
                onTap: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (newDate != null) {
                    setState(() => _selectedDate = newDate);
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Note (Optional)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
                  final tx = TransactionModel(amount: amount, category: _category, type: _type, note: _noteCtrl.text, date: _selectedDate.millisecondsSinceEpoch);
                  provider.addTransaction(tx);
                  Navigator.of(context).pop();
                },
                child: const Text('Save Transaction'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
