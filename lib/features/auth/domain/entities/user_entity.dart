// name: user_entity.dart
// description: Pure domain entity for an authenticated user.
//              Contains access token and optional refresh token.

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;

  const UserEntity({
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType];
}
