import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glass_container.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double monthlyExpense;
  final double monthlyIncome;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.monthlyExpense,
    required this.monthlyIncome,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currency = NumberFormat.simpleCurrency();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      color: themeProvider.palette.cardLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Balance",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: themeProvider.palette.primary.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: balance),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Text(
              currency.format(value),
              style: GoogleFonts.playfairDisplay(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'Income',
                  currency.format(monthlyIncome),
                  themeProvider.palette.income,
                  Icons.arrow_upward_rounded,
                  isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.white24 : Colors.black12,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _miniStat(
                  'Expenses',
                  currency.format(monthlyExpense),
                  themeProvider.palette.expense,
                  Icons.arrow_downward_rounded,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color, IconData icon, bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
