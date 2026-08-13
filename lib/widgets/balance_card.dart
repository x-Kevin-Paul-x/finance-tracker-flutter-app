import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String _formatRupee(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 2);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = themeProvider.palette;

    final incomeColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    final expenseColor = isDark ? const Color(0xFFFF6B6B) : const Color(0xFFDC2626);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: palette.goldBorderColor.withOpacity(0.50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Arch Asset
            Positioned.fill(
              child: Image.asset(
                'assets/images/art_nouveau_arch_card.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark ? palette.cardDark : palette.cardLight,
                ),
              ),
            ),
            // High-contrast overlay gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            palette.cardDark.withOpacity(0.95),
                            palette.cardDark.withOpacity(0.98),
                          ]
                        : [
                            palette.backgroundLight.withOpacity(0.88),
                            palette.backgroundLight.withOpacity(0.95),
                          ],
                  ),
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFD4AF37),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "TOTAL BALANCE",
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                              color: isDark ? const Color(0xFFF3E5AB) : const Color(0xFF8B5A2B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD4AF37).withOpacity(0.18),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xFFD4AF37),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Numerical Balance display with high-legibility Plus Jakarta Sans
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: balance),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => Text(
                        _formatRupee(value),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.1,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Income & Expense Metrics container with zero overflow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withOpacity(0.35)
                          : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _miniStat(
                            'Monthly Income',
                            _formatRupee(monthlyIncome),
                            incomeColor,
                            Icons.arrow_upward_rounded,
                            isDark,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: const Color(0xFFD4AF37).withOpacity(0.35),
                        ),
                        Expanded(
                          child: _miniStat(
                            'Monthly Expense',
                            _formatRupee(monthlyExpense),
                            expenseColor,
                            Icons.arrow_downward_rounded,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color, IconData icon, bool isDark) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 12),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      );
}
