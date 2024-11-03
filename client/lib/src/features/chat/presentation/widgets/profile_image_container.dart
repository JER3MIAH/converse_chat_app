import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ProfileImageContainer extends StatelessWidget {
  const ProfileImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.h,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.grey80,
      ),
    );
  }
}
