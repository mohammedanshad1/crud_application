import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Completes once the first auth state event is received
  final Completer<void> _authReadyCompleter = Completer<void>();
  Future<void> get authStateReady => _authReadyCompleter.future;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  // Constructor
  AuthViewModel() {
    _initialize();
  }

  // Initialize auth state
void _initialize() {
  // Immediate check
  _user = _authService.currentUser;
  if (_user != null && !_authReadyCompleter.isCompleted) {
    _authReadyCompleter.complete();
  }

  _authService.authStateChanges.listen((user) {
    _user = user;
    notifyListeners();

    if (!_authReadyCompleter.isCompleted) {
      _authReadyCompleter.complete();
    }
  });
}

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
      );
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}