import 'package:flutter/material.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  User? get user => _user;

  AuthProvider() {
    // Auto-login for development
    // _user = User(id: 1, username: 'testuser', email: 'user@example.com');
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, validate credentials against API
      if (email == 'user@example.com' && password == 'password') {
        _user = User(id: 1, username: 'testuser', email: email);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}