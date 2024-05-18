import 'package:converse/src/features/chat/logic/providers/chat_service_provider.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/widgets.dart';

class ListOfChatsView extends ConsumerWidget {
  const ListOfChatsView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userProv = ref.watch(userProvider);
    final theme = Theme.of(context).colorScheme;
    final style = GoogleFonts.merriweather(
      color: theme.outline,
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    );

    return StreamBuilder(
      stream: ref.watch(chatServiceProvider).getChattedUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final chats = snapshot.data ?? [];
        final filteredUsers =
            chats.where((user) => user.email != userProv.user.email).toList();
        if (filteredUsers.isEmpty) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/jsons/noChats.json'),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'No chats yet...\nClick ',
                  style: style,
                  children: [
                    TextSpan(
                      text: 'here',
                      style: style.copyWith(
                        color: theme.primaryContainer,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.primaryContainer,
                      ),
                    ),
                    TextSpan(
                      text: ' to start a chat',
                      style: style,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              if (user.email != userProv.user.email) {
                return ChatTile(
                  onTap: () {
                    AppNavigator.pushNamed(
                      ChatRoutes.chat,
                      args: user,
                    );
                  },
                  username: user.username,
                  chatId: generateChatId(id1: userProv.user.id, id2: user.id),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
