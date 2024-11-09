import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final messages = ref.watch(chatProvider).messages;

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
              senderId: authManager.currentUser!.id,
              receiverId: receiverId,
            ),
          );
      controller.clear();
      scrollToBottom();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, __) {
        if (didPop) ref.read(chatProvider.notifier).setMessages([]);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  AppNavigator.popRoute();
                  ref.read(chatProvider.notifier).setMessages([]);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBackButton(),
                    XBox(3.w),
                    Expanded(
                      child: ProfileImageContainer(
                        height: 30.h,
                        icon: args.chat.participants
                            .firstWhere(
                                (user) =>
                                    user.id != authManager.currentUser!.id,
                                orElse: () => User.empty())
                            .avatar,
                        padding: EdgeInsets.all(8.w),
                      ),
                    ),
                  ],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppText(
                          args.title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
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
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: messages.isEmpty
                ? [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 70.h),
                        child: LottieAsset(
                          assetPath: 'assets/jsons/noMessages.json',
                        ),
                      ),
                    ),
                  ]
                : List.generate(
                    messages.length,
                    (index) {
                      final message = messages[index];
                      return ChatBox(
                        sender: args.title,
                        time: formatDate(message.createdAt,
                            format: 'MMM dd hh:mm a'),
                        chatText: message.text,
                        sentByYou:
                            message.senderId == authManager.currentUser!.id,
                      );
                    },
                  ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70.h,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: appColors.black.withOpacity(.1)),
            ),
          ),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
      ),
    );
  }
}
