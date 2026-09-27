// name: auth_models.dart
// description: Request/Response Pydantic-mapped models for auth endpoints.
//              Matches FastAPI /auth/register and /auth/login schemas.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// ── POST /api/v1/auth/register ────────────────────────────

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String username,
    required String password,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

// ── POST /api/v1/auth/login ───────────────────────────────
// FastAPI expects JSON body with email and password

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

// ── Response: { access_token, refresh_token, token_type } ─

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    String? refreshToken,
    @Default('bearer') String tokenType,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  static AuthResponse fromSnakeJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
        tokenType: (json['token_type'] as String?) ?? 'bearer',
      );
}
