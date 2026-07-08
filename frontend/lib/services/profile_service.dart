import 'package:fundfinderff/models/profile.dart';
import 'package:fundfinderff/services/api_client.dart';

class ProfileService {
  final ApiClient _client = ApiClient();

  /// Throws ApiException(404, ...) if the user hasn't completed their profile yet.
  Future<Profile> getProfile() async {
    final json = await _client.get('/api/profile');
    return Profile.fromJson(json);
  }

  Future<Profile> saveProfile(Profile profile) async {
    final json = await _client.put('/api/profile', body: profile.toJson());
    return Profile.fromJson(json);
  }
}
