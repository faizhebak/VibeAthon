import 'package:flutter/material.dart';

import '../core/mock_data.dart';
import '../models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserProfile? _currentUser;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = MockData.currentUser;
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = UserProfile(
      id: 'u_new',
      name: name,
      email: email,
      preferredFuelType: 'RON95',
      monthlyBudget: 300.0,
      avatarInitials: _computeInitials(name),
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeProfileSetup(
    String preferredFuelType,
    double monthlyBudget,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = _currentUser?.copyWith(
      preferredFuelType: preferredFuelType,
      monthlyBudget: monthlyBudget,
    );
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(
    String name,
    String preferredFuelType,
    double monthlyBudget,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final initials = _computeInitials(name);
    _currentUser = _currentUser?.copyWith(
      name: name,
      preferredFuelType: preferredFuelType,
      monthlyBudget: monthlyBudget,
      avatarInitials: initials,
    );
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  String _computeInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length > 1 && parts.last.isNotEmpty) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    final first = parts.first;
    if (first.length >= 2) {
      return first.substring(0, 2).toUpperCase();
    }
    return first.toUpperCase();
  }
}
