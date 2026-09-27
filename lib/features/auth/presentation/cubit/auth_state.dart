// name: auth_state.dart
// description: Sealed state classes for AuthCubit.
//              Covers initial check, loading, authenticated, and error states.

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Initial state — checking stored token.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Token check / login / register in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated.
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

/// Not authenticated (no token, logged out, or 401).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An error occurred during auth flow.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
