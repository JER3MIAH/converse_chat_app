import '../shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void dialog(Widget content, {Color? bgColor}) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: bgColor ?? appColors.white,
        shadowColor: bgColor ?? appColors.white,
        child: content,
      ),
      barrierDismissible: false,
    );
  }
}
