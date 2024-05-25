import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String username;
  const UserAvatar({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 25.r,
      backgroundColor: theme.primary,
      child: Text(
        username.substring(0, 1),
        style: TextStyle(
          color: appColors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
