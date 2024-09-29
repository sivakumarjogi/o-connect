import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class HeadingNSubHeadingWidget extends StatelessWidget {
  const HeadingNSubHeadingWidget(
      {required this.fieldName,
      required this.fieldValue,
      this.headingTextColor,
      this.subHeadingTextColor,
      Key? key})
      : super(key: key);
  final String fieldName;
  final String fieldValue;
  final Color? headingTextColor;
  final Color? subHeadingTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: w400_14Poppins(color: headingTextColor ?? const Color(0xffAEB5E3)),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          fieldValue,
          style: w400_14Poppins(color: subHeadingTextColor ?? Colors.white),
        )
      ],
    );
  }
}
