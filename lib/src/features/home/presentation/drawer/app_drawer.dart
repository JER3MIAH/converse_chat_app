import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/home/presentation/widgets/drawer_tile.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final userProv = ref.watch(userProvider);
    final themeProv = ref.watch(themeProvider);

    return Drawer(
      backgroundColor: theme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: theme.primary,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YBox(30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: theme.primaryContainer,
                      child: Icon(
                        CupertinoIcons.person,
                        color: theme.background,
                      ),
                    ),
                    AppInkWell(
                      onTap: () {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                      child: SvgAsset(
                        assetName: themeProv.isDarkMode ? sunIcon : moonIcon,
                        color: appColors.white,
                      ),
                    ),
                  ],
                ),
                YBox(10.h),
                Text(
                  userProv.user.username,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: appColors.white,
                  ),
                ),
                YBox(10.h),
              ],
            ),
          ),
          YBox(20.h),
          AppDrawerTile(
            title: 'World chat',
            icon: globeIcon,
            onTap: () {
              // AppNavigator.popRoute();
              AppNavigator.pushNamed(ChatRoutes.worldChat);
            },
          ),
          AppDrawerTile(
            title: 'Settings',
            icon: settingIcon,
            onTap: () {},
          ),
          const Spacer(),
          AppDrawerTile(
            title: 'Logout',
            icon: logoutIcon,
            onTap: () async {
              await ref.read(userProvider.notifier).logout();
              AppNavigator.replaceNamed(AuthRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
