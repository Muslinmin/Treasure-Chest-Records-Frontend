import '../../data/api/api_client.dart';
import '../../domain/entities/transaction.dart';
import '../api/models/transaction_response.dart';

class TransactionRepository {
  final ApiClient _apiClient;
  TransactionRepository(this._apiClient);

  Future<List<Transaction>> getTransactions({
    String? dateFrom,
    String? dateTo,
    String? category,
    int limit = 50,
    int offset = 0,
  }) async {
    final List<TransactionResponse> responses = await _apiClient.getTransactions(
      dateFrom: dateFrom,
      dateTo: dateTo,
      category: category,
      retrieveLimit: limit,
      offset: offset,
    );
    return responses.map((dto) => dto.toDomain()).toList();
  }
}
