import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class LoadingChat extends ConsumerWidget {
  const LoadingChat({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[500]! : Colors.grey[100]!,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        leading: CircleAvatar(
          radius: 25.r,
          backgroundColor: appColors.coolGrey,
        ),
        title: Row(
          children: [
            Container(
              width: 130.w,
              height: 15.h,
              margin: EdgeInsets.symmetric(vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appColors.coolGrey,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Container(
              width: 250.w,
              height: 15.h,
              margin: EdgeInsets.symmetric(vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appColors.coolGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
