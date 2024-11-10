import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/widgets/reply_to_tile.dart';
import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'delete_message_dialog.dart';
import 'widgets/message_box.dart';

class ChatScreenArgs {
  final String title;
  final Chat chat;
  ChatScreenArgs({
    required this.title,
    required this.chat,
  });
}

class ChatScreen extends HookConsumerWidget {
  final ChatScreenArgs args;
  const ChatScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final scrollController = useScrollController();
    final controller = useTextEditingController();
    final vsync = useSingleTickerProvider();
    final slidableController = useMemoized(() => SlidableController(vsync));
    final messages = ref.watch(chatProvider).messages;
    final selectedMessages = ref.watch(chatProvider).selectedMessages;
    final taggedMessage = useState<ChatMessage?>(null);

    void scrollToBottom() {
      if (scrollController.hasClients) {
        Future.delayed(
          Duration(milliseconds: 500),
          () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
        );
      }
    }

    void init() async {
      //* create chat if it doesn't exist, then get messages
      await ref.read(chatProvider.notifier).getMessages(chat: args.chat);

      //* Listen for messages in this room
      ref.read(chatProvider.notifier).joinRoom(args.chat.id);
      ref
          .read(chatProvider.notifier)
          .listenForNewMessage(callback: scrollToBottom);
      scrollToBottom();
    }

    useEffect(() {
      init();
      return null;
    }, const []);

    void sendMessage() {
      final receiverId = args.chat.participants
          .firstWhere((user) => user.id != authManager.currentUser!.id,
              orElse: () => User.empty())
          .id;
      ref.read(chatProvider.notifier).sendMessage(
            ChatMessage(
              chatId: args.chat.id,
              text: controller.text.trim(),
              repliedTo: taggedMessage.value?.id,
              senderId: authManager.currentUser!.id,
              receiverId: receiverId,
              readBy: [authManager.currentUser!.id],
            ),
          );
      taggedMessage.value = null;
      controller.clear();
      scrollToBottom();
    }

    final bottom = PreferredSize(
      preferredSize: Size.fromHeight(.5),
      child: Container(
        color: theme.secondary,
        height: 1,
        margin: EdgeInsets.only(bottom: 5.h),
      ),
    );

    return PopScope(
      canPop: selectedMessages.isEmpty,
      onPopInvokedWithResult: (didPop, __) {
        ref.read(chatProvider.notifier).clearSelectedMessages();
        if (didPop) ref.read(chatProvider.notifier).setMessages([]);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: selectedMessages.isEmpty
            ? AppBar(
                surfaceTintColor: Colors.transparent,
                centerTitle: false,
                leading: AppBackButton(
                  onTap: () {
                    AppNavigator.popRoute();
                    ref.read(chatProvider.notifier).setMessages([]);
                  },
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileImageContainer(
                      height: 30.h,
                      icon: args.chat.participants
                          .firstWhere(
                              (user) => user.id != authManager.currentUser!.id,
                              orElse: () => User.empty())
                          .avatar,
                      padding: EdgeInsets.all(8.w),
                    ),
                    XBox(5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              args.title,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        // if (online)
                        //   AppText(
                        //     'online',
                        //     color: appColors.success,
                        //     fontSize: 12.sp,
                        //   ),
                      ],
                    ),
                  ],
                ),
                bottom: bottom,
              )
            : AppBar(
                centerTitle: false,
                title: AppText(
                  '${selectedMessages.length}',
                  fontSize: 18.sp,
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.onSurface,
                  ),
                  onPressed: () =>
                      ref.read(chatProvider.notifier).clearSelectedMessages(),
                ),
                bottom: bottom,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.onSurface,
                    ),
                    onPressed: () {
                      AppDialog.dialog(
                        DeleteMessageDialog(
                          messages: selectedMessages.length,
                          title: args.chat.participants
                              .firstWhere(
                                  (user) =>
                                      user.id != authManager.currentUser!.id,
                                  orElse: () => User.empty())
                              .username,
                        ),
                      );
                    },
                  ),
                ],
              ),
        body: messages.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 70.h),
                  child: LottieAsset(
                    assetPath: 'assets/jsons/noMessages.json',
                  ),
                ),
              )
            : ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  return GestureDetector(
                    onTap: () {
                      if (selectedMessages.isNotEmpty) {
                        ref.read(chatProvider.notifier).selectMessage(message);
                      }
                    },
                    onLongPress: () =>
                        ref.read(chatProvider.notifier).selectMessage(message),
                    child: Slidable(
                      key: ValueKey(index),
                      startActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const StretchMotion(),
                        dragDismissible: false,
                        closeThreshold: .2,
                        dismissible: DismissiblePane(
                          onDismissed: () {
                            taggedMessage.value = message;
                            slidableController.close();
                          },
                        ),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              taggedMessage.value = message;
                              slidableController.close();
                            },
                            icon: Icons.reply,
                            backgroundColor: Colors.transparent,
                            foregroundColor: theme.primary,
                          ),
                        ],
                      ),
                      child: ChatBox(
                        sender: args.title,
                        time: formatDate(message.createdAt,
                            format: 'MMM dd hh:mm a'),
                        chatText: message.text,
                        isTagged: message.repliedTo != null,
                        isSelected: selectedMessages.contains(message),
                        sentByYou:
                            message.senderId == authManager.currentUser!.id,
                        replyTitle:
                            message.senderId == authManager.currentUser!.id
                                ? authManager.currentUser!.username
                                : args.title,
                        replySubtitle: messages
                            .firstWhere(
                              (element) => element.id == message.repliedTo,
                              orElse: () => ChatMessage.empty(),
                            )
                            .text,
                      ),
                    ),
                  );
                },
              ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (taggedMessage.value != null)
              ReplyToTile(
                title:
                    taggedMessage.value!.senderId == authManager.currentUser!.id
                        ? authManager.currentUser!.username
                        : args.title,
                message: taggedMessage.value!.text,
                onClear: () {
                  taggedMessage.value = null;
                },
              ),
            Container(
              height: 70.h,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: appColors.coolGrey, width: .5),
                ),
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: MiniTextField(
                      height: 44.h,
                      controller: controller,
                      keyboardType: TextInputType.text,
                      hintText: 'Message',
                      borderRadius: 8,
                      onTap: scrollToBottom,
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  XBox(10.w),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.primary,
                      ),
                      child: Icon(
                        Icons.send_outlined,
                        color: appColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
