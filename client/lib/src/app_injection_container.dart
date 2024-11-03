import 'package:converse/src/core/core.dart';
import 'package:converse/src/core/network/socket_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/auth_injection_container.dart';
import 'features/auth/logic/token_repository.dart';
import 'features/chat/chat_injection_container.dart';
import 'features/notifications/notificatios_injection_container.dart';

final sl = GetIt.instance;

class AppInjectionContainer {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
    sl.registerLazySingleton<TokenRepository>(
      () => TokenRepositoryImpl(
        prefs: sl(),
      ),
    );
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        tokenRepository: sl(),
      ),
    );
    sl.registerLazySingleton<SocketService>(
      () => SocketService(
        client: sl(),
      ),
    );

    await AuthInjectionContainer.init();
    await ChatInjectionContainer.init();
    await NotificatiosInjectionContainer.init();
  }
}
