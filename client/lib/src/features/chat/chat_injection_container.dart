import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/chat/logic/services/chat_service.dart';

class ChatInjectionContainer {
  static Future<void> init() async {
    sl.registerLazySingleton<ChatService>(
      () => ChatServiceImpl(client: sl()),
    );
  }
}
