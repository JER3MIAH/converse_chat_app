import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: theme.primary,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 75.w)
                      .copyWith(top: 50.h),
                  child: Image.asset(appIcon),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'Stay Connected!',
                  color: theme.onSurface,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                YBox(15.h),
                AppText(
                  'Chat with your friends and family,\n anytime, anywhere',
                  color: theme.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                YBox(MediaQuery.of(context).size.height * .12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary,
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: SliderButton(
                    action: () async {
                      AppNavigator.replaceNamed(AuthRoutes.login);
                      return null;
                    },
                    backgroundColor: theme.primary,
                    shimmer: false,
                    alignLabel: Alignment.center,
                    buttonSize: 58,
                    label: AppText(
                      'Swipe to start...',
                      color: appColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    icon: Icon(
                      Icons.start,
                      color: theme.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
