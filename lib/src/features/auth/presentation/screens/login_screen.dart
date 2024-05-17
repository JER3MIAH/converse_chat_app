import 'package:converse/src/features/auth/logic/providers/login_provider.dart';
import 'package:converse/src/features/auth/presentation/widgets/lined_up_text.dart';
import 'package:converse/src/features/auth/presentation/widgets/start_aligned_text.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final loginProvidr = ref.watch(loginProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        onChanged: () {
          ref.read(loginProvider).onInputChanged(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
        },
        child: AppColumn(
          shouldScroll: true,
          margin: EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 55.h),
          children: [
            const BackAndAppIcon(),
            YBox(15.h),
            StartAlignedText(
              text: 'Log in',
              style: TextStyle(
                height: 2,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: theme.outline,
              ),
            ),
            StartAlignedText(
              text: 'Provide your information below to get started',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF476072),
              ),
            ),
            YBox(30.h),
            AppTextField(
              controller: emailController,
              labelText: 'Email address',
              keyBoardType: TextInputType.emailAddress,
              validator: (value) {
                return Validator.nonEmptyField(value);
              },
            ),
            YBox(45.h),
            AppTextField(
              controller: passwordController,
              labelText: 'Password',
              isPasswordField: true,
              keyBoardType: TextInputType.visiblePassword,
              validator: (value) {
                return Validator.nonEmptyField(value);
              },
            ),
            YBox(25.h),
            LinedUpText(
              leadingText: 'Are you new here? ',
              trailingText: 'Register',
              isUndelined: true,
              onTapTrailing: () {
                AppNavigator.replaceNamed(AuthRoutes.signUp);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: AppColumn(
        height: 120.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        children: [
          AppButton(
            title: 'Log in',
            isLoading: loginProvidr.isLoading,
            onTap: () async {
              if (formKey.currentState!.validate()) {
                final isSuccessful =
                    await ref.read(loginProvider.notifier).login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                if (isSuccessful) {
                  ref.read(userProvider.notifier).retrieveUserInfo();
                  AppNavigator.replaceAllNamed(HomeRoutes.home);
                } else {
                  AppSnackBar.showSnackbar(message: loginProvidr.errorMessage);
                }
              }
            },
            buttonColor: loginProvidr.buttonEnabled
                ? theme.primaryContainer
                : theme.primary,
          ),
          YBox(10.h),
          LinedUpText(
            leadingText: 'Forgot password? ',
            trailingText: 'Reset',
            onTapTrailing: () {
              emailController.clear();
              passwordController.clear();
              // AppNavigator.pushNamed(AuthRoutes.forgotPassword);
            },
          ),
        ],
      ),
    );
  }
}
