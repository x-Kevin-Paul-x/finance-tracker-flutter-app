import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  DateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final transactions = provider.transactions.where((tx) {
      final note = tx.note?.toLowerCase() ?? '';
      if (_searchQuery.isNotEmpty && !note.contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedCategory != null && tx.category != _selectedCategory) {
        return false;
      }
      if (_selectedMonth != null) {
        final txDate = DateTime.fromMillisecondsSinceEpoch(tx.date);
        if (txDate.month != _selectedMonth!.month || txDate.year != _selectedMonth!.year) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search bar
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or note',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(_selectedMonth == null ? 'This Month' : DateFormat.yMMM().format(_selectedMonth!)),
                onSelected: (val) async {
                  final newMonth = await showDatePicker(
                    context: context,
                    initialDate: _selectedMonth ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (newMonth != null) {
                    setState(() => _selectedMonth = newMonth);
                  }
                },
              ),
              FilterChip(
                label: Text(_selectedCategory ?? 'All Categories'),
                onSelected: (val) async {
                  final newCat = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Select Category'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: const Text('All Categories'),
                              onTap: () => Navigator.of(context).pop(null),
                            ),
                            ...provider.categories.map((c) => ListTile(
                                  title: Text(c.name),
                                  onTap: () => Navigator.of(context).pop(c.name),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                  setState(() => _selectedCategory = newCat);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(tx.category.isNotEmpty ? tx.category[0] : '?'),
                  ),
                  title: Text(tx.note ?? 'Transaction'),
                  subtitle: Text(DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(tx.date))),
                  trailing: Text(
                    '${tx.type == 'income' ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: tx.type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
