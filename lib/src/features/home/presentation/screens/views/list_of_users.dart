import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/logic/providers/chat_service_provider.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/widgets.dart';

class ListOfUsersView extends ConsumerWidget {
  final ValueNotifier<String> searchQuery;
  const ListOfUsersView({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, ref) {
    final userProv = ref.watch(userProvider);

    return StreamBuilder(
      stream: ref.watch(chatServiceProvider).getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final users = snapshot.data ?? [];
        final filteredUsers =
            users.where((user) => user.email != userProv.user.email).toList();
        final searchFilteredUsers = filteredUsers
            .where((user) => user.username
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: searchFilteredUsers.length,
          itemBuilder: (context, index) {
            final user = searchFilteredUsers[index];
            if (user.email != userProv.user.email) {
              return UserTile(
                onTap: () async {
                  final chatEsists =
                      await ref.read(chatProvider.notifier).checkChatExists(
                            generateChatId(id1: userProv.user.id, id2: user.id),
                          );
                  if (!chatEsists) {
                    await ref
                        .read(chatProvider.notifier)
                        .createNewChat(userProv.user.id, user.id);
                  }

                  AppNavigator.popRoute();
                  AppNavigator.pushNamed(
                    ChatRoutes.chat,
                    args: user,
                  );
                },
                username: user.username,
                email: user.email,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
