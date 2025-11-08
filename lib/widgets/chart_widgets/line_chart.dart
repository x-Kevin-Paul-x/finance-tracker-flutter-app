import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyTrendChart extends StatelessWidget {
  final Map<int, double> data;
  const MonthlyTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
