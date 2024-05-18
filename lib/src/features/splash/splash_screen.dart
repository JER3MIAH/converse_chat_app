import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
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
      ref.read(userProvider.notifier).retrieveUserInfo();
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
