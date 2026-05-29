import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/transaction.dart';
import 'providers.dart';
import '../data/api/exceptions.dart';
import "../state/auth_status.dart";


class TransactionsNotifier extends AsyncNotifier<List<Transaction>> {
  int _offset = 0;
  bool _hasMore = true;
  static const int _limit = 50;

  String? _dateFrom;
  String? _dateTo;
  String? _category;

  @override
  FutureOr<List<Transaction>> build() async {
    _offset = 0;
    _hasMore = true;
    _dateFrom = null;
    _dateTo = null;
    _category = null;
    try{
      return ref.watch(transactionRepoProvider).getTransactions(limit: _limit, offset: _offset,);
    }on UnauthorizedException {
      handleUnauthorizedException(ref);
      rethrow;
    }

  }
  Future<void> setFilters({
    String? dateFrom,
    String? dateTo,
    String? category,
  }) async {
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    _category = category;
    _offset = 0;
    _hasMore = true;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        return await ref.read(transactionRepoProvider).getTransactions(
          dateFrom: _dateFrom,
          dateTo: _dateTo,
          category: _category,
          limit: _limit,
          offset: _offset,
        );
      } on UnauthorizedException {
        handleUnauthorizedException(ref);
        rethrow; // Rethrow so guard() records it in the state
      }
    });
  }


  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasError || !_hasMore) return;

    final previousData = state.value ?? [];
    final targetOffset = _offset + _limit;

    final nextResponse = await AsyncValue.guard(() async {
      try {
        return await ref.read(transactionRepoProvider).getTransactions(
          dateFrom: _dateFrom,
          dateTo: _dateTo,
          category: _category,
          limit: _limit,
          offset: targetOffset,
        );
      } on UnauthorizedException {
        handleUnauthorizedException(ref);
        rethrow;
      }
    });

    nextResponse.when(
      data: (newItems) {
        _offset = targetOffset;
        if (newItems.length < _limit) _hasMore = false;
        state = AsyncData([...previousData, ...newItems]);
      },
      error: (error, stackTrace) => state = AsyncError(error, stackTrace),
      loading: () {},
    );
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<Transaction>>(
  TransactionsNotifier.new,
);