import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTile extends ConsumerWidget {
  final VoidCallback onTap;
  final String username, email;

  const UserTile({
    super.key,
    required this.onTap,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final themeProv = ref.watch(themeProvider);

    return BounceInAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: themeProv.isDarkMode
                    ? appColors.black.withOpacity(.4)
                    : appColors.grey.withOpacity(.1),
              ),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25.r,
              backgroundColor: theme.primary,
              child: Icon(
                CupertinoIcons.person,
                color: appColors.white,
              ),
            ),
            title: Text(username),
            subtitle: Text(
              email,
              style: TextStyle(
                color: appColors.coolGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
