import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/notifications/logic/services/notification_service.dart';

class NotificatiosInjectionContainer {
  static Future<void> init() async {
    sl.registerLazySingleton<NotificationService>(() => NotificationService());
  }
}
