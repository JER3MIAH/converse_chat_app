import 'package:converse/src/features/auth/logic/providers/signup_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final userNameController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final signupProvider = ref.watch(signUpProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        onChanged: () {
          signupProvider.onInputChanged(
            userName: userNameController.text.trim(),
            email: emailController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim(),
            password: passwordController.text.trim(),
          );
        },
        child: SafeArea(
          child: AppColumn(
            margin: EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 25.h),
            shouldScroll: true,
            children: [
              const BackAndAppIcon(),
              YBox(30.h),
              StartAlignedText(
                text: 'Sign Up',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              StartAlignedText(
                text: 'Provide your information below to get started',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF476072),
                ),
              ),
              YBox(20.h),
              AppTextField(
                controller: userNameController,
                labelText: 'Username',
                keyBoardType: TextInputType.name,
                validator: (value) {
                  return Validator.nonEmptyField(value);
                },
              ),
              YBox(35.h),
              AppTextField(
                controller: emailController,
                labelText: 'Email address',
                keyBoardType: TextInputType.emailAddress,
                validator: (value) {
                  return Validator.emailValidator(value);
                },
              ),
              YBox(35.h),
              AppTextField(
                controller: passwordController,
                labelText: 'Password',
                keyBoardType: TextInputType.visiblePassword,
                isPasswordField: true,
                validator: (value) {
                  return Validator.password(value);
                },
              ),
              YBox(35.h),
              AppTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm password',
                keyBoardType: TextInputType.visiblePassword,
                isPasswordField: true,
                validator: (value) {
                  return Validator.confrimPassword(
                      value, passwordController.text);
                },
              ),
              YBox(45.h),
              AppButton(
                title: 'Sign up',
                isLoading: signupProvider.isLoading,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    final isSuccessful =
                        await ref.read(signUpProvider.notifier).signUp(
                              username: userNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                    if (isSuccessful) {
                      AppNavigator.replaceAllNamed(HomeRoutes.home);
                    } else {
                      AppSnackBar.showSnackbar(
                          message: signupProvider.errorMessage);
                    }
                  }
                },
                buttonColor: signupProvider.buttonEnabled
                    ? theme.primaryContainer
                    : theme.primary,
              ),
              YBox(27.h),
              LinedUpText(
                leadingText: 'Already have an account? ',
                trailingText: 'Log in',
                isUndelined: true,
                onTapTrailing: () {
                  signupProvider.disposeValues();
                  AppNavigator.replaceNamed(AuthRoutes.login);
                },
              ),
              YBox(35.h),
            ],
          ),
        ),
      ),
    );
  }
}
