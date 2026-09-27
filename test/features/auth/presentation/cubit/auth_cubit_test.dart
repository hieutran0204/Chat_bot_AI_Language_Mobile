// name: auth_cubit_test.dart
// description: Unit tests for AuthCubit (login, register, logout, checkAuthStatus).

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:language_ai_mobile/core/errors/failures.dart';
import 'package:language_ai_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:language_ai_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:language_ai_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:language_ai_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:language_ai_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:language_ai_mobile/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit cubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockAuthRepository mockAuthRepository;

  const testUser = UserEntity(accessToken: 'token_123', tokenType: 'bearer');

  setUpAll(() {
    registerFallbackValue(const LoginParams(username: '', password: ''));
    registerFallbackValue(const RegisterParams(email: '', username: '', password: ''));
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockAuthRepository = MockAuthRepository();

    cubit = AuthCubit(
      mockLoginUseCase,
      mockRegisterUseCase,
      mockAuthRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AuthInitial', () {
    expect(cubit.state, equals(const AuthInitial()));
  });

  group('checkAuthStatus', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when token exists',
      build: () {
        when(() => mockAuthRepository.isAuthenticated())
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthLoading(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no token exists',
      build: () {
        when(() => mockAuthRepository.isAuthenticated())
            .thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on successful login',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.login(username: 'test', password: 'password123'),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));
        return cubit;
      },
      act: (cubit) => cubit.login(username: 'test', password: 'wrongpassword'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on successful register',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => const Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when register fails',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Username already exists')));
        return cubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        username: 'existing',
        password: 'password123',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Username already exists'),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthUnauthenticated] when logout is called',
      build: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthUnauthenticated(),
      ],
    );
  });
}
