import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/core/network/socket_service.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/chat_screen.dart';
import 'package:converse/src/features/chat/presentation/screens/chat/widgets/chat_tile.dart';
import 'package:converse/src/features/chat/presentation/screens/home/widgets/app_drawer.dart';
import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
import 'package:converse/src/features/navigation/nav.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:converse/src/shared/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final unarchivedChats = ref.watch(chatProvider).unarchivedChats;
    final selectedChats = ref.watch(chatProvider).selectedChats;
    final users = ref.watch(chatProvider).users;
    final searchController = useTextEditingController();
    final filteredChats = useState<List<Chat>>(unarchivedChats);
    final barStatus = useState<AppBarState>(AppBarState.REGULAR);

    void setBarStatus(AppBarState value) {
      searchController.clear();
      barStatus.value = value;
    }

    useEffect(() {
      sl<SocketService>().initializeSocket();
      sl<AuthService>().saveFcmToken();
      ref.read(chatProvider.notifier).getAllUsers();
      ref.read(chatProvider.notifier).getChats();
      ref.read(chatProvider.notifier).listenForNewMessage();
      return null;
    }, const []);

    void filterChats(String query) {
      filteredChats.value = unarchivedChats.where((chat) {
        final user = chat.participants.firstWhere(
          (user) => user.id != authManager.currentUser!.id,
        );
        final usernameLower = user.username.toLowerCase();
        final searchLower = query.toLowerCase();
        return usernameLower.contains(searchLower);
      }).toList();
    }

    useEffect(() {
      searchController.addListener(() {
        filterChats(searchController.text);
      });
      return () => searchController.removeListener(() {
            filterChats(searchController.text);
          });
    }, [unarchivedChats]);

    void sendRequest(Future<bool> callback) async {
      final success = await callback;
      if (!success) {
        AppSnackBar.showError(message: ref.read(chatProvider).errorMessage);
      }
    }

    return PopScope(
      canPop: selectedChats.isEmpty,
      onPopInvokedWithResult: (didPop, __) {
        ref.read(chatProvider.notifier).clearSelectedChats();
      },
      child: Scaffold(
        drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: [
            barStatus.value == AppBarState.SEARCH
                ? SliverAppBar(
                    centerTitle: true,
                    expandedHeight: 0,
                    pinned: true,
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
                : SliverAppBar(
                    expandedHeight: users.isEmpty ? 0 : 160.h,
                    pinned: true,
                    centerTitle: false,
                    title: selectedChats.isNotEmpty
                        ? AppText(
                            '${selectedChats.length}',
                            fontSize: 18.sp,
                          )
                        : AppText('Converse'),
                    leading: selectedChats.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.onSurface,
                            ),
                            onPressed: () => ref
                                .read(chatProvider.notifier)
                                .clearSelectedChats(),
                          )
                        : DrawerButton(),
                    actions: selectedChats.isNotEmpty
                        ? [
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
                                Icons.archive_outlined,
                                color: theme.onSurface,
                              ),
                              onPressed: () => sendRequest(ref
                                  .read(chatProvider.notifier)
                                  .archiveSelectedChats()),
                            ),
                          ]
                        : [
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: IconButton(
                                onPressed: () =>
                                    setBarStatus(AppBarState.SEARCH),
                                icon: SvgAsset(path: searchIcon),
                              ),
                            ),
                          ],
                    flexibleSpace: users.isEmpty
                        ? null
                        : FlexibleSpaceBar(
                            background: Padding(
                              padding: EdgeInsets.only(top: 30.h, left: 15.w),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ProfileImageContainer(
                                      margin: EdgeInsets.only(right: 8.w),
                                      title: 'Search',
                                      onTap: () => AppNavigator.pushNamed(
                                          HomeRoutes.users),
                                    ),
                                    ...List.generate(
                                      users.length,
                                      (index) {
                                        final user = users[index];
                                        return ProfileImageContainer(
                                          margin: EdgeInsets.only(right: 8.w),
                                          icon: user.avatar,
                                          title: user.username,
                                          onTap: () {
                                            AppNavigator.pushNamed(
                                              ChatRoutes.chat,
                                              args: ChatScreenArgs(
                                                title: user.email,
                                                chat: Chat(
                                                  id: generateChatId(
                                                    id1: authManager
                                                        .currentUser!.id,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(.5),
                      child: Container(
                        color: theme.secondary,
                        height: 1,
                      ),
                    ),
                  ),
            if (unarchivedChats.isEmpty)
              SliverToBoxAdapter(
                child: unarchivedChats.isNotEmpty && filteredChats.value.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200.h),
                          child: AppText(
                            'No match found',
                            fontSize: 20.sp,
                          ),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          LottieAsset(assetPath: 'assets/jsons/noChats.json'),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                'No chats available',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              YBox(10.h),
                              AppButton(
                                buttonSize: Size(200.w, 50.h),
                                title: 'Start Chat',
                                onTap: () =>
                                    AppNavigator.pushNamed(HomeRoutes.users),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: barStatus.value == AppBarState.SEARCH
                    ? filteredChats.value.length
                    : unarchivedChats.length,
                (context, index) {
                  final chat = (barStatus.value == AppBarState.SEARCH
                      ? filteredChats.value[index]
                      : unarchivedChats[index]);
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
                          icon: Icons.archive,
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
                      onLongPress: () =>
                          ref.read(chatProvider.notifier).selectChat(chat),
                      onTap: () {
                        if (selectedChats.isNotEmpty) {
                          ref.read(chatProvider.notifier).selectChat(chat);
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
          ],
        ),
      ),
    );
  }
}
