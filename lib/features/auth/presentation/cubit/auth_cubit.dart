// name: auth_cubit.dart
// description: AuthCubit orchestrates login, register, and session check.
//              Drives GoRouter redirect via AuthAuthenticated / AuthUnauthenticated.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._authRepository,
  ) : super(const AuthInitial());

  // ── Session Check (app startup) ───────────────────────────
  /// Called once at startup to restore session from secure storage.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final isAuth = await _authRepository.isAuthenticated();
    emit(
      isAuth
          ? const AuthAuthenticated(_RestoredUser())
          : const AuthUnauthenticated(),
    );
  }

  // ── Login ─────────────────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user)    => emit(AuthAuthenticated(user)),
    );
  }

  // ── Register ──────────────────────────────────────────────
  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(email: email, username: username, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user)    => emit(AuthAuthenticated(user)),
    );
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}

/// Placeholder UserEntity used when restoring session from stored token.
/// The actual token is retrieved by the interceptor from SecureStorage directly.
class _RestoredUser extends UserEntity {
  const _RestoredUser() : super(accessToken: 'restored', tokenType: 'bearer');
}
