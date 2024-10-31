import 'package:get/get.dart';

class AppNavigator {
  //? use to push to a new route
  static void pushNamed(String name, {Object? args}) {
    if (Get.isDialogOpen!) {
      Get.back(); // Pop any dialogs or modals
    }
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    Get.toNamed(name, arguments: args);
  }

  //? Use to replace the current route with a new route
  static void replaceNamed(String name, {Object? args}) {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.offNamed(name, arguments: args);
  }

  //? Use to replace the current route with a new route
  static void replaceAllNamed(String name, {Object? args}) {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.offAllNamed(name, arguments: args);
  }

  //? Use to pop the current route
  static void popRoute() {
    Get.back();
  }

  //? Use to pop dialog if shown
  static void popDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
  }
}
