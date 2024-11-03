import 'package:converse/src/features/navigation/nav.dart';
import '../shared.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: onTap ?? () => AppNavigator.popRoute(),
      child: Icon(
        Icons.keyboard_arrow_left,
        size: 21.w,
      ),
    );
  }
}
