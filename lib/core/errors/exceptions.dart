// name: exceptions.dart
// description: Data-layer exception types thrown by datasources.
//              Converted to Failures at the repository boundary.

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? detail;

  const ServerException({
    required this.message,
    this.statusCode,
    this.detail,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Unauthorized']);

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}
