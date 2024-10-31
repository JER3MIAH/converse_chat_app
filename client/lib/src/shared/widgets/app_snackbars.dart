import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void showError({
    required String message,
    Widget? icon,
    String? title,
    Color? textColor,
    Color? bgColor,
    Color? leftBarColor,
    Duration? duration,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        icon: icon ??
            Icon(
              Icons.warning,
              color: textColor ?? const Color(0xffEB0000),
            ),
        leftBarIndicatorColor: leftBarColor ?? const Color(0xffEB0000),
        messageText: Text(
          message,
          style: TextStyle(
            color: textColor ?? const Color(0xffEB0000),
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
          ),
        ),
        isDismissible: true,
        shouldIconPulse: false,
        duration: duration ?? const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: bgColor ?? const Color(0xFFFEF2F2),
      ),
    );
  }

  static void showSuccess({
    String? title,
    required String message,
    Duration? duration,
    Color? textColor,
    Color? bgColor,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        title: title,
        titleText: title != null
            ? Text(
                title,
                style: TextStyle(
                  color: appColors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              )
            : null,
        icon: Container(
          height: 20.w,
          width: 20.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColors.success,
          ),
          child: Icon(
            Icons.check,
            size: 13.sp,
            color: appColors.white,
          ),
        ),
        leftBarIndicatorColor: appColors.success,
        messageText: Text(
          message,
          style: TextStyle(
            color: appColors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        isDismissible: true,
        shouldIconPulse: false,
        duration: duration ?? const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: bgColor ?? appColors.white,
      ),
    );
  }

  static showTips(String? header, String message) {
    Get.snackbar(
      header ?? "Tips",
      message,
      duration: const Duration(seconds: 10),
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static showShortTip(String? header, String message) {
    Get.snackbar(
      header ?? "Tips",
      message,
      duration: const Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
