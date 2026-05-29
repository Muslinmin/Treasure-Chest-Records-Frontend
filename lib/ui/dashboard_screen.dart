// lib/ui/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api/exceptions.dart';
import '../domain/money.dart';
import '../state/summary_notifier.dart';
import '../state/providers.dart';
import '../state/auth_status.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyTrendAsync = ref.watch(summaryMonthlyProvider);
    final categoryBreakdownAsync = ref.watch(summaryProvider);

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
                data: (summaries) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: summaries.isEmpty 
                    ? [const Text('No transaction history found.')]
                    : summaries.map((s) => Text('${s.period}: ${formatCents(s.totalCents)}')).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading trend: $error', style: const TextStyle(color: Colors.red)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(),
              ),
              Text('Category Breakdown', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              categoryBreakdownAsync.when(
                data: (summaries) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: summaries.isEmpty 
                    ? [const Text('No categorized entries for this period.')]
                    : summaries.map((s) => Text('${s.category}: ${formatCents(s.totalCents)} (${s.txCount} txs)')).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading breakdown: $error', style: const TextStyle(color: Colors.red)),
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