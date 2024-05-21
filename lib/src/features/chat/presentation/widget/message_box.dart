import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:converse/src/features/chat/data/models/message.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageBox extends ConsumerWidget {
  final bool isCurrentUser;
  final ChatMessage chat;
  const MessageBox({
    super.key,
    required this.isCurrentUser,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final themeProv = ref.watch(themeProvider);

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        chat.messageType == kTextType
            ? Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .8,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 5.h),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? theme.primaryContainer
                        : themeProv.isDarkMode
                            ? theme.primary
                            : theme.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text.rich(
                    TextSpan(
                        text: chat.message,
                        style: TextStyle(
                          color: !isCurrentUser && !themeProv.isDarkMode
                              ? null
                              : appColors.white,
                        ),
                        children: [
                          // TextSpan(
                          //   text:
                          //       ' ${DateFormat.jm().format(chat.timeStamp.toDate())}',
                          //   style: TextStyle(
                          //     color: appColors.coolGrey,
                          //     fontSize: 10.sp,
                          //   ),
                          // ),
                        ]),
                  ),
                ),
              )
            : OpenContainer(
                closedElevation: 0,
                openElevation: 0,
                openColor: appColors.black,
                closedColor: theme.onBackground,
                closedBuilder: (context, action) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w)
                        .copyWith(top: 5.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: 150.h,
                        width: 200.w,
                        imageUrl: chat.message,
                        fit: BoxFit.fitWidth,
                        placeholder: (_, __) => ShimmerWidget(
                          child: Container(
                            decoration: BoxDecoration(
                              color: appColors.coolGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 150.h,
                            width: 200.w,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                openBuilder: (context, action) {
                  return _buildViewImage(
                    onSave: () async {
                      final isSuccessful = await ref
                          .read(chatProvider.notifier)
                          .saveImage(chat.message);
                      if (isSuccessful) {
                        AppSnackBar.simpleSnackbar('Photo saved to gallery');
                      } else {
                        AppSnackBar.showSnackbar(
                            message: 'Failed to save photo');
                      }
                    },
                  );
                },
              )
        //DateFormat.jm().format(chat.timeStamp.toDate()),
        //TODO: use
      ],
    );
  }

  Widget _buildViewImage({VoidCallback? onSave, VoidCallback? onDelete}) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          isCurrentUser ? 'You' : chat.sender.username,
          style: TextStyle(color: appColors.white),
        ),
        leading: BackButton(
          color: appColors.white,
        ),
        actions: [
          PopupMenuButton(
            color: Colors.black.withOpacity(.7),
            iconColor: appColors.white,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: onSave,
                  child: ListTile(
                    leading: Icon(
                      Icons.download,
                      color: appColors.white,
                    ),
                    title: Text(
                      'Save to Gallery',
                      style: TextStyle(
                        color: appColors.white,
                      ),
                    ),
                    // onTap: onSave,
                  ),
                ),
                PopupMenuItem(
                  onTap: onDelete,
                  child: ListTile(
                    leading: SvgAsset(
                      assetName: trashIcon,
                      color: appColors.white,
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        color: appColors.white,
                      ),
                    ),
                    // onTap: onDelete,
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: chat.message,
            fit: BoxFit.fitWidth,
            placeholder: (_, __) => ShimmerWidget(
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.coolGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150.h,
                width: 200.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
