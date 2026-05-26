import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'exceptions.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  static const String _apiKeyStorageKey = 'api_key';

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await _secureStorage.read(key: _apiKeyStorageKey);

    if (apiKey == null || apiKey.isEmpty) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: const UnauthorizedException('API Key is missing or empty.'),
          type: DioExceptionType.badResponse,
        ),
      );
    }

    options.headers['Authorization'] = 'Bearer $apiKey';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    
    if (statusCode == 401 || statusCode == 403) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: UnauthorizedException('API key is invalid: Status $statusCode'),
          type: DioExceptionType.badResponse,
        ),
      );
    }
    
    handler.next(err);
  }
}