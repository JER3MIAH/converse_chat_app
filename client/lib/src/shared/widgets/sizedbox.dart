import 'package:flutter/material.dart';

class XBox extends StatelessWidget {
  const XBox(this.width, {super.key});

  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class YBox extends StatelessWidget {
  const YBox(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
