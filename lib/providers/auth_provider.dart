import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    
    if (userJson != null) {
      _user = User.fromJson(userJson);
      _hasCompletedOnboarding = onboardingComplete;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - in real app, verify with backend
    if (email.isNotEmpty && password.length >= 6) {
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _extractNameFromEmail(email),
        email: email,
        avatar: null,
        createdAt: DateTime.now(),
      );
      
      await _saveUserData();
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock registration - in real app, create user with backend
    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        avatar: null,
        createdAt: DateTime.now(),
      );
      
      await _saveUserData();
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _user = null;
    _hasCompletedOnboarding = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('onboarding_complete');
    
    notifyListeners();
  }

  Future<void> completeOnboarding(String updatedName) async {
    if (_user != null) {
      _user = _user!.copyWith(name: updatedName);
      _hasCompletedOnboarding = true;
      
      await _saveUserData();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? avatar}) async {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        avatar: avatar ?? _user!.avatar,
      );
      
      await _saveUserData();
      notifyListeners();
    }
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', _user!.toJson());
    }
  }

  String _extractNameFromEmail(String email) {
    final username = email.split('@')[0];
    return username.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
  }
}