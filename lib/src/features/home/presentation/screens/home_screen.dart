import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:converse/src/features/home/presentation/drawer/app_drawer.dart';
import 'package:converse/src/features/home/presentation/fab/fab.dart';
import 'package:converse/src/features/home/presentation/screens/views/list_of_chats.dart';
import 'package:converse/src/features/notifications/data/repositories/local_notifications.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;

    useEffect(() {
      ref.read(userProvider.notifier).retrieveUserInfo();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.primary,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Converse',
              speed: const Duration(milliseconds: 500),
              textStyle: TextStyle(
                color: appColors.white,
                fontSize: 22.sp,
              ),
            ),
          ],
          onTap: () {
            RemoteMessage message = const RemoteMessage(
              notification: RemoteNotification(
                title: 'Notification Title',
                body: 'Notification Body',
              ),
            );
            LocalNotifications.showSimpleNotification(
              title: 'Jeremiah',
              body: 'Hii, This is my first local notification',
              payload: 'Simple data',
              message: message,
            );
          },
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              // ref.read(notifServiceProvider).sendPushNotification(
              //     ref.read(userProvider).user.pushToken,
              //     'From jeremiah',
              //     'Heyyyyyyyyyyy');
              Scaffold.of(context).openDrawer();
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgAsset(
                assetName: drawerIcon,
                color: appColors.white,
                height: 25.h,
                width: 25.w,
              ),
            ),
          );
        }),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.read(chatProvider.notifier).update();
        },
        child: const ListOfChatsView(),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: const AppFab(),
    );
  }
}
