import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/api/api_client.dart';
import '../data/repositories/summary_repository.dart';
import '../data/repositories/transaction_repository.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage);
});

final transactionRepoProvider = Provider<TransactionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransactionRepository(apiClient);
});

final summaryRepoProvider = Provider<SummaryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SummaryRepository(apiClient);
});
