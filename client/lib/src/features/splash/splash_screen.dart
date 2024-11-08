import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/core/network/socket_service.dart';
import 'package:converse/src/features/auth/logic/auth_manager.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/features/notifications/logic/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;

    useEffect(() {
      authManager.init();
      sl<NotificationService>().requestPermission();
      sl<NotificationService>().initInfo();
      if (authManager.authStatus == AuthStatus.authenticated) {
        sl<SocketService>().initializeSocket();
        sl<AuthService>().saveFcmToken();
        ref.read(chatProvider.notifier).getAllUsers();
        ref.read(chatProvider.notifier).getChats();
      }
      Future.delayed(
        const Duration(milliseconds: 4000),
        () => AppNavigator.replaceAllNamed(HomeRoutes.home),
      );
      return null;
    }, const []);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.inversePrimary,
        ),
        child: Center(
          child: Lottie.asset(
            'assets/jsons/appIconAnimation.json',
            repeat: false,
          ),
        ),
      ),
    );
  }
}
