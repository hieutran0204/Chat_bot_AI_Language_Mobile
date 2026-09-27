// name: dio_client.dart
// description: Singleton Dio HTTP client with JWT auth interceptor and error handling.
//              Automatically injects Bearer token and handles 401 by clearing credentials.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient(SecureStorage secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptors ──────────────────────────────────────
    _dio.interceptors.add(_AuthInterceptor(secureStorage));

    // ── Logger (debug only) ───────────────────────────────
    assert(() {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());
  }

  Dio get dio => _dio;
}

// ─────────────────────────────────────────────────────────
/// Intercepts every request to inject the JWT Bearer token.
/// On 401, clears stored token and rethrows as [AuthException].
// ─────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  _AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      _secureStorage.deleteAccessToken();
      final data = err.response?.data;
      final serverMessage = _extractMessage(data);
      final isAuthEndpoint = err.requestOptions.path.contains('/auth/');
      final errorMessage = (serverMessage.isNotEmpty && serverMessage != 'Unknown server error')
          ? serverMessage
          : (isAuthEndpoint ? 'Invalid credentials' : 'Session expired. Please login again.');

      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: AuthException(errorMessage),
          type: DioExceptionType.badResponse,
          response: err.response,
        ),
      );
      return;
    }

    if (statusCode != null && statusCode >= 400) {
      final data = err.response?.data;
      final message = _extractMessage(data);
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message: message, statusCode: statusCode, detail: data),
          type: DioExceptionType.badResponse,
          response: err.response,
        ),
      );
      return;
    }

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    handler.next(err);
  }

  /// Extracts the human-readable message from FastAPI error responses.
  /// FastAPI returns: { "detail": "..." } or { "detail": [...] }
  String _extractMessage(dynamic data) {
    if (data == null) return 'Unknown server error';
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        return detail.map((e) => e['msg'] ?? '').join(', ');
      }
    }
    return data.toString();
  }
}
