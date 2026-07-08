import 'package:flutter/foundation.dart';
import 'package:fundfinderff/models/profile.dart';
import 'package:fundfinderff/services/api_exception.dart';
import 'package:fundfinderff/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  Profile? profile;
  bool hasProfile = false;
  bool loading = false;

  /// Distinguishes "no profile saved yet" (expected for a new user, not an
  /// error) from a genuine network/server failure.
  Future<void> fetchProfile() async {
    loading = true;
    notifyListeners();
    try {
      profile = await _profileService.getProfile();
      hasProfile = true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        hasProfile = false;
      } else {
        rethrow;
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(Profile newProfile) async {
    profile = await _profileService.saveProfile(newProfile);
    hasProfile = true;
    notifyListeners();
  }

  void reset() {
    profile = null;
    hasProfile = false;
    notifyListeners();
  }
}
