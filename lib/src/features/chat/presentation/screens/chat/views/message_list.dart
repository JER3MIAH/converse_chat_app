import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/widget/message_box.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class MessageListView extends ConsumerWidget {
  final UserModel receiver;
  final ScrollController scrollController;
  const MessageListView({
    super.key,
    required this.receiver,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final userProv = ref.watch(userProvider);

    return StreamBuilder(
      stream: ref.read(chatProvider.notifier).getMessages(
            receiver: receiver,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/jsons/noMessages.json'),
                  Text(
                    'No messages here yet...',
                    style: TextStyle(
                      color: theme.outline,
                      fontSize: 18.sp,
                    ),
                  ),
                  YBox(80.h),
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
            controller: scrollController,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              bool isCurrentUser = chat.sender.id == userProv.user.id;

              return MessageBox(
                isCurrentUser: isCurrentUser,
                chat: chat,
              );
            },
          );
        }
      },
    );
  }
}
