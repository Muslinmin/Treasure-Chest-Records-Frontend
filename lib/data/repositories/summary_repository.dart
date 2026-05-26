import '../../data/api/api_client.dart';
import '../../domain/entities/summary.dart';
import '../api/models/summary_response.dart';

class SummaryRepository {
  final ApiClient _apiClient;
  SummaryRepository(this._apiClient);

  Future<List<Summary>> getSummary({
    String? period,
  }) async {
    final List<SummaryResponse> responses = await _apiClient.getSummary(
      period: period
    );
    return responses.map((dto) => dto.toDomain()).toList();
  }

  Future<List<Summary>> getSummaryMonthly() async {
    final List<SummaryResponse> responses = await _apiClient.getSummaryMonthly();
    return responses.map((dto) => dto.toDomain()).toList();
  }


}
