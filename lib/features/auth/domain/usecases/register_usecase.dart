// name: register_usecase.dart
// description: Use case for user registration — validates input then delegates to repository.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      username: params.username,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String email;
  final String username;
  final String password;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
  });
}
