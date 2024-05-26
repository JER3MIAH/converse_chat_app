import 'package:converse/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingHeaderText extends StatelessWidget {
  final String text;
  const SettingHeaderText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: appColors.coolGrey,
              height: 4,
            ),
          ),
        ],
      ),
    );
  }
}
