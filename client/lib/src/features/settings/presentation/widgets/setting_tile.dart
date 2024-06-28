import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String leadingIcon;
  final String title;
  final VoidCallback onTap;
  final bool hasTopBorder;
  final bool hasSvg, hasTrailingIcon;
  final IconData? iconWidget;
  const SettingsTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.hasTopBorder = false,
    this.hasSvg = true,
    this.hasTrailingIcon = true,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return InkWell(
      overlayColor: MaterialStatePropertyAll(appColors.grey80.withOpacity(0.1)),
      onTap: onTap,
      child: SizedBox(
        height: 50.h,
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.zero,
            child: hasSvg
                ? SvgAsset(
                    assetName: leadingIcon,
                    color: appColors.coolGrey,
                  )
                : Icon(
                    iconWidget,
                    color: appColors.coolGrey,
                  ),
          ),
          trailing: hasTrailingIcon
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.h,
                  color: appColors.grey80.withOpacity(0.7),
                )
              : null,
          tileColor: Colors.transparent,
          shape: Border(
            top: hasTopBorder
                ? BorderSide(color: appColors.grey80.withOpacity(.1))
                : BorderSide.none,
            bottom: BorderSide(color: appColors.grey80.withOpacity(.1)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
