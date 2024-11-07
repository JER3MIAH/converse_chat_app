import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/widgets/chat_tile.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../chat/chat_screen.dart';

class AllUsersScreen extends HookConsumerWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final users = ref.watch(chatProvider).users;
    final searchController = useTextEditingController();
    final filteredUsers = useState<List<User>>(users);

    useEffect(() {
      ref.read(chatProvider.notifier).getAllUsers();
      return null;
    }, const []);

    void filterUsers(String query) {
      filteredUsers.value = users.where((user) {
        final usernameLower = user.username.toLowerCase();
        final emailLower = user.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return usernameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();
    }

    useEffect(() {
      searchController.addListener(() {
        filterUsers(searchController.text);
      });
      return () => searchController.removeListener(() {
            filterUsers(searchController.text);
          });
    }, [users]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: AppInkWell(
            onTap: () {
              AppNavigator.popRoute();
            },
            child: AppBackButton(),
          ),
        ),
        title: MiniTextField(
          isUnderlined: true,
          hintText: 'Search a user',
          controller: searchController,
          onChanged: filterUsers,
        ),
      ),
      body: Column(
        children: List.generate(
          filteredUsers.value.length,
          (index) {
            final user = filteredUsers.value[index];
            return ChatTile(
              title: user.username,
              subtitle: user.email,
              avatar: user.avatar,
              time: '',
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
    );
  }
}
