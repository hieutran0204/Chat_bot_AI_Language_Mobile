// name: login_usecase.dart
// description: Use case for user login — single responsibility business logic unit.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  /// Params for the login use case.
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParams {
  final String username;
  final String password;
  const LoginParams({required this.username, required this.password});
}
