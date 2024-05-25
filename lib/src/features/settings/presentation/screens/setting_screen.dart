import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(theme),
        ],
      ),
    );
  }

  Widget _buildTopBar(ColorScheme theme) {
    return Container(
      height: 150.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(
            color: appColors.white,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          YBox(30.h),
          BackButton(
            color: appColors.white,
          ),
          YBox(10.h),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
