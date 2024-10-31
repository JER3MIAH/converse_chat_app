import 'package:converse/src/features/auth/presentation/screens/screens.dart';
import 'package:converse/src/features/navigation/routes.dart';
import 'package:get/get.dart';

List<GetPage> authPages = [
  GetPage(
    name: AuthRoutes.onboarding,
    page: () => const OnboardingScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.login,
    page: () => const LoginScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.signUp,
    page: () => const SignupScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
