import 'package:converse/src/features/theme/logic/theme_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppIconAndText extends ConsumerWidget {
  final double? width;
  const AppIconAndText({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final themeProv = ref.watch(themeProvider);

    return AppColumn(
      width: width ?? MediaQuery.of(context).size.width,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.h,
          width: 50.w,
          child: FittedBox(child: Image.asset(appIcon)),
        ),
        YBox(5.h),
        Text(
          'Converse',
          style: TextStyle(
            color:
                themeProv.isDarkMode ? theme.primaryContainer : theme.primary,
            fontSize: 21.2.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
