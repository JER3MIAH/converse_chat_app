import 'package:converse/src/features/auth/logic/providers/auth_service_provider.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpProvider = ChangeNotifierProvider((ref) {
  return SingupProvider(authService: ref.read(authServiceProvider));
});

class SingupProvider extends ChangeNotifier {
  final AuthService authService;
  SingupProvider({
    required this.authService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String userName = '';
  String email = '';
  String password = '';
  String errorMessage = '';

  UserCredential? userCredential;

  bool _buttonEnabled = false;
  bool get buttonEnabled => _buttonEnabled;
  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    notifyListeners();
  }

  void onInputChanged({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (userName.isNotEmpty &&
        email.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password.isNotEmpty) {
      buttonEnabled = true;
    } else {
      buttonEnabled = false;
    }
  }

  Future<bool> signUp(
      {required String username,
      required String email,
      required String password}) async {
    isLoading = true;
    try {
      userCredential = await authService.signUp(username, email, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      return false;
    }
  }

  void disposeValues() {
    userName = '';
    email = '';
    password = '';
    errorMessage = '';
  }
}
