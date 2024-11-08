import 'package:converse/src/features/auth/logic/providers/auth_provider.dart';
import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
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
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context).colorScheme;
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final selectedAvater = useState<String>('default');

    return Scaffold(
      body: Form(
        key: formKey,
        child: AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Create an account',
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
            YBox(5.h),
            AppText(
              'Please create an account to continue',
              color: appColors.coolGrey,
            ),
            YBox(40.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  AppDialog.dialog(
                    bgColor: theme.surface,
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: SizedBox(
                        height: 300.h,
                        child: GridView.builder(
                          itemCount: AVATARS.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final avatar = AVATARS[index];
                            return Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedAvater.value == avatar
                                    ? theme.primary
                                    : null,
                              ),
                              child: ProfileImageContainer(
                                onTap: () {
                                  selectedAvater.value = avatar;
                                  AppNavigator.popDialog();
                                },
                                icon: avatar,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileImageContainer(
                      height: 80.h,
                      icon: selectedAvater.value,
                      showFullTitle: true,
                    ),
                    YBox(5.h),
                    AppText('Pick your Avatar'),
                  ],
                ),
              ),
            ),
            YBox(15.h),
            AppTextField(
              labelText: 'Username',
              hintText: 'Enter your username',
              controller: nameController,
              keyboardType: TextInputType.name,
              validator: Validator.nonEmptyField,
            ),
            YBox(15.h),
            AppTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.emailValidator,
            ),
            YBox(15.h),
            AppTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: passwordController,
              isPassword: true,
              validator: Validator.password,
            ),
            YBox(30.h),
            AppButton(
              title: 'Sign Up',
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                final success = await ref.read(authProvider.notifier).signUp(
                      username: nameController.text.trim(),
                      email: emailController.text.trim(),
                      avatar: selectedAvater.value,
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
                  text: 'Already have an account? ',
                  style: TextStyle(
                    color: theme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppNavigator.replaceNamed(AuthRoutes.login);
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
