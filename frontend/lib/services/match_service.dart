import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/services/api_client.dart';

class MatchService {
  final ApiClient _client = ApiClient();

  /// Matches against the caller's saved Profile. Throws ApiException(404, ...)
  /// if no profile has been saved yet. Used by the dashboard.
  Future<List<Scholarship>> getMatches() async {
    final json = await _client.get('/api/match') as List<dynamic>;
    return json.map((e) => Scholarship.fromJson(e)).toList();
  }

  /// Matches against criteria supplied directly, without touching a saved
  /// Profile - used by the Phase 5 guided chatbot flow. Runs through the
  /// exact same backend decision engine as getMatches().
  Future<List<Scholarship>> preview(Map<String, dynamic> criteria) async {
    final json = await _client.post('/api/match/preview', body: criteria) as List<dynamic>;
    return json.map((e) => Scholarship.fromJson(e)).toList();
  }
}
