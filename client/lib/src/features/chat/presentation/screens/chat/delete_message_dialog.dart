import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteMessageDialog extends HookConsumerWidget {
  final int messages;
  final String title;
  const DeleteMessageDialog({
    super.key,
    required this.messages,
    required this.title,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final selected = useState<bool>(false);

    void sendRequest(Future<bool> callback) async {
      final success = await callback;
      if (!success) {
        AppSnackBar.showError(message: ref.read(chatProvider).errorMessage);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            messages > 1 ? 'Delete $messages messages' : 'Delete message',
            color: theme.onSurface,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          YBox(5.h),
          AppText(
            'Are you sure you delete ${messages > 1 ? 'these' : 'this'} message${messages > 1 ? 's' : ''}?',
            color: theme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          YBox(10.h),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: selected.value,
            title: AppText(
              'Also delete for $title',
              color: theme.onSurface,
              fontSize: 14.sp,
              // fontWeight: FontWeight.w600,
            ),
            onChanged: (_) => selected.value = !selected.value,
          ),
          YBox(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => AppNavigator.popDialog(),
                child: AppText(
                  'Cancel',
                  color: theme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              XBox(20.w),
              TextButton(
                onPressed: () {
                  sendRequest(
                      ref.read(chatProvider.notifier).deleteSelectedMessages(
                            deleteForEveryone: selected.value,
                          ));
                  AppNavigator.popDialog();
                },
                child: AppText(
                  'Delete',
                  color: appColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
