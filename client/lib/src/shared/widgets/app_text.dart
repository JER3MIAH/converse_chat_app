import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextDecoration? decoration;
  final TextDecorationStyle? decorationStyle;
  final double? fontSize;
  final FontWeight fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final String? semanticsLabel;

  const AppText(
    this.text, {
    super.key,
    this.color,
    this.decoration,
    this.decorationStyle,
    this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.textAlign,
    this.overflow,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        decoration: decoration,
        decorationStyle: decorationStyle,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
      ),
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      textAlign: textAlign,
    );
  }
}
