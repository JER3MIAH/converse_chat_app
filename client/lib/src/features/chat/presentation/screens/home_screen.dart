import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/core/network/socket_service.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat_screen.dart';
import 'package:converse/src/features/chat/presentation/widgets/chat_tile.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final chatController = ref.watch(chatProvider);
    useEffect(() {
      sl<AuthService>().saveFcmToken();
      sl<SocketService>().initializeSocket();
      ref.read(chatProvider.notifier).getChats();
      ref.read(chatProvider.notifier).listenForNewMessage();
      return null;
    }, const []);

    return Scaffold(
      body: AppColumn(
        children: [
          AppText('Chats'),
          YBox(20.h),
          if (chatController.chats.isEmpty) AppText('No chats available'),
          Expanded(
            child: ListView.builder(
              itemCount: chatController.chats.length,
              itemBuilder: (context, index) {
                final chat = chatController.chats[index];
                final title = chat.participants
                    .firstWhere(
                      (user) => user.id != authManager.currentUser!.id,
                    )
                    .email;
                final sentByYou =
                    chat.lastMessage?.senderId == authManager.currentUser!.id;
                return ChatTile(
                  title: title,
                  subtitle: chat.lastMessage != null
                      ? ('${sentByYou ? 'You: ' : ''}${chat.lastMessage!.text}')
                      : '',
                  time: chat.lastMessage != null
                      ? formatDate(chat.lastMessage!.createdAt,
                          format: 'hh:mm a')
                      : '',
                  unreadMessages: 0,
                  onTap: () {
                    AppNavigator.pushNamed(
                      ChatRoutes.chat,
                      args: ChatScreenArgs(
                        title: title,
                        chat: chat,
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.pushNamed(HomeRoutes.users);
        },
      ),
    );
  }
}
