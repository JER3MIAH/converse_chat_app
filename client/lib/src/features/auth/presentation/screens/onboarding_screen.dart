import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppColumn(
        children: [
          const AppText('Onboarding Screen'),
          YBox(50.h),
          AppButton(
            title: 'Get Started',
            onTap: () {
              AppNavigator.pushNamed(AuthRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
