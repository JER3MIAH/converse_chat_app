import 'package:converse/src/features/chat/logic/providers/chat_service_provider.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/home/presentation/widgets/widgets.dart';
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ChatTile extends ConsumerWidget {
  final VoidCallback? onTap;
  final String? username;
  final String? chatId;
  final bool isLoading;

  const ChatTile({
    super.key,
    this.onTap,
    this.username,
    this.chatId,
    this.isLoading = false,
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

    return isLoading
        ? const LoadingChat()
        : InkWell(
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
                leading: UserAvatar(username: username!),
                title: Text(
                  username!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.outline,
                  ),
                ),
                subtitle: StreamBuilder(
                    stream: ref
                        .read(chatServiceProvider)
                        .latestMessageStream(chatId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadinWidget(themeProv);
                      }

                      final latestMessage = snapshot.data;

                      if (latestMessage != null) {
                        final bool sentByUser =
                            latestMessage.sender.email == userProv.user.email;
                        if (latestMessage.messageType == kTextType) {
                          return Text(
                            '${sentByUser ? 'you: ' : '$username: '}${latestMessage.message}',
                            style: subStyle,
                            maxLines: 1,
                          );
                        } else {
                          return Text.rich(
                            maxLines: 1,
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
          );
  }

  Center _buildLoadinWidget(ThemeProvider themeProv) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: themeProv.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor:
            themeProv.isDarkMode ? Colors.grey[500]! : Colors.grey[100]!,
        child: Container(
          width: 230.w,
          height: 12.h,
          margin: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
