import '../shared.dart';
import 'package:flutter/material.dart';

class AppInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isCircle;
  final Color? overlayColor;
  const AppInkWell({
    super.key,
    required this.child,
    required this.onTap,
    this.isCircle = false,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor:
          overlayColor != null ? WidgetStatePropertyAll(overlayColor) : null,
      borderRadius: BorderRadius.circular(isCircle ? 30 : 12),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: child,
      ),
    );
  }
}
