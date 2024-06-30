import 'package:converse/src/features/navigation/routes.dart';
import 'package:converse/src/features/settings/presentation/screens/setting_screen.dart';
import 'package:get/get.dart';

List<GetPage> settingsPages = [
  GetPage(
    name: SettingsRoutes.settings,
    page: () => const SettingScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
