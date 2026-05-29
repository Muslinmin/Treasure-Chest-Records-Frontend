import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/summary.dart';
import 'providers.dart';
import '../data/api/exceptions.dart';
import "../state/auth_status.dart";


class SummaryNotifier extends AsyncNotifier<List<Summary>> {
  String? _period;


  @override
  FutureOr<List<Summary>> build() async {
    try {
      return await ref.watch(summaryRepoProvider).getSummary(period: _period);
    } on UnauthorizedException {
      handleUnauthorizedException(ref);
      rethrow; // still puts the provider into error state
    }
    
  }

  Future<void> setPeriod(String? period) async {
      _period = period;
      state = const AsyncLoading(); 
      state = await AsyncValue.guard(() async {
      try {
        return await ref.read(summaryRepoProvider).getSummary(period: _period);
      } on UnauthorizedException {
        handleUnauthorizedException(ref);
        rethrow;
      }
    });
  }
} 

class SummaryMonthlyNotifier extends AsyncNotifier<List<Summary>> {
  @override
  FutureOr<List<Summary>> build() async {

    try {
      return await ref.watch(summaryRepoProvider).getSummaryMonthly();
    } on UnauthorizedException {
      handleUnauthorizedException(ref);
      rethrow; 
    }


  }
}

final summaryProvider = AsyncNotifierProvider<SummaryNotifier, List<Summary>>(
  SummaryNotifier.new,
);

final summaryMonthlyProvider = AsyncNotifierProvider<SummaryMonthlyNotifier, List<Summary>>(
  SummaryMonthlyNotifier.new,
);