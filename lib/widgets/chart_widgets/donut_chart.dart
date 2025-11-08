import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final Map<String, double> data;

  const DonutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.where((e) => e.value > 0).toList();
    final total = entries.fold<double>(0, (p, e) => p + e.value);
    if (entries.isEmpty) return const Center(child: Text('No data'));

    return PieChart(
      PieChartData(
        sections: List.generate(entries.length, (i) {
          final e = entries[i];
          final pct = total == 0 ? 0.0 : e.value / total;
          final color = Colors.primaries[i % Colors.primaries.length];
          return PieChartSectionData(
            value: e.value,
            color: color.withOpacity(0.9),
            title: '${(pct * 100).toStringAsFixed(0)}%',
            radius: 60,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
          );
        }),
        centerSpaceRadius: 36,
        sectionsSpace: 4,
      ),
    );
  }
}
