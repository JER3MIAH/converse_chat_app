import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/auth/logic/auth_manager.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final authManager = sl<AuthSessionStateManager>();

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (authManager.firstTimeUser) {
      return const RouteSettings(name: AuthRoutes.onboarding);
    }

    if (authManager.authStatus == AuthStatus.unauthenticated) {
      return const RouteSettings(name: AuthRoutes.login);
    }

    if (authManager.authStatus == AuthStatus.authenticated) {
      return null;
    }

    return null;
  }
}
