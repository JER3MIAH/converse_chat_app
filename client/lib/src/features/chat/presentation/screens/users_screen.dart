import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chat_screen.dart';

class AllUsersScreen extends HookConsumerWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final users = ref.watch(chatProvider).users;
    useEffect(() {
      ref.read(chatProvider.notifier).getAllUsers();
      return null;
    }, const []);

    return Scaffold(
      body: AppColumn(
        children: [
          AppText('All Users'),
          YBox(20.h),
          Column(
            children: List.generate(
              users.length,
              (index) {
                final user = users[index];
                return ListTile(
                  title: AppText(user.email),
                  onTap: () {
                    AppNavigator.pushNamed(
                      ChatRoutes.chat,
                      args: ChatScreenArgs(
                        title: user.email,
                        chat: Chat(
                          id: generateChatId(
                            id1: authManager.currentUser!.id,
                            id2: user.id,
                          ),
                          participants: [
                            authManager.currentUser!,
                            user,
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
