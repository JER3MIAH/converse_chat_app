import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class IconFiller extends StatelessWidget {
  final Color fillColor;
  final Widget icon;
  const IconFiller({
    super.key,
    required this.fillColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: 35.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
      ),
      child: Center(child: icon),
    );
  }
}
