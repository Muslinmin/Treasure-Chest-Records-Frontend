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
  static const String _kAll = '__all__';
  static const String _kEverythingElse = '__everything_else__';

  // Starts with the "All spending" total line; grows to a maximum of 3
  List<String> _selectedSeries = [_kAll];

  // One colour per series slot used as a drawing pool
  static const List<Color> _palette = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.teal,
  ];

  // Persistent visual mapping to ensure unique data streams do not change color when rows shift
  final Map<String, Color> _seriesColours = {
    _kAll: _palette[0],
  };

  /// Returns a sorted list of unique category names from `widget.summaries`.
  List<String> get _categories {
    final categoryNames = widget.summaries.map((s) => s.category).toSet().toList();
    categoryNames.sort();
    return categoryNames;
  }

  /// Returns Map<String, int> of period → totalCents for one series key.
  Map<String, int> _seriesData(String key, Map<String, int> allPeriodTotals) {
    final Map<String, int> result = {};

    if (key == _kAll) {
      return Map.from(allPeriodTotals);
    }

    if (key == _kEverythingElse) {
      // Base line is overall totals
      allPeriodTotals.forEach((period, total) {
        result[period] = total;
      });

      // Deduct any other active named category series selection slots
      for (final selectedKey in _selectedSeries) {
        if (selectedKey == _kAll || selectedKey == _kEverythingElse) continue;
        
        final namedData = widget.summaries.where((s) => s.category == selectedKey);
        for (final item in namedData) {
          final current = result[item.period] ?? 0;
          result[item.period] = current - item.totalCents;
        }
      }
      return result;
    }

    // Standard specific expenditure categories matching
    final matched = widget.summaries.where((s) => s.category == key);
    for (final item in matched) {
      result[item.period] = (result[item.period] ?? 0) + item.totalCents;
    }
    return result;
  }

  LineChartBarData _buildLine(List<FlSpot> spots, Color colour) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      barWidth: 3,
      color: colour,
      dotData: const FlDotData(show: true),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(_selectedSeries.length, (index) {
        final key = _selectedSeries[index];
        String label = key;
        if (key == _kAll) label = 'All';
        if (key == _kEverythingElse) label = 'Everything else';

        return InputChip(
          label: Text(label),
          avatar: CircleAvatar(
            backgroundColor: _seriesColours[key] ?? _palette[0],
            radius: 6,
          ),
          onDeleted: _selectedSeries.length > 1
              ? () {
                  setState(() {
                    _seriesColours.remove(key);
                    _selectedSeries.removeAt(index);
                  });
                }
              : null,
        );
      }),
    );
  }

  Widget _buildSeriesPicker() {
    final remainingOptions = <String>[];

    if (!_selectedSeries.contains(_kAll)) {
      remainingOptions.add(_kAll);
    }

    final hasNamedCategory = _selectedSeries.any(
      (key) => key != _kAll && key != _kEverythingElse,
    );
    if (hasNamedCategory && _categories.length > 1 && !_selectedSeries.contains(_kEverythingElse)) {
      remainingOptions.add(_kEverythingElse);
    }

    for (final cat in _categories) {
      if (!_selectedSeries.contains(cat)) {
        remainingOptions.add(cat);
      }
    }

    if (remainingOptions.isEmpty) return const SizedBox.shrink();

    return DropdownButton<String>(
      hint: const Text('Add data comparison split...'),
      isExpanded: true,
      items: remainingOptions.map((option) {
        String display = option;
        if (option == _kAll) display = 'All spending';
        if (option == _kEverythingElse) display = 'Everything else';
        return DropdownMenuItem<String>(
          value: option,
          child: Text(display),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            final used = _seriesColours.values.toSet();
            final next = _palette.firstWhere(
              (c) => !used.contains(c),
              orElse: () => _palette[0],
            );
            _seriesColours[value] = next;
            _selectedSeries.add(value);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group all incoming transaction summaries historical baseline aggregates
    final Map<String, int> allPeriodTotals = {};
    for (final s in widget.summaries) {
      allPeriodTotals[s.period] = (allPeriodTotals[s.period] ?? 0) + s.totalCents;
    }

    final sortedPeriods = allPeriodTotals.keys.toList()..sort();
    if (sortedPeriods.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No chronological trend telemetry available')),
      );
    }

    final List<Map<String, int>> evaluations = [];
    for (final key in _selectedSeries) {
      evaluations.add(_seriesData(key, allPeriodTotals));
    }

    final List<LineChartBarData> lines = [];
    for (int i = 0; i < _selectedSeries.length; i++) {
      final key = _selectedSeries[i];
      final dataMap = evaluations[i];
      final List<FlSpot> spots = [];

      for (int x = 0; x < sortedPeriods.length; x++) {
        final period = sortedPeriods[x];
        final cents = dataMap[period] ?? 0;
        spots.add(FlSpot(x.toDouble(), centsToChartValue(cents)));
      }

      lines.add(_buildLine(spots, _seriesColours[key] ?? _palette[0]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegend(),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              lineBarsData: lines,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: sortedPeriods.length > 9 ? 3 : sortedPeriods.length > 5 ? 2 : 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= sortedPeriods.length) {
                        return const SizedBox.shrink();
                      }
                      final fullPeriod = sortedPeriods[idx];
                      final parts = fullPeriod.split('-');
                      final shortLabel = parts.length == 2
                          ? '${parts[1]}/${parts[0].substring(2)}'
                          : fullPeriod;
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          shortLabel,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      final abs = value.abs();
                      final sign = value < 0 ? '-' : '';
                      final label = abs >= 1000
                          ? '$sign\$${(abs / 1000).toStringAsFixed(1)}k'
                          : '$sign\$${abs.toStringAsFixed(0)}';
                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.95),
                  maxContentWidth: 180,
                  getTooltipItems: (touchedSpots) {
                    if (touchedSpots.isEmpty) return [];
                    final int periodIndex = touchedSpots.first.x.toInt();
                    final String periodLabel = sortedPeriods[periodIndex];

                    return touchedSpots.map((spot) {
                      final seriesIndex = spot.barIndex;
                      final seriesKey = _selectedSeries[seriesIndex];
                      
                      String label = seriesKey;
                      if (seriesKey == _kAll) label = 'All';
                      if (seriesKey == _kEverythingElse) label = 'Everything else';

                      // Re-evaluate accurate cents to avoid floating point drift from the chart spot
                      final dataMap = _seriesData(seriesKey, allPeriodTotals);
                      final calculatedCents = dataMap[periodLabel] ?? 0;

                      return LineTooltipItem(
                        '$label\n',
                        TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: formatCents(calculatedCents),
                            style: TextStyle(
                              color: _seriesColours[seriesKey] ?? _palette[0], // Stable color matching line representation
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedSeries.length < 3) _buildSeriesPicker(),
      ],
    );
  }
}