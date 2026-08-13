import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/chart_widgets/donut_chart.dart';
import '../widgets/chart_widgets/line_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  String _formatRupee(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 2);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = themeProvider.palette;

    final breakdown = provider.categoryTotals();
    final totalSpending = breakdown.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'ANALYTICS',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 1.2,
            color: isDark ? const Color(0xFFE5C158) : const Color(0xFF2B1D18),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark ? palette.darkBgAsset : palette.lightBgAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: isDark ? palette.gradientFallbackDark : palette.gradientFallbackLight,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.85),
                          Colors.black.withOpacity(0.95),
                        ]
                      : [
                          Colors.white.withOpacity(0.60),
                          Colors.white.withOpacity(0.80),
                        ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard('Total Outflow', _formatRupee(totalSpending), palette, isDark),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _summaryCard('Flow Growth', '+4.2%', palette, isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? palette.cardDark : palette.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.show_chart_rounded, color: Color(0xFFD4AF37), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Monthly Spending Trend',
                            style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 180,
                        child: MonthlyTrendChart(data: provider.dailyTotals()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? palette.cardDark : palette.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pie_chart_outline_rounded, color: Color(0xFFD4AF37), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Category Distribution',
                            style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(height: 220, child: DonutChart(data: breakdown)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Top Outflow Categories',
                  style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? palette.textDarkPrimary : palette.textLightPrimary),
                ),
                const SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: breakdown.entries.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDark ? palette.cardDark : palette.cardLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.25)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFD4AF37).withOpacity(0.18),
                        child: Text(
                          e.key.isNotEmpty ? e.key[0].toUpperCase() : '?',
                          style: GoogleFonts.cinzel(color: const Color(0xFFD4AF37), fontWeight: FontWeight.w700),
                        ),
                      ),
                      title: Text(e.key, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF111827))),
                      trailing: Text(
                        _formatRupee(e.value),
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? const Color(0xFFFF6B6B) : const Color(0xFFDC2626)),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }

  Widget _summaryCard(String title, String value, dynamic palette, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? palette.cardDark : palette.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37)),
          ),
        ],
      ),
    );
  }
}
