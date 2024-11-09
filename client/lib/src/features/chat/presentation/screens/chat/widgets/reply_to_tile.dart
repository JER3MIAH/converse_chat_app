import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyToTile extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClear;
  const ReplyToTile({
    super.key,
    required this.title,
    required this.message,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ListTile(
      minTileHeight: 40.h,
      shape: Border(
        top: BorderSide(width: 0.5, color: appColors.coolGrey),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
      leading: Icon(
        Icons.reply,
        color: theme.primary,
      ),
      title: AppText(
        'Reply to $title',
        color: theme.primary,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: AppText(
        message,
        color: appColors.coolGrey,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onClear,
        icon: Icon(
          Icons.clear,
          color: appColors.coolGrey,
        ),
      ),
    );
  }
}
