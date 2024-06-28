import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class AppDrawerTile extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  final double? rightPadding;
  const AppDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Padding(
        padding: EdgeInsets.only(right: rightPadding ?? 17.w),
        child: SvgAsset(assetName: icon, color: appColors.coolGrey,),
      ),
      title: Text(title),
    );
  }
}
