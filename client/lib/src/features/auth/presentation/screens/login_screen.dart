import 'package:converse/src/features/auth/logic/providers/auth_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context).colorScheme;
    final authController = ref.watch(authProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Login',
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
            YBox(5.h),
            AppText(
              'Please Login to continue',
              color: appColors.coolGrey,
            ),
            YBox(40.h),
            AppTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.nonEmptyField,
            ),
            YBox(15.h),
            AppTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: passwordController,
              isPassword: true,
              validator: Validator.nonEmptyField,
            ),
            YBox(30.h),
            AppButton(
              title: 'Login',
              isLoading: authController.isLoading,
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                final success = await ref.read(authProvider.notifier).login(
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
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Do not have an account? ',
                  style: TextStyle(
                    color: theme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppNavigator.replaceNamed(AuthRoutes.signUp);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
