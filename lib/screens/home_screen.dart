import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/haiku_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = themeProvider.palette;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'HAIKU • TREASURE',
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 1.5,
                color: isDark ? const Color(0xFFE5C158) : const Color(0xFF2B1D18),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.color_lens_outlined,
                  size: 22,
                  color: Color(0xFFD4AF37),
                ),
                onPressed: () => themeProvider.toggleTheme(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Texture Image
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
          // Subtle Dark/Light Overlay for perfect UI contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.60),
                          Colors.black.withOpacity(0.78),
                        ]
                      : [
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.40),
                        ],
                ),
              ),
            ),
          ),
          // Screen Content
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async => await provider.init(),
              color: palette.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Primary Utility Metric: Total Treasure Balance Card (FIRST)
                  BalanceCard(
                    balance: provider.balance,
                    monthlyExpense: provider.monthlyTotal(type: 'expense'),
                    monthlyIncome: provider.monthlyTotal(type: 'income'),
                  ),
                  const SizedBox(height: 16),

                  // 2. Compact Royal Art Nouveau Banner Accent
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: palette.primary.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/indian_sitar_hero.jpg',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: palette.primary.withOpacity(0.2),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.82),
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stewardship & Grace",
                                        style: GoogleFonts.playfairDisplay(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        palette.subtitle,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: palette.goldBorderColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    palette.name.split(' ')[0].toUpperCase(),
                                    style: GoogleFonts.cinzel(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Haiku Reflection Card
                  const HaikuCard(),
                  const SizedBox(height: 24),

                  // 4. Recent Flows Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recent Financial Flows',
                            style: GoogleFonts.cinzel(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark ? palette.textDarkPrimary : palette.textLightPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${provider.transactions.length} entries',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (provider.transactions.isEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? palette.cardDark : palette.cardLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/empty_lotus_state.jpg',
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.eco_outlined,
                                size: 64,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Stillness & Serenity",
                            style: GoogleFonts.cinzel(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "No transactions recorded yet.\nTap 'RECORD FLOW' below to add your first entry.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.transactions.length,
                      itemBuilder: (context, idx) {
                        final tx = provider.transactions[idx];
                        return TransactionCard(
                          tx: tx,
                          onDelete: () => provider.deleteTransaction(tx.id),
                        );
                      },
                    ),

                  // Generous bottom scroll padding so transactions are never obscured by FAB
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: palette.buttonGradient,
          border: Border.all(
            color: palette.goldBorderColor,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: palette.goldBorderColor.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const AddTransactionSheet(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.2),
                      border: Border.all(color: const Color(0xFFF3E5AB).withOpacity(0.6)),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 18,
                      color: Color(0xFFF3E5AB),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'RECORD FLOW',
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
