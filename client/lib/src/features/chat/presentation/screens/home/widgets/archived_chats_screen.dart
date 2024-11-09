import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/chat_screen.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/widgets/chat_tile.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArchivedChatsScreen extends HookConsumerWidget {
  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final archivedChats = ref.watch(chatProvider).archivedChats;
    final selectedChats = ref.watch(chatProvider).selectedChats;
    final searchController = useTextEditingController();
    final filteredChats = useState<List<Chat>>(archivedChats);
    final barStatus = useState<AppBarState>(AppBarState.REGULAR);

    void setBarStatus(AppBarState value) {
      searchController.clear();
      barStatus.value = value;
    }

    void filterChats(String query) {
      filteredChats.value = archivedChats.where((chat) {
        final user = chat.participants.firstWhere(
          (user) => user.id != authManager.currentUser!.id,
        );
        final usernameLower = user.username.toLowerCase();
        final searchLower = query.toLowerCase();
        return usernameLower.contains(searchLower);
      }).toList();
    }

    useEffect(() {
      ref.read(chatProvider.notifier).clearSelectedChats(updateState: false);
      searchController.addListener(() {
        filterChats(searchController.text);
      });
      return () => searchController.removeListener(() {
            filterChats(searchController.text);
          });
    }, [archivedChats]);

    void sendRequest(Future<bool> callback) async {
      final success = await callback;
      if (!success) {
        AppSnackBar.showError(message: ref.read(chatProvider).errorMessage);
      }
    }

    return PopScope(
      canPop: barStatus.value == AppBarState.REGULAR,
      onPopInvokedWithResult: (didPop, __) {
        setBarStatus(AppBarState.REGULAR);
        ref.read(chatProvider.notifier).clearSelectedChats();
      },
      child: Scaffold(
        appBar: barStatus.value == AppBarState.SEARCH
            ? AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.onSurface,
                  ),
                  onPressed: () {
                    setBarStatus(AppBarState.REGULAR);
                  },
                ),
                title: MiniTextField(
                  isUnderlined: true,
                  hintText: 'Search',
                  controller: searchController,
                  onChanged: filterChats,
                ),
              )
            : barStatus.value == AppBarState.SELECTION
                ? AppBar(
                    centerTitle: false,
                    title: AppText(
                      '${selectedChats.length}',
                      fontSize: 18.sp,
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: theme.onSurface,
                      ),
                      onPressed: () =>
                          ref.read(chatProvider.notifier).clearSelectedChats(),
                    ),
                    actions: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.onSurface,
                          ),
                          onPressed: () => sendRequest(ref
                              .read(chatProvider.notifier)
                              .deleteSelectedChats()),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.unarchive_outlined,
                            color: theme.onSurface,
                          ),
                          onPressed: () => sendRequest(ref
                              .read(chatProvider.notifier)
                              .archiveSelectedChats()),
                        ),
                      ])
                : AppBar(
                    leading: AppBackButton(),
                    centerTitle: false,
                    title: AppText(
                      'Archived Chats',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: IconButton(
                          onPressed: () => setBarStatus(AppBarState.SEARCH),
                          icon: SvgAsset(path: searchIcon),
                        ),
                      ),
                    ],
                  ),
        body: archivedChats.isEmpty
            ? Center(
                child: AppText(
                  archivedChats.isNotEmpty && filteredChats.value.isEmpty
                      ? 'No match found'
                      : 'No Archived Chats',
                  fontSize: 20.sp,
                ),
              )
            : ListView.builder(
                itemCount: barStatus.value == AppBarState.SEARCH
                    ? filteredChats.value.length
                    : archivedChats.length,
                itemBuilder: (context, index) {
                  final chat = (barStatus.value == AppBarState.SEARCH
                      ? filteredChats.value[index]
                      : archivedChats[index]);
                  final user = chat.participants.firstWhere(
                    (user) => user.id != authManager.currentUser!.id,
                  );
                  final title = user.username;
                  final sentByYou =
                      chat.lastMessage?.senderId == authManager.currentUser!.id;

                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      extentRatio: .2,
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(
                        dismissThreshold: 0.4,
                        onDismissed: () => sendRequest(
                            ref.read(chatProvider.notifier).archiveChat(chat)),
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (_) => sendRequest(ref
                              .read(chatProvider.notifier)
                              .archiveChat(chat)),
                          backgroundColor: theme.primary.withOpacity(.2),
                          foregroundColor: theme.primary,
                          icon: Icons.unarchive,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      extentRatio: .2,
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(
                        dismissThreshold: 0.4,
                        onDismissed: () => sendRequest(
                            ref.read(chatProvider.notifier).deleteChat(chat)),
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (_) => sendRequest(
                              ref.read(chatProvider.notifier).deleteChat(chat)),
                          backgroundColor: appColors.error.withOpacity(.2),
                          foregroundColor: appColors.error,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: ChatTile(
                      title: title,
                      avatar: user.avatar,
                      subtitle: chat.lastMessage != null
                          ? ('${sentByYou ? 'You: ' : ''}${chat.lastMessage!.text}')
                          : '',
                      time: chat.lastMessage != null
                          ? formatDate(chat.lastMessage!.createdAt,
                              format: 'hh:mm a')
                          : '',
                      isSelected: selectedChats.contains(chat),
                      unreadMessages: 0,
                      onLongPress: () {
                        ref.read(chatProvider.notifier).selectChat(chat);
                        if (selectedChats.isNotEmpty) {
                          setBarStatus(AppBarState.SELECTION);
                        }
                      },
                      onTap: () {
                        if (selectedChats.isNotEmpty) {
                          ref.read(chatProvider.notifier).selectChat(chat);
                          if (selectedChats.isNotEmpty) {
                            setBarStatus(AppBarState.SELECTION);
                          }
                          return;
                        }
                        AppNavigator.pushNamed(
                          ChatRoutes.chat,
                          args: ChatScreenArgs(
                            title: title,
                            chat: chat,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
