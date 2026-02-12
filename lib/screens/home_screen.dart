import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/glass_container.dart';
import '../widgets/chart_widgets/line_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => await provider.init(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                            const Text(
                              'User', // Could be replaced with actual username if available
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.account_circle, size: 32),
                          onPressed: () {}, // Navigate to profile or settings
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Glassmorphic Balance Card
                    GlassContainer(
                      padding: const EdgeInsets.all(24),
                      gradient: LinearGradient(
                        colors: [
                           Theme.of(context).primaryColor.withOpacity(0.8),
                           Theme.of(context).primaryColor.withOpacity(0.5),
                        ],
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            NumberFormat.simpleCurrency().format(provider.balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSummaryItem(
                                context,
                                'Income',
                                provider.monthlyIncome,
                                Icons.arrow_upward,
                                Colors.greenAccent
                              ),
                              Container(width: 1, height: 40, color: Colors.white24),
                              _buildSummaryItem(
                                context,
                                'Expense',
                                provider.monthlyExpense,
                                Icons.arrow_downward,
                                Colors.redAccent
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Monthly Trend Chart (Mini)
                    if (provider.dailyTotals().isNotEmpty) ...[
                       const Text('Spending Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                       const SizedBox(height: 16),
                       SizedBox(
                         height: 150,
                         child: MonthlyTrendChart(data: provider.dailyTotals()),
                       ),
                       const SizedBox(height: 24),
                    ],

                    const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.transactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final tx = provider.transactions[idx];
                        return GlassContainer(
                          padding: EdgeInsets.zero,
                          opacity: 0.05,
                          borderRadius: 16,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Text(
                                _getCategoryIcon(tx.category, provider),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            title: Text(
                                tx.category,
                                style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            subtitle: Text(
                                DateFormat('MMM d, h:mm a').format(DateTime.fromMillisecondsSinceEpoch(tx.date))
                            ),
                            trailing: Text(
                              '${tx.type == 'income' ? '+' : '-'}${NumberFormat.simpleCurrency().format(tx.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: tx.type == 'income' ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            onLongPress: () => provider.deleteTransaction(tx.id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent, // Important for glass effect in sheet if needed
          builder: (_) => const AddTransactionSheet()
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(
              NumberFormat.simpleCurrency().format(amount),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)
            ),
          ],
        ),
      ],
    );
  }

  String _getCategoryIcon(String categoryId, FinanceProvider provider) {
      final cat = provider.categories.firstWhere((c) => c.id == categoryId, orElse: () => provider.categories.first);
      return cat.icon;
  }
}
