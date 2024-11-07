import 'package:converse/src/features/auth/logic/providers/auth_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
     final theme = Theme.of(context).colorScheme;
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: AppColumn(
        children: [
          const AppText('Sign up Screen'),
          YBox(30.h),
          AppTextField(
            labelText: 'Username',
            hintText: 'Enter your username',
            controller: nameController,
          ),
          YBox(15.h),
          AppTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            controller: emailController,
          ),
          YBox(15.h),
          AppTextField(
            labelText: 'Password',
            hintText: 'Enter your password',
            controller: passwordController,
            isPassword: true,
          ),
          YBox(30.h),
          AppButton(
            title: 'Sign Up',
            onTap: () async {
              final success = await ref.read(authProvider.notifier).signUp(
                    username: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
              if (success) {
                AppNavigator.replaceAllNamed(HomeRoutes.home);
              } else {
                AppSnackBar.showError(
                  message: ref.read(authProvider).errorMessage,
                );
              }
            },
          ),
          YBox(10.h),
          Text.rich(
            TextSpan(
              text: 'Already have an account? ',
              children: [
                TextSpan(
                  text: 'Log in',
                  style: TextStyle(color: theme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      AppNavigator.replaceNamed(AuthRoutes.login);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
