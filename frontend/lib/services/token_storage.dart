import 'package:shared_preferences/shared_preferences.dart';

/// Access/refresh token persistence only - the backend now owns everything
/// else about the user (name, email, profile), so there's no need to mirror
/// those fields locally the way the old Firestore-era SharedPreferenceHelper
/// did. Good enough for a college project; not a substitute for secure
/// storage (flutter_secure_storage) in a production app.
class TokenStorage {
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
