import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onDelete;

  const TransactionCard({super.key, required this.tx, this.onDelete});

  String _formatRupee(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 2);
    return formatter.format(amount);
  }

  IconData _getCategoryIcon(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('food') || lower.contains('chai') || lower.contains('dining') || lower.contains('ration')) {
      return Icons.restaurant_rounded;
    } else if (lower.contains('travel') || lower.contains('auto') || lower.contains('commute')) {
      return Icons.directions_bus_rounded;
    } else if (lower.contains('shopping') || lower.contains('saree') || lower.contains('clothing')) {
      return Icons.shopping_bag_rounded;
    } else if (lower.contains('pooja') || lower.contains('festival') || lower.contains('gift')) {
      return Icons.auto_awesome;
    } else if (lower.contains('bill') || lower.contains('rent') || lower.contains('utilities')) {
      return Icons.receipt_long_rounded;
    } else if (lower.contains('salary') || lower.contains('income') || lower.contains('freelance')) {
      return Icons.payments_rounded;
    }
    return Icons.account_balance_wallet_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(tx.date);
    final isIncome = tx.type == 'income';
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final incomeColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    final expenseColor = isDark ? const Color(0xFFFF6B6B) : const Color(0xFFDC2626);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Dismissible(
        key: ValueKey(tx.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete?.call(),
        background: Container(
          decoration: BoxDecoration(
            color: expenseColor,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.only(right: 24),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? palette.cardDark : palette.cardLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.28),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isIncome ? incomeColor : expenseColor).withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isIncome ? incomeColor : expenseColor).withOpacity(0.35),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(tx.category),
                    color: isIncome ? incomeColor : expenseColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.note != null && tx.note!.isNotEmpty ? tx.note! : tx.category,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.14),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tx.category,
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFD4AF37),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().format(date),
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark ? Colors.white54 : Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                (isIncome ? '+ ' : '- ') + _formatRupee(tx.amount),
                style: GoogleFonts.plusJakartaSans(
                  color: isIncome ? incomeColor : expenseColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
