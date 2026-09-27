// name: secure_storage.dart
// description: Wrapper around flutter_secure_storage for JWT token persistence.
//              Provides typed read/write/delete methods for access and refresh tokens.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage {
  final FlutterSecureStorage _storage;

  static const _keyAccessToken  = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  /// Persist the JWT access token and optional refresh token.
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  /// Persist only the access token.
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  /// Read the stored JWT access token. Returns null if not present.
  Future<String?> getAccessToken() =>
      _storage.read(key: _keyAccessToken);

  /// Read the stored refresh token. Returns null if not present.
  Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  /// Delete both tokens (on logout).
  Future<void> deleteAccessToken() =>
      _storage.delete(key: _keyAccessToken);

  /// Check whether an access token is currently stored.
  Future<bool> hasAccessToken() async {
    final token = await _storage.read(key: _keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  /// Clear all secure storage (full logout).
  Future<void> clearAll() => _storage.deleteAll();
}
