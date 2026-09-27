// name: auth_repository_impl.dart
// description: Concrete implementation of AuthRepository.
//              Maps datasource exceptions to domain Failures and persists JWT.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._remoteDatasource, this._secureStorage);

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.register(
        RegisterRequest(email: email, username: username, password: password),
      );
      await _secureStorage.saveAccessToken(response.accessToken);
      return Right(_mapToEntity(response));
    } on ServerException catch (e) {
      if (e.statusCode == 422) {
        return Left(ValidationFailure(e.message, detail: e.detail));
      }
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.login(
        LoginRequest(username: username, password: password),
      );
      await _secureStorage.saveAccessToken(response.accessToken);
      return Right(_mapToEntity(response));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() => _secureStorage.hasAccessToken();

  @override
  Future<void> logout() => _secureStorage.clearAll();

  // ── Mapper ──────────────────────────────────────────────
  UserEntity _mapToEntity(AuthResponse response) => UserEntity(
        accessToken: response.accessToken,
        tokenType: response.tokenType,
      );
}
