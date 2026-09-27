// name: api_constants.dart
// description: All API endpoint constants and base URL configuration.

class ApiConstants {
  ApiConstants._();

  // ── Base URL (local dev) ─────────────────────────────────
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator / web

  static const String apiVersion = '/api/v1';

  // ── Auth ──────────────────────────────────────────────────
  static const String register = '$apiVersion/auth/register';
  static const String login    = '$apiVersion/auth/login';

  // ── Users ─────────────────────────────────────────────────
  static const String me        = '$apiVersion/users/me';
  static const String analytics = '$apiVersion/users/me/analytics';

  // ── Chat ──────────────────────────────────────────────────
  static const String chat          = '$apiVersion/chat/';
  static const String conversations = '$apiVersion/chat/conversations';

  // ── Documents ─────────────────────────────────────────────
  static const String documents = '$apiVersion/documents';

  // ── Health ────────────────────────────────────────────────
  static const String health = '/health';

  // ── Timeouts ──────────────────────────────────────────────
  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 30000;
}
