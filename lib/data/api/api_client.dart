import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_interceptor.dart';
import 'models/transaction_response.dart';
import 'models/summary_response.dart';

class ApiClient {
  final Dio dio;
  static const String _baseUrl = String.fromEnvironment('BASE_URL');

  ApiClient(FlutterSecureStorage secureStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(AuthInterceptor(secureStorage));
  }

  // POST /ingest
  Future<Map<String, dynamic>> ingest() async {
      final response = await dio.post<Map<String, dynamic>>('/ingest');
      return response.data ?? {};
  }


  // GET /transactions
  Future<List<TransactionResponse>> getTransactions({
    String? dateFrom,
    String? dateTo,
    String? category,
    int retrieveLimit = 50,
    int offset = 0,
  }) async {
    // Build query parameters map and dynamically omit null values
    final queryParams = <String, dynamic>{
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (category != null) 'category': category,
      'retrieve_limit': retrieveLimit,
      'offset': offset,
    };

    final response = await dio.get<List<dynamic>>(
      '/transactions',
      queryParameters: queryParams,
    );

    final data = response.data ?? [];
    return data
        .map((json) => TransactionResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }


  // GET /summary
  Future<List<SummaryResponse>> getSummary({String? period}) async {
    final queryParams = <String, dynamic>{
      if (period != null) 'period': period,
    };

    final response = await dio.get<List<dynamic>>(
      '/summary',
      queryParameters: queryParams,
    );

    final data = response.data ?? [];
    return data
        .map((json) => SummaryResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // GET /summary/monthly
  Future<List<SummaryResponse>> getSummaryMonthly() async {
    final response = await dio.get<List<dynamic>>('/summary/monthly');

    final data = response.data ?? [];
    return data
        .map((json) => SummaryResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }

}