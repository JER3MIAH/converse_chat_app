import '../shared.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Size? buttonSize;
  final bool isLoading;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.buttonColor,
    this.buttonSize,
    this.isLoading = false,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BounceInAnimation(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          minimumSize: buttonSize ?? const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
          backgroundColor: buttonColor ?? theme.primary,
        ),
        child: isLoading
            ? CircularProgressIndicator.adaptive(
                backgroundColor: theme.surface,
              )
            : Text(
                title,
                style: textStyle ??
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: appColors.white),
              ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.radius = 20,
    this.size,
    this.labelStyle,
  });

  final String label;
  final TextStyle? labelStyle;
  final VoidCallback onPressed;
  final Color? borderColor;
  final double radius;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: size,
        side: BorderSide(
          color: borderColor ?? appColors.blue,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: labelStyle ??
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.blue,
                  ),
        ),
      ),
    );
  }
}
