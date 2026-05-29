import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/money.dart';
import '../state/transactions_notifier.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= 200) {
      ref.read(transactionsProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: transactionsAsync.when(
        data: (transactions) => transactions.isEmpty
            ? const Center(
                child: Text('No transactions found.'),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Vendor')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Settled')),
                      DataColumn(label: Text('Source')),
                    ],
                    rows: transactions.map((t) {
                      final displayDate = DateFormat('yyyy-MM-dd').format(t.transactionDate);

                      return DataRow(
                        cells: [
                          DataCell(Text(displayDate)),
                          DataCell(Text(formatCents(t.amountCents))),
                          DataCell(Text(t.vendorName ?? 'Unknown')),
                          DataCell(Text(t.category ?? 'Uncategorised')),
                          DataCell(
                            Icon(
                              t.isSettled ? Icons.check_circle : Icons.pending,
                              color: t.isSettled ? Colors.green : Colors.amber,
                              size: 18,
                            ),
                          ),
                          DataCell(Text(t.sourceFile ?? 'Direct Entry')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}