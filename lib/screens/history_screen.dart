import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/transaction_card.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = themeProvider.palette;

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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'FLOW HISTORY',
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
            child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? palette.cardDark.withOpacity(0.95) : const Color(0xFFFFFDF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: palette.goldBorderColor.withOpacity(0.55),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : palette.textLightPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by note or category...',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: isDark ? Colors.white54 : Colors.black45),
                  prefixIcon: Icon(Icons.search_rounded, color: palette.goldBorderColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? palette.cardDark.withOpacity(0.95) : const Color(0xFFFFFDF8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: palette.goldBorderColor.withOpacity(0.55), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 16, color: palette.goldBorderColor),
                        const SizedBox(width: 6),
                        Text(
                          _selectedMonth == null ? 'All Months' : DateFormat.yMMM().format(_selectedMonth!),
                          style: GoogleFonts.cinzel(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : palette.textLightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    final newCat = await showDialog<String>(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: isDark ? palette.cardDark : const Color(0xFFFFFDF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(color: palette.goldBorderColor, width: 1.2),
                        ),
                        title: Text('Select Category', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: palette.goldBorderColor)),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                title: Text('All Categories', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                                onTap: () => Navigator.of(context).pop('All'),
                              ),
                              ...provider.categories.map((c) => ListTile(
                                title: Text(c.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                                onTap: () => Navigator.of(context).pop(c.name),
                              )).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (newCat != null) {
                      setState(() => _selectedCategory = newCat == 'All' ? null : newCat);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? palette.cardDark.withOpacity(0.95) : const Color(0xFFFFFDF8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: palette.goldBorderColor.withOpacity(0.55), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.category_rounded, size: 16, color: palette.goldBorderColor),
                        const SizedBox(width: 6),
                        Text(
                          _selectedCategory ?? 'All Categories',
                          style: GoogleFonts.cinzel(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : palette.textLightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history_toggle_off_rounded, size: 54, color: Color(0xFFD4AF37)),
                        const SizedBox(height: 12),
                        Text(
                          "No Records Found",
                          style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return TransactionCard(
                        tx: tx,
                        onDelete: () => provider.deleteTransaction(tx.id),
                      );
                    },
                  ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}
