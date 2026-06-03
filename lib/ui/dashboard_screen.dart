

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api/exceptions.dart';
import '../state/summary_notifier.dart';
import '../state/providers.dart';
import '../state/auth_status.dart';

// Corrected chart widget paths
import 'charts/monthly_trend_chart.dart';
import 'charts/category_breakdown_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String? _selectedPeriod; // null = current month default

  @override
  Widget build(BuildContext context) {
    final monthlyTrendAsync = ref.watch(summaryMonthlyProvider);
    final categoryBreakdownAsync = ref.watch(summaryProvider);

    // Safely extract and sort periods chronologically before rendering
    final periods = monthlyTrendAsync.valueOrNull
        ?.map((s) => s.period)
        .toSet()
        .toList()
      ?..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SyncButton(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monthly Trend', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              monthlyTrendAsync.when(
                data: (summaries) => summaries.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: Text('No transaction history found.')),
                      )
                    : MonthlyTrendChart(summaries: summaries),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading trend: $error',
                    style: const TextStyle(color: Colors.red)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(),
              ),
              
              // Header with Sorted Dropdown Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category Breakdown', style: Theme.of(context).textTheme.titleLarge),
                  if (periods != null && periods.isNotEmpty)
                    DropdownButton<String>(
                      value: _selectedPeriod ?? periods.last,
                      items: periods.map((period) {
                        return DropdownMenuItem<String>(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          _selectedPeriod = value;
                        });
                        ref.read(summaryProvider.notifier).setPeriod(value);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              categoryBreakdownAsync.when(
                data: (summaries) => summaries.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: Text('No categorized entries for this period.')),
                      )
                    : CategoryBreakdownChart(summaries: summaries),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading breakdown: $error',
                    style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SyncButton extends ConsumerStatefulWidget {
  const SyncButton({super.key});

  @override
  ConsumerState<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends ConsumerState<SyncButton> {
  bool _isSyncing = false;

  Future<void> _sync() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      await ref.read(apiClientProvider).ingest();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Synced successfully')),
      );

      ref.invalidate(summaryMonthlyProvider);
      ref.invalidate(summaryProvider);
      
    } on UnauthorizedException {
      if (!mounted) return;
      ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSyncing) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.sync),
      tooltip: 'Sync Records',
      onPressed: _sync,
    );
  }
}

