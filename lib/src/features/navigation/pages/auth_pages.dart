import 'package:converse/src/features/auth/presentation/screens/login_screen.dart';
import 'package:converse/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:get/get.dart';

List<GetPage> authPages = [
  // GetPage(
  //   name: AuthRoutes.onboarding,
  //   page: () => const OnboardingScreen(),
  //   transition: Transition.native,
  //   transitionDuration: const Duration(milliseconds: 500),
  // ),
  GetPage(
    name: AuthRoutes.login,
    page: () => const LoginScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.signUp,
    page: () => const SignUpScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
