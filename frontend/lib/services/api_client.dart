import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fundfinderff/config/api_config.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/services/token_storage.dart';

/// Thin wrapper around the http package: attaches the Bearer access token to
/// every authenticated call, and - if a call comes back 401 - tries exactly
/// once to silently refresh the access token and replay the original
/// request before giving up. Auth endpoints themselves (register/login/
/// refresh) are called with auth: false since they don't need a token.
class ApiClient {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<dynamic> get(String path, {bool auth = true}) =>
      _send('GET', path, auth: auth);

  Future<dynamic> post(String path, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('POST', path, body: body, auth: auth);

  Future<dynamic> put(String path, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('PUT', path, body: body, auth: auth);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    required bool auth,
    bool isRetry = false,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final encodedBody = body != null ? jsonEncode(body) : null;

    late http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(uri, headers: headers, body: encodedBody);
        break;
      case 'PUT':
        response = await http.put(uri, headers: headers, body: encodedBody);
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    if (response.statusCode == 401 && auth && !isRetry) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        return _send(method, path, body: body, auth: auth, isRetry: true);
      }
      await _tokenStorage.clear();
      throw ApiException(401, 'Session expired. Please log in again.');
    }

    if (response.statusCode == 204 || response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) return null;
      throw ApiException(response.statusCode, 'Request failed');
    }

    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = decoded is Map<String, dynamic> && decoded['message'] != null
        ? decoded['message'] as String
        : 'Request failed';
    throw ApiException(response.statusCode, message);
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (response.statusCode != 200) return false;

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: decoded['accessToken'],
        refreshToken: decoded['refreshToken'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
