import 'package:flutter/foundation.dart';
import 'package:fundfinderff/models/user.dart';
import 'package:fundfinderff/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoggedIn = false;
  AppUser? currentUser;

  Future<void> checkAuthStatus() async {
    isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> register(String fullName, String email, String password) async {
    await _authService.register(fullName, email, password);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    currentUser = await _authService.me();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    isLoggedIn = false;
    currentUser = null;
    notifyListeners();
  }
}
