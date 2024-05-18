import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class AppFab extends StatelessWidget {
  const AppFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: theme.primary,
      onPressed: () {
        AppNavigator.pushNamed(HomeRoutes.newMessage);
      },
      child: SvgAsset(
        assetName: editIcon,
        color: appColors.white,
      ),
    );
  }
}
