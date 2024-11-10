import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/auth/data/login_request.dart';
import 'package:converse/src/features/auth/data/signup_request.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(authService: sl());
});

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  AuthProvider({
    required this.authService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required String avatar,
  }) async {
    setLoading(true);
    final res = await authService.signup(
      SignUpRequest(
          username: username, email: email, avatar: avatar, password: password),
    );
    setLoading(false);
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (response) {
      authManager.init();
      return true;
    });
  }

  Future<bool> login({required String email, required String password}) async {
    setLoading(true);
    final res =
        await authService.login(LoginRequest(email: email, password: password));
    setLoading(false);
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (response) {
      authManager.init();
      return true;
    });
  }

  // Future<bool> saveFcmToken() async {
  //   final res = await authService.saveFcmToken();
  //   setLoading(false);
  //   return res.fold((failure) {
  //     setErrorMessage(failure.message);
  //     return false;
  //   }, (response) {
  //     return true;
  //   });
  // }
}
