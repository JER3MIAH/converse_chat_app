import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMenuButton extends HookConsumerWidget {
  const ChatMenuButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final themeProv = ref.watch(themeProvider);

    return PopupMenuButton(
      color: themeProv.isDarkMode ? theme.primary : appColors.white,
      iconColor: appColors.white,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: _buildMenuTile(
              title: 'Change wallpaper',
              icon: sunIcon,
              onTap: () {},
            ),
          ),
          PopupMenuItem(
            child: _buildMenuTile(
              title: 'Clear history',
              icon: sunIcon,
              onTap: () {},
            ),
          ),
        ];
      },
    );
  }

  Widget _buildMenuTile({
    VoidCallback? onTap,
    required String icon,
    required String title,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Padding(
        padding: EdgeInsets.zero,
        child: SvgAsset(assetName: icon),
      ),
      title: Text(title),
    );
  }
}
