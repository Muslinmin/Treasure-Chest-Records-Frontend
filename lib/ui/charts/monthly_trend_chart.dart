import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/summary.dart';
import '../../domain/money.dart';

class MonthlyTrendChart extends StatefulWidget {
  final List<Summary> summaries;
  const MonthlyTrendChart({super.key, required this.summaries});

  @override
  State<MonthlyTrendChart> createState() => _MonthlyTrendChartState();
}

class _MonthlyTrendChartState extends State<MonthlyTrendChart> {
  String? _selectedCategory; // null = show totals across all categories

  // TODO: Return a sorted list of unique category names from widget.summaries
  // Hint: .map().toSet().toList() then sort the list
  List<String> get _categories {
    final categoryNames = widget.summaries.map((s) => s.category).toSet().toList();
    categoryNames.sort();
    return categoryNames;
  }

  // TODO: Return Map<String, int> of period → totalCents
  // When _selectedCategory is null: use fold to sum all categories per period
  // When _selectedCategory is set: filter to that category first, then fold
  Map<String, int> get _periodTotals {
    final Map<String, int> totals = {};

    // Filter summaries if a category is selected
    final filteredSummaries = _selectedCategory == null
        ? widget.summaries
        : widget.summaries.where((s) => s.category == _selectedCategory);

    // Aggregate values per period using standard iteration/fold philosophy
    for (final summary in filteredSummaries) {
      totals[summary.period] = (totals[summary.period] ?? 0) + summary.totalCents;
    }

    return totals;
  }

  // TODO: Map each period to a BarChartGroupData
  // - x = index in sortedPeriods (0-based int)
  // - one BarChartRodData per group, toY = centsToChartValue(_periodTotals[period] ?? 0)
  List<BarChartGroupData> _buildBarGroups(List<String> sortedPeriods) {
    return List.generate(sortedPeriods.length, (index) {
      final period = sortedPeriods[index];
      final totalCents = _periodTotals[period] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: centsToChartValue(totalCents),
            color: Theme.of(context).colorScheme.primary,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
@override
  Widget build(BuildContext context) {
    // Generate the baseline sorted axis keys
    final sortedPeriods = _periodTotals.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DropdownButton<String?> for category filter
        DropdownButton<String?>(
          value: _selectedCategory,
          isExpanded: true,
          hint: const Text('Filter by Category'),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('All Categories'),
            ),
            ..._categories.map((category) {
              return DropdownMenuItem<String?>(
                value: category,
                child: Text(category),
              );
            }),
          ],
          onChanged: (String? value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              barGroups: _buildBarGroups(sortedPeriods),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                // Hide top and right titles completely
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (double x, TitleMeta meta) {
                      final index = x.toInt();
                      // Guard: check if index is safely within the computed timeline list bounds
                      if (index < 0 || index >= sortedPeriods.length) {
                        return const SizedBox.shrink();
                      }

                      final periodString = sortedPeriods[index]; // Expected format example: "2026-05"
                      String label = periodString;
                      
                      // For readability, if the string has a dash, split and extract the month suffix ("05")
                      if (periodString.contains('-')) {
                        final components = periodString.split('-');
                        if (components.length > 1) {
                          label = components[1]; 
                        }
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles( // ✅ Fixed parameter naming here
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      // The chart values are converted from cents to dollars for height positioning
                      final dollars = value; 
                      
                      final label = dollars >= 1000
                          ? '${(dollars / 1000).toStringAsFixed(1)}k'
                          : dollars.toStringAsFixed(0);

                      return SideTitleWidget(
                        meta: meta, // Changed axisSide to meta to match clean signature patterns
                        space: 6,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10, // Adjusted layout scaling slightly
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Theme.of(context).colorScheme.surfaceContainerHighest,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (group.x < 0 || group.x >= sortedPeriods.length) return null;

                    final periodLabel = sortedPeriods[group.x];
                    final calculatedCents = _periodTotals[periodLabel] ?? 0;

                    return BarTooltipItem(
                      '$periodLabel\n',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: formatCents(calculatedCents),
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
        ),
      ],
    );
  }
}
