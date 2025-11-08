import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double monthlyExpense;
  final double monthlyIncome;

  const BalanceCard({super.key, required this.balance, required this.monthlyExpense, required this.monthlyIncome});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Balance', style: TextStyle(fontSize: 14, color: Colors.white70)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: balance),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, _) => Text(currency.format(value), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniStat('Income', currency.format(monthlyIncome), AppTheme.income),
              _miniStat('Expense', currency.format(monthlyExpense), AppTheme.expense),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        ],
      );
}
