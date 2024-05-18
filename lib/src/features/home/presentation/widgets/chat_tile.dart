import 'package:converse/src/features/chat/logic/providers/chat_service_provider.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTile extends ConsumerWidget {
  final VoidCallback onTap;
  final String username;
  final String chatId;

  const ChatTile({
    super.key,
    required this.onTap,
    required this.username,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final themeProv = ref.watch(themeProvider);
    final userProv = ref.watch(userProvider);
    final subStyle = TextStyle(
      color: appColors.coolGrey,
      fontWeight: FontWeight.w500,
    );

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
            title: Text(
              username,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.outline,
              ),
            ),
            subtitle: StreamBuilder(
                stream:
                    ref.read(chatServiceProvider).latestMessageStream(chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  final latestMessage = snapshot.data;

                  if (latestMessage != null) {
                    final bool sentByUser =
                        latestMessage.sender.email == userProv.user.email;
                    if (latestMessage.messageType == kTextType) {
                      return Text(
                        '${sentByUser ? 'you: ' : '$username: '}${latestMessage.message}',
                        style: subStyle,
                      );
                    } else {
                      return Text.rich(
                        TextSpan(
                          text: sentByUser ? 'you: ' : '$username: ',
                          style: subStyle,
                          children: [
                            TextSpan(
                              text: 'Photo',
                              style: subStyle.copyWith(
                                  color: theme.primaryContainer),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Text('. . .', style: subStyle);
                  }
                }),
          ),
        ),
      ),
    );
  }
}
