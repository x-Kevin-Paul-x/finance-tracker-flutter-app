import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onDelete;

  const TransactionCard({super.key, required this.tx, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency();
    final date = DateTime.fromMillisecondsSinceEpoch(tx.date);
    final isIncome = tx.type == 'income';
  final themeProvider = Provider.of<ThemeProvider>(context);
    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isIncome ? themeProvider.palette.income.withOpacity(0.12) : themeProvider.palette.expense.withOpacity(0.12),
              child: Text(tx.category.isNotEmpty ? tx.category[0].toUpperCase() : '?', style: TextStyle(color: isIncome ? themeProvider.palette.income : themeProvider.palette.expense)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.note ?? tx.category, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(DateFormat.yMMMd().format(date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text((isIncome ? '+ ' : '- ') + fmt.format(tx.amount), style: TextStyle(color: isIncome ? themeProvider.palette.income : themeProvider.palette.expense, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
