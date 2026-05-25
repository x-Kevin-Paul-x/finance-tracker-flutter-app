import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glass_container.dart';

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
    final palette = themeProvider.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: ValueKey(tx.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete?.call(),
        background: GlassContainer(
          color: palette.expense,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.only(right: 24),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
        ),
        child: GlassContainer(
          color: palette.cardLight,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isIncome ? palette.income : palette.expense).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    tx.category.isNotEmpty ? tx.category[0].toUpperCase() : '?',
                    style: GoogleFonts.playfairDisplay(
                      color: isIncome ? palette.income : palette.expense,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.note != null && tx.note!.isNotEmpty ? tx.note! : tx.category,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd().format(date),
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white54 : Colors.black45,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                (isIncome ? '+ ' : '- ') + fmt.format(tx.amount),
                style: GoogleFonts.inter(
                  color: isIncome ? palette.income : palette.textLightPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
