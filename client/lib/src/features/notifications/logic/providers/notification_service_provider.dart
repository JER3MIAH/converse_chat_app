import 'package:converse/src/features/notifications/logic/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notifServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
