import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ProfileImageContainer extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? margin, padding;
  final String? icon;
  final String? title;
  final VoidCallback? onTap;
  final bool showFullTitle, isSelected;
  const ProfileImageContainer({
    super.key,
    this.height,
    this.margin,
    this.padding,
    this.icon,
    this.title,
    this.onTap,
    this.showFullTitle = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: height ?? 43.h,
                  height: height ?? 43.h,
                  padding: padding ?? EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.secondary,
                  ),
                  child: icon == null
                      ? SvgAsset(
                          path: searchIcon,
                          color: theme.onSurface,
                        )
                      : Image.asset(
                          icon!.isEmpty ? 'default' : 'assets/pngs/$icon.png'),
                ),
                if (isSelected)
                  Container(
                    height: 20.h,
                    padding: EdgeInsets.all(2).copyWith(top: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: appColors.white),
                      color: appColors.success,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 11,
                      color: appColors.white,
                    ),
                  ),
              ],
            ),
            if (title != null)
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: SizedBox(
                  width: height ?? 50.h,
                  child: AppText(
                    showFullTitle ? title! : title!.split(' ')[0],
                    fontSize: 13.sp,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
