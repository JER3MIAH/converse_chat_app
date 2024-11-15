import 'package:converse/src/features/chat/presentation/widgets/profile_image_container.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String title, subtitle, avatar, time;
  final int unreadMessages;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  const ChatTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.avatar = '',
    this.unreadMessages = 0,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: ProfileImageContainer(
        icon: avatar,
        isSelected: isSelected,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
      title: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                title,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppText(
              time,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: appColors.black.withOpacity(.7),
            ),
          ],
        ),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    subtitle,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6F777C),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unreadMessages > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    margin: EdgeInsets.only(left: 5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.blue.withOpacity(.6),
                    ),
                    child: AppText(
                      '$unreadMessages',
                      fontSize: 14.sp,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: appColors.white,
                    ),
                  ),
              ],
            ),
    );
  }
}
