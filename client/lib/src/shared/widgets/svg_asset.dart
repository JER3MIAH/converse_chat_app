import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

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

class LottieAsset extends StatelessWidget {
  final String assetPath;
  final double? height, width;
  const LottieAsset({
    super.key,
    required this.assetPath,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      height: height,
      width: width,
    );
  }
}
