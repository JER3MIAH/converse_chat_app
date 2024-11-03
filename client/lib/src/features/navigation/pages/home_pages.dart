import 'package:converse/src/features/chat/presentation/screens/home_screen.dart';
import 'package:converse/src/features/chat/presentation/screens/users_screen.dart';
import 'package:converse/src/features/navigation/redirect.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:get/get.dart';

List<GetPage> homePages = [
  GetPage(
    name: HomeRoutes.home,
    page: () => const HomeScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
    middlewares: [
      AuthMiddleware(),
    ],
  ),
  GetPage(
    name: HomeRoutes.users,
    page: () => const AllUsersScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
    middlewares: [
      AuthMiddleware(),
    ],
  ),
  // GetPage(
  //   name: HomeRoutes.newMessage,
  //   page: () => const NewMessageScreen(),
  //   transition: Transition.rightToLeftWithFade,
  //   transitionDuration: const Duration(milliseconds: 500),
  // ),
];
