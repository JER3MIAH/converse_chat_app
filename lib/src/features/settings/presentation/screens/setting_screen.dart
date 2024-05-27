import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/widgets.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(theme),
          const SettingHeaderText(text: 'GENERAL'),
          SettingsTile(
            hasSvg: false,
            hasTopBorder: true,
            iconWidget: CupertinoIcons.person,
            leadingIcon: globeIcon,
            title: 'Account',
            onTap: () {},
          ),
          SettingsTile(
            hasSvg: false,
            iconWidget: Icons.notifications_outlined,
            leadingIcon: notitficationIcon,
            title: 'Notifications',
            onTap: () {},
          ),
          SettingsTile(
            leadingIcon: logoutIcon,
            title: 'Logout',
            onTap: () async {
              final isSuccessful =
                  await ref.read(userProvider.notifier).logout();
              if (isSuccessful) {
                AppNavigator.replaceNamed(AuthRoutes.login);
              } else {
                AppSnackBar.showSnackbar(message: 'Failed to log out');
              }
            },
          ),
          SettingsTile(
            leadingIcon: trashIcon,
            title: 'Delete account',
            onTap: () {
              AppDialog.dialog(
                DeleteDialog(
                  message: 'Are you sure you want to delete your account?',
                  onTap: () async {
                    AppNavigator.popDialog();
                    final isSuccessful =
                        await ref.read(userProvider.notifier).deleteUser();
                    if (isSuccessful) {
                      AppNavigator.replaceNamed(AuthRoutes.signUp);
                    } else {
                      AppSnackBar.showSnackbar(
                        message: 'An error occured, could not delete account',
                      );
                    }
                  },
                ),
                bgColor: theme.background,
              );
            },
          ),
          const SettingHeaderText(text: 'FEEDBACK'),
          SettingsTile(
            hasSvg: false,
            hasTopBorder: true,
            iconWidget: Icons.error_outline,
            leadingIcon: globeIcon,
            title: 'Report a bug',
            onTap: () {},
          ),
          SettingsTile(
            hasSvg: false,
            iconWidget: Icons.feedback_outlined,
            leadingIcon: globeIcon,
            title: 'Send feedback',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(ColorScheme theme) {
    return Container(
      height: 150.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(
            color: appColors.white,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          YBox(30.h),
          BackButton(
            color: appColors.white,
          ),
          YBox(10.h),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
