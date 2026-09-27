// name: auth_repository.dart
// description: Abstract auth repository interface (port) for the domain layer.
//              Returns Either<Failure, T> for explicit error handling.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  /// Registers a new user and returns the session entity.
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logs in and returns the session entity.
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  /// Checks if a stored valid token exists.
  Future<bool> isAuthenticated();

  /// Logs out by clearing the stored token.
  Future<void> logout();
}
