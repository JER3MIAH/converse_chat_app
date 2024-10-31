import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgAsset extends StatelessWidget {
  final String path;
  final Color? color;
  final double? height, width;
  const SvgAsset({
    super.key,
    required this.path,
    this.color,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      height: height,
      width: width,
      path,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
    );
  }
}
