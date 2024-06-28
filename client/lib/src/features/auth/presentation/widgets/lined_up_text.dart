import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class LinedUpText extends StatelessWidget {
  final String leadingText, trailingText;
  final VoidCallback onTapTrailing;
  final bool isUndelined;
  const LinedUpText({
    super.key,
    required this.leadingText,
    required this.trailingText,
    required this.onTapTrailing,
    this.isUndelined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          leadingText,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.outline,
          ),
        ),
        GestureDetector(
          onTap: onTapTrailing,
          child: Text(
            trailingText,
            style: TextStyle(
              color: theme.colorScheme.primaryContainer,
              fontSize: 14.sp,
              decoration: isUndelined ? TextDecoration.underline : null,
              decorationColor: theme.colorScheme.primaryContainer,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
