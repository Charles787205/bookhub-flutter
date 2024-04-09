import 'package:bookhub/objects/user.dart';
import 'package:flutter/material.dart';

class AuthManager extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    // Perform login logic, e.g., communicate with PHP backend
    // Upon successful login, set _isLoggedIn to true
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    // Perform logout logic, e.g., communicate with PHP backend
    // Upon successful logout, set _isLoggedIn to false
    _isLoggedIn = false;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
