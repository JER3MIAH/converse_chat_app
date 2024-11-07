import 'package:converse/src/features/chat/presentation/screens/chat/chat_screen.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:get/get.dart';

List<GetPage> chatPages = [
  GetPage(
    name: ChatRoutes.chat,
    page: () => ChatScreen(
      args: Get.arguments as ChatScreenArgs,
    ),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 1000),
  ),
  // GetPage(
  //   name: ChatRoutes.worldChat,
  //   page: () => const WorldChatScreen(),
  //   transition: Transition.native,
  //   transitionDuration: const Duration(milliseconds: 500),
  // ),
];
