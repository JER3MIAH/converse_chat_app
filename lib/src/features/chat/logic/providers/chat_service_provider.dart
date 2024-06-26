import 'package:converse/src/features/chat/logic/services/chat_service.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/notifications/logic/providers/notification_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>(
  (ref) => ChatService(
    userProvider: ref.read(userProvider),
    notificationService: ref.read(notifServiceProvider),
  ),
);
