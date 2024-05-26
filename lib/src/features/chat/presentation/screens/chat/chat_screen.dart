import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/views/chat_menu_button.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/views/message_list.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/views/user_input.dart';
import 'package:converse/src/features/home/presentation/widgets/user_avatar.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// class ChatScreenArgs {
//   final UserModel recipient;
//   final UserModel currentUser;
//   const ChatScreenArgs({
//     required this.recipient,
//     required this.currentUser,
//   });
// }

class ChatScreen extends HookConsumerWidget {
  final UserModel recipient;
  const ChatScreen({super.key, required this.recipient});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          ref.read(chatProvider.notifier).scrollDown();
        }
      });
      ref.read(chatProvider.notifier).scrollDown();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        leading: BackButton(
          color: appColors.white,
        ),
        actions: const [
          ChatMenuButton(),
        ],
        title: Row(
          children: [
            UserAvatar(
              username: recipient.username,
              color: theme.primaryContainer,
              radius: 20.r,
            ),
            XBox(10.w),
            Text(
              recipient.username,
              style: TextStyle(
                color: appColors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: theme.onBackground,
        child: Column(
          children: [
            Expanded(
              child: MessageListView(
                receiver: recipient,
              ),
            ),
            UserInputView(
              receiver: recipient,
              focusNode: focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
