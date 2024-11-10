import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final currentUser = authManager.currentUser!;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: ProfileImageContainer(
              height: 50.h,
              icon: currentUser.avatar,
            ),
            accountName: AppText(
              currentUser.username,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: theme.onPrimary,
            ),
            accountEmail: AppText(
              currentUser.email,
              color: theme.onPrimary,
            ),
            otherAccountsPictures: [
              // AppInkWell(
              //   onTap: () {},
              //   child: SvgAsset(
              //     path: editIcon,
              //     color: theme.onPrimary,
              //   ),
              // ),
              GestureDetector(
                onTap: ref.read(themeProvider.notifier).toggleTheme,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SvgAsset(
                    path: isDarkMode ? sunIcon : moonIcon,
                    color: appColors.white,
                  ),
                ),
              ),
            ],
            decoration: BoxDecoration(
              color: theme.primary,
            ),
          ),
          _buildDrawerTile(
            title: 'My Profile',
            icon: Icons.person_2_outlined,
            onTap: () {},
          ),
          _buildDrawerTile(
            title: 'Archived Chats',
            icon: Icons.archive,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              AppNavigator.pushNamed(ChatRoutes.archivedChats);
            },
          ),
          _buildDrawerTile(
            title: 'Settings',
            icon: settingIcon,
            onTap: () {},
          ),
          Spacer(),
          _buildDrawerTile(
            title: 'Logout',
            icon: logoutIcon,
            onTap: () {
              authManager.logout();
              AppNavigator.replaceNamed(AuthRoutes.login);
            },
          ),
          YBox(20.h),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required String title,
    required dynamic icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: AppText(title),
      leading: icon is IconData
          ? Icon(
              icon,
              color: appColors.coolGrey,
            )
          : SvgAsset(
              path: icon,
              color: appColors.coolGrey,
            ),
    );
  }
}
