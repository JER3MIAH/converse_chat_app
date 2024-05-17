import 'package:flutter/material.dart';

class AppColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding, margin;
  final Color? color;
  final Decoration? decoration;
  final double? width, height;
  final bool shouldScroll;

  const AppColumn({
    super.key,
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.margin,
    this.shouldScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: (shouldScroll)
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: Container(
        padding: padding,
        margin: margin,
        color: color,
        decoration: decoration,
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ),
      ),
    );
  }
}
