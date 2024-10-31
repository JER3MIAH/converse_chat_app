import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/auth/logic/auth_manager.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';

class AuthInjectionContainer {
  static Future<void> init() async {
    sl.registerLazySingleton<AuthService>(
        () => AuthServiceImpl(tokenRepository: sl(), client: sl()));

    sl.registerLazySingleton<AuthSessionStateManager>(
      () => AuthSessionStateManager(tokenRepository: sl()),
    );
  }
}
