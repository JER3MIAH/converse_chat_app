import 'package:flutter/material.dart';

class StartAlignedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const StartAlignedText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: style ?? Theme.of(context).textTheme.displayMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
