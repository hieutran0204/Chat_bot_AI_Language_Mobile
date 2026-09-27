// name: failures.dart
// description: Domain-layer failure types using sealed class pattern.
//              Maps to BE error categories (auth, network, server).

import 'package:equatable/equatable.dart';

/// Base failure class — all domain failures extend this.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// HTTP 4xx / 5xx from the server.
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// 401 Unauthorized — JWT expired or invalid.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Unauthorized. Please login again.']);
}

/// 422 Validation error from FastAPI.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? detail;
  const ValidationFailure(super.message, {this.detail});

  @override
  List<Object?> get props => [message, detail];
}

/// Local cache / storage errors.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}
