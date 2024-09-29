import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/colors/colors.dart';


class WeekdaysWidget extends StatelessWidget {
  const WeekdaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
    return Container(
      decoration: BoxDecoration(


        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(2.0),
      child:   Row(
        children: weekdays
            .map(
              (e) => Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding:  EdgeInsets.symmetric(
                horizontal: 8.0.w,
                vertical: 12.0.h,
              ),
              margin:  EdgeInsets.only(right: 3.w),
              child: Center(
                child: Text(
                  e,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style:  TextStyle(
                    color: AppColors.calendarWeekDay,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
