// name: api_constants.dart
// description: All API endpoint constants and base URL configuration loaded from .env.

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  // ── Base URL loaded from .env with fallback ──────────────
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000';

  static String get apiVersion =>
      dotenv.env['API_VERSION'] ?? '/api/v1';

  // ── Auth ──────────────────────────────────────────────────
  static String get register => '$apiVersion/auth/register';
  static String get login    => '$apiVersion/auth/login';

  // ── Users ─────────────────────────────────────────────────
  static String get me        => '$apiVersion/users/me';
  static String get analytics => '$apiVersion/users/me/analytics';

  // ── Chat ──────────────────────────────────────────────────
  static String get chat          => '$apiVersion/chat/';
  static String get conversations => '$apiVersion/chat/conversations';

  // ── Documents ─────────────────────────────────────────────
  static String get documents => '$apiVersion/documents';

  // ── Health ────────────────────────────────────────────────
  static const String health = '/health';

  // ── Timeouts ──────────────────────────────────────────────
  static int get connectTimeoutMs =>
      int.tryParse(dotenv.env['CONNECT_TIMEOUT_MS'] ?? '') ?? 10000;
  static int get receiveTimeoutMs =>
      int.tryParse(dotenv.env['RECEIVE_TIMEOUT_MS'] ?? '') ?? 30000;
}
