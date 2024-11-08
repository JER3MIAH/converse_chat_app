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
import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final chatController = ref.watch(chatProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final users = ref.watch(chatProvider).users;

    useEffect(() {
      sl<SocketService>().initializeSocket();
      sl<AuthService>().saveFcmToken();
      ref.read(chatProvider.notifier).getAllUsers();
      ref.read(chatProvider.notifier).getChats();
      ref.read(chatProvider.notifier).listenForNewMessage();
      return null;
    }, const []);

    return Scaffold(
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: users.isEmpty ? 0 : 170.h,
            pinned: true,
            centerTitle: false,
            title: AppText('Converse'),
            leading: DrawerButton(),
            actions: [
              GestureDetector(
                onTap: ref.read(themeProvider.notifier).toggleTheme,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SvgAsset(
                    path: isDarkMode ? sunIcon : moonIcon,
                    color: theme.onSurface,
                  ),
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
                              onTap: () =>
                                  AppNavigator.pushNamed(HomeRoutes.users),
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
          if (chatController.chats.isEmpty)
            SliverToBoxAdapter(
              child: Stack(
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
                        onTap: () => AppNavigator.pushNamed(HomeRoutes.users),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // return ListTile(
                //   title: AppText('Ypppppppppppppp'),
                // );
                final chat = chatController.chats[index];
                final user = chat.participants.firstWhere(
                  (user) => user.id != authManager.currentUser!.id,
                );
                final title = user.username;
                final sentByYou =
                    chat.lastMessage?.senderId == authManager.currentUser!.id;

                return ChatTile(
                  title: title,
                  avatar: user.avatar,
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
              // childCount: 30,
              childCount: chatController.chats.length,
            ),
          ),
        ],
      ),
    );
  }
}
