import 'package:flutter/foundation.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/services/match_service.dart';

class MatchProvider extends ChangeNotifier {
  final MatchService _matchService = MatchService();

  List<Scholarship> matches = [];
  bool loading = false;
  bool needsProfile = false;
  String? error;

  Future<void> fetchMatches() async {
    loading = true;
    error = null;
    needsProfile = false;
    notifyListeners();
    try {
      matches = await _matchService.getMatches();
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        needsProfile = true;
      } else {
        error = e.message;
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
