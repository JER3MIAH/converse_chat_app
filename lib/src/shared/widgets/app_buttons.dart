import 'package:converse/src/shared/shared.dart';
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
                backgroundColor: theme.background,
              )
            : Text(
                title,
                style: textStyle ??
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: theme.background),
              ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? overlayColor;
  final Color? borderSideColor, textColor;
  final double height;
  final BorderRadius? borderRadius;
  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onTap,
    this.overlayColor,
    this.borderSideColor,
    this.height = 60,
    this.borderRadius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: OutlinedButton(
          style: ButtonStyle(
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12.h)),
            overlayColor: MaterialStatePropertyAll(
                overlayColor ?? appColors.error.withOpacity(0.4)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius ??
                    BorderRadius.circular(10), // Adjust the radius as needed
              ),
            ),
            side: MaterialStatePropertyAll(
              BorderSide(
                color: borderSideColor ?? appColors.error,
              ),
            ),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16..sp,
              fontWeight: FontWeight.w400,
              color: textColor ?? appColors.error,
            ),
          ),
        ),
      ),
    );
  }
}
