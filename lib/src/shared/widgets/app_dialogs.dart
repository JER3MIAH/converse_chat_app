import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void dialog(Widget content) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: appColors.white,
        shadowColor: appColors.white,
        child: content,
      ),
      barrierDismissible: false,
    );
  }
}
