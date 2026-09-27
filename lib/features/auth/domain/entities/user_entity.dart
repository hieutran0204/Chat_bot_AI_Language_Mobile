// name: user_entity.dart
// description: Pure domain entity for an authenticated user.
//              No framework dependencies — plain Dart.

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String accessToken;
  final String tokenType;

  const UserEntity({
    required this.accessToken,
    required this.tokenType,
  });

  @override
  List<Object?> get props => [accessToken, tokenType];
}
