import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final String sender, time, chatText;
  final bool sentByYou;
  const ChatBox({
    super.key,
    required this.sender,
    required this.time,
    required this.chatText,
    required this.sentByYou,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentByYou ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // color: appColors.coolGrey,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          margin: EdgeInsets.only(bottom: 12.h),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .75),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                sentByYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              AppText(
                sentByYou ? 'You' : sender,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: appColors.black.withOpacity(.8),
              ),
              YBox(5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: sentByYou
                      ? appColors.blue.withOpacity(.7)
                      : const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(8).copyWith(
                    topLeft: sentByYou ? null : Radius.zero,
                    topRight: sentByYou ? Radius.zero : null,
                  ),
                ),
                child: AppText(
                  chatText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: sentByYou ? appColors.white : appColors.black,
                ),
              ),
              AppText(
                time,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF414649),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
