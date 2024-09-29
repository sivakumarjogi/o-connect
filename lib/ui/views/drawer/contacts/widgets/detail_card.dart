import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({required this.fieldHeading, required this.fieldData, this.imagePath, this.iconNeeded = false, this.icon, Key? key}) : super(key: key);
  final String fieldHeading;
  final String fieldData;
  final String? imagePath;
  final bool iconNeeded;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        width10,
        // iconNeeded
        //     ? Icon(
        //         icon!,
        //         color: AppColors.calendarIconColor,
        //         size: 18.sp,
        //       )
        //     : SvgPicture.asset(
        //         imagePath!,
        //         height: 15.w,
        //         width: 15.w,
        //       ),
        // width20,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fieldHeading,
                style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
              ),
              SizedBox(
                height: 0.h,
              ),
              Text(
                fieldData,
                style: w400_14Poppins(color: Theme.of(context).hintColor),
              )
            ],
          ),
        )
      ],
    );
  }
}
