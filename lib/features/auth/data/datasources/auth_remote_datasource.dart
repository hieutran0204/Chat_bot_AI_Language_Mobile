// name: auth_remote_datasource.dart
// description: Remote datasource for auth API calls (register + login).
//              Handles FastAPI form-encoded login and JSON register.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_models.dart';

abstract interface class AuthRemoteDatasource {
  /// Registers a new user. Returns [AuthResponse] with JWT on success.
  Future<AuthResponse> register(RegisterRequest request);

  /// Logs in an existing user. Returns [AuthResponse] with JWT.
  /// Note: FastAPI expects multipart/form-data for OAuth2PasswordRequestForm.
  Future<AuthResponse> login(LoginRequest request);
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      return AuthResponse.fromSnakeJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return AuthResponse.fromSnakeJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  /// Converts DioException errors into typed app exceptions.
  Never _handleDioError(DioException e) {
    final error = e.error;
    if (error is ServerException) throw error;
    if (error is AuthException) throw error;
    if (error is NetworkException) throw error;
    throw ServerException(
      message: e.message ?? 'Unknown error',
      statusCode: e.response?.statusCode,
    );
  }
}
