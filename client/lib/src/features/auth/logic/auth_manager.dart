import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/auth/logic/token_repository.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthSessionStateManager {
  final TokenRepository tokenRepository;
  AuthSessionStateManager({
    required this.tokenRepository,
  });

  AuthStatus authStatus = AuthStatus.unauthenticated;

  bool firstTimeUser = true;

  User? currentUser;

  AppToken currentToken = AppToken(token: null, user: null);

  Future<void> init() async {
    currentToken = tokenRepository.getToken();
    currentUser = currentToken.user;

    if (currentToken.user != null) {
      firstTimeUser = false;
    }

    if (currentToken.token != null && currentToken.user != null) {
      authStatus = AuthStatus.authenticated;
    } else {
      authStatus = AuthStatus.unauthenticated;
    }
  }

  Future<void> logout() async {
    await tokenRepository.updateToken(currentToken.copyWithToken(null));
    await init();
  }
}
