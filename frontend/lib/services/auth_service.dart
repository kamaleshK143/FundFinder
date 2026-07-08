import 'package:fundfinderff/models/auth_response.dart';
import 'package:fundfinderff/models/user.dart';
import 'package:fundfinderff/services/api_client.dart';
import 'package:fundfinderff/services/token_storage.dart';

class AuthService {
  final ApiClient _client = ApiClient();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<AuthResponse> register(String fullName, String email, String password) async {
    final json = await _client.post('/api/auth/register', auth: false, body: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });
    final auth = AuthResponse.fromJson(json);
    await _tokenStorage.saveTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);
    return auth;
  }

  Future<AuthResponse> login(String email, String password) async {
    final json = await _client.post('/api/auth/login', auth: false, body: {
      'email': email,
      'password': password,
    });
    final auth = AuthResponse.fromJson(json);
    await _tokenStorage.saveTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);
    return auth;
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _client.post('/api/auth/logout', auth: false, body: {'refreshToken': refreshToken});
      } catch (_) {
        // Best-effort server-side revocation; local tokens are cleared regardless.
      }
    }
    await _tokenStorage.clear();
  }

  Future<AppUser> me() async {
    final json = await _client.get('/api/auth/me');
    return AppUser.fromJson(json);
  }

  Future<bool> isLoggedIn() async {
    return await _tokenStorage.getAccessToken() != null;
  }
}
