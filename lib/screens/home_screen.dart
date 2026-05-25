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
        title: Text(
          'Haiku',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 28,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [palette.backgroundDark, palette.backgroundDark.withOpacity(0.8), palette.primary.withOpacity(0.1)]
                : [palette.backgroundLight, palette.backgroundLight, palette.primary.withOpacity(0.05)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async => await provider.init(),
            color: palette.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  BalanceCard(
                    balance: provider.balance,
                    monthlyExpense: provider.monthlyTotal(type: 'expense'),
                    monthlyIncome: provider.monthlyTotal(type: 'income'),
                  ),
                  const SizedBox(height: 24),
                  const HaikuCard(),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                    child: Text(
                      'Recent Flows',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),

                  if (provider.transactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          "Stillness.\nNo transactions yet.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
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
                  const SizedBox(height: 100), // Padding for FAB
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTransactionSheet(),
        ),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }
}
