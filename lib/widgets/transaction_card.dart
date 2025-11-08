import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onDelete;

  const TransactionCard({super.key, required this.tx, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency();
    final date = DateTime.fromMillisecondsSinceEpoch(tx.date);
    final isIncome = tx.type == 'income';
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          leading: CircleAvatar(
            backgroundColor: isIncome ? AppTheme.income.withOpacity(0.12) : AppTheme.expense.withOpacity(0.12),
            child: Text(tx.category.isNotEmpty ? tx.category[0].toUpperCase() : '?', style: TextStyle(color: isIncome ? AppTheme.income : AppTheme.expense)),
          ),
          title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${DateFormat.yMMMd().format(date)} • ${tx.note ?? ''}', style: const TextStyle(color: Colors.grey)),
          trailing: Text((isIncome ? '+ ' : '- ') + fmt.format(tx.amount), style: TextStyle(color: isIncome ? AppTheme.income : AppTheme.expense, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
