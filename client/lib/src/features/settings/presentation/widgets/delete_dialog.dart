import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  const DeleteDialog({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AppBackButton(),
              XBox(20.w),
              Text(
                'Delete your account',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.outline,
                ),
              ),
            ],
          ),
          YBox(25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: appColors.error,
              ),
              XBox(4.w),
              Text(
                'Deleting your account will :',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.outline,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Delete your account information',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: appColors.grey80.withOpacity(0.7),
                ),
              ),
              Text(
                '• Delete your account history',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: appColors.grey80.withOpacity(0.7),
                ),
              ),
            ],
          ),
          YBox(30.h),
          AppOutlineButton(
            size: Size(double.infinity, 40.h),
            radius: 14,
            label: 'Cancel',
            onPressed: () {
              AppNavigator.popDialog();
            },
          ),
          YBox(10.h),
          AppButton(
            buttonSize: Size(double.infinity, 40.h),
            title: 'Delete',
            borderRadius: BorderRadius.circular(14),
            buttonColor: appColors.error,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
