import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../widgets/chart_widgets/donut_chart.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final breakdown = provider.categoryTotals();

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Spending by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    SizedBox(height: 220, child: DonutChart(data: breakdown)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: breakdown.entries.map((e) => ListTile(
                  leading: CircleAvatar(child: Text(e.key.isNotEmpty ? e.key[0].toUpperCase() : '?')),
                  title: Text(e.key),
                  trailing: Text(' ' + e.value.toStringAsFixed(2)),
                )).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
