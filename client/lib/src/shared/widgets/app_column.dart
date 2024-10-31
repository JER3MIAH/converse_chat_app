import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class AppColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final bool shouldScroll;

  const AppColumn({
    super.key,
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.shouldScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: shouldScroll
          ? SingleChildScrollView(
              child: Padding(
                padding: padding ??
                    EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 25.h),
                child: Column(
                  mainAxisSize: mainAxisSize,
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            )
          : Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 25.h),
              child: Column(
                mainAxisSize: mainAxisSize,
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
    );
  }
}
