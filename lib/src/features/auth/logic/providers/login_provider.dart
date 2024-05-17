import 'package:converse/src/features/auth/logic/providers/auth_service_provider.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider((ref) => LoginProvider(
      authService: ref.read(authServiceProvider),
    ));

class LoginProvider extends ChangeNotifier {
  final AuthService authService;
  LoginProvider({
    required this.authService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _buttonEnabled = false;
  bool get buttonEnabled => _buttonEnabled;
  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    notifyListeners();
  }

  String errorMessage = '';

  UserCredential? userCredential;

  void onInputChanged({
    required String email,
    required String password,
  }) {
    if (email.isNotEmpty && password.isNotEmpty) {
      buttonEnabled = true;
    } else {
      buttonEnabled = false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    try {
      userCredential = await authService.logIn(email, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      return false;
    }
  }
}
