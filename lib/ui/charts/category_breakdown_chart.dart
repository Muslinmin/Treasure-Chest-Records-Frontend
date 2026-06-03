import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/summary.dart';
import '../../domain/money.dart';

class CategoryBreakdownChart extends StatefulWidget {
  final List<Summary> summaries;
  const CategoryBreakdownChart({super.key, required this.summaries});

  // A fixed palette of colours to cycle through — one per slice
  static const List<Color> _palette = [
    Color(0xFF4E79A7), // steel blue
    Color(0xFFF28E2B), // amber
    Color(0xFF59A14F), // green
    Color(0xFFE15759), // coral red
    Color(0xFF76B7B2), // teal
    Color(0xFFEDC948), // yellow
    Color(0xFFB07AA1), // mauve
    Color(0xFFFF9DA7), // pink
  ];

  @override
  State<CategoryBreakdownChart> createState() => _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<CategoryBreakdownChart> {
  int _touchedIndex = -1;

  // Returns a new sorted copy each call — always assign to a local variable in build()
  List<Summary> get _sorted {
    final listCopy = widget.summaries.toList();
    listCopy.sort((a, b) => b.totalCents.compareTo(a.totalCents));
    return listCopy;
  }

  List<PieChartSectionData> _buildSections(List<Summary> sorted) {
    return List.generate(sorted.length, (index) {
      final summary = sorted[index];
      final isTouched = index == _touchedIndex;
      final radius = isTouched ? 90.0 : 80.0;

      return PieChartSectionData(
        value: centsToChartValue(summary.totalCents),
        title: '', // tooltip-only labels
        color: CategoryBreakdownChart._palette[index % CategoryBreakdownChart._palette.length],
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend(List<Summary> sorted, List<double> percentages) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(sorted.length, (index) {
          final summary = sorted[index];
          final percentStr = percentages[index].toStringAsFixed(1);
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CategoryBreakdownChart._palette[index % CategoryBreakdownChart._palette.length],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    summary.category,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  '$percentStr%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted; // computed once

    if (sorted.isEmpty) {
      return const Center(child: Text('No category data for this period.'));
    }

    final total = sorted.fold<int>(0, (sum, s) => sum + s.totalCents);
    
    // Guard: Prevent division by zero if all categories somehow have 0 cents
    if (total == 0) {
      return const Center(child: Text('No spending for this period.'));
    }

    final percentages = List.generate(
      sorted.length,
      (i) => (sorted[i].totalCents / total) * 100,
    );

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: _buildSections(sorted),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
              // Conditional centre text display
              if (_touchedIndex >= 0 && _touchedIndex < sorted.length)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sorted[_touchedIndex].category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCents(sorted[_touchedIndex].totalCents),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        _buildLegend(sorted, percentages),
      ],
    );
  }
}