import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/summary.dart';
import '../../domain/money.dart';

class CategoryBreakdownChart extends StatelessWidget {
  final List<Summary> summaries;
  const CategoryBreakdownChart({super.key, required this.summaries});

  // Returns summaries sorted by totalCents descending (largest category first)
  List<Summary> get _sorted {
    final listCopy = summaries.toList();
    listCopy.sort((a, b) => b.totalCents.compareTo(a.totalCents));
    return listCopy;
  }

  // Converts _sorted into a List<BarChartGroupData>
  List<BarChartGroupData> _buildBarGroups(List<Summary> sorted, BuildContext context) {
    return List.generate(sorted.length, (index) {
      final summary = sorted[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: centsToChartValue(summary.totalCents),
            color: Theme.of(context).colorScheme.primary, // Clean theme integration
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted; // Compute once here
    
    if (sorted.isEmpty) {
      return const Center(child: Text('No category data for this period.'));
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          barGroups: _buildBarGroups(sorted, context), // Pass data down
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 72,
                getTitlesWidget: (double x, TitleMeta meta) {
                  final index = x.toInt();
                  if (index < 0 || index >= sorted.length) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: Text(
                        sorted[index].category,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Theme.of(context).colorScheme.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                // Guard against index boundaries using the local "sorted" list
                if (group.x < 0 || group.x >= sorted.length) return null;
                
                // Get the current focused category item
                final summary = sorted[group.x];

                return BarTooltipItem(
                  '${summary.category}\n',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: formatCents(summary.totalCents), // Formats raw int cents safely
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}