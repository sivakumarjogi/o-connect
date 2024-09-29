import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';

class CalanderDayWidget extends StatelessWidget {
  CalanderDayWidget({
    super.key,
    required this.date,
    required this.enabled,
    required this.selected,
    required this.onTap,
    required this.applyBorder,
    this.dotColor,
    this.isToday,
    this.height,
  });

  final DateTime date;
  final bool enabled;
  final bool selected;
  final String applyBorder;
  final double? height;
  final Color? dotColor;
  final VoidCallback onTap;
  bool? isToday = false;

  @override
  Widget build(BuildContext context) {
    /*if (selected) {*/
    isToday = selected;
    /* } else {
      isToday = DateUtils.isSameDay(date, DateTime.now());
    }*/
    return Column(
      children: [
        selected!
            ? Container(
                decoration: BoxDecoration(
                    color: AppColors.calendarMonthText,
                    borderRadius: BorderRadius.all(Radius.circular(6.r))),
                height: 35.h,
                width: 32.w,
                child: Center(
                    child: getColumList(
                        isToday: isToday,
                        context: context,
                        afterDay: applyBorder)))
            : SizedBox(
                height: 30.h,
                width: 32.w,
                child: Center(
                    child: getColumList(
                        isToday: isToday,
                        context: context,
                        afterDay: applyBorder)))
      ],
    );
  }

  Widget getColumList({isToday, required context,afterDay}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        enabled
            ? InkWell(
                onTap: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '${date.day}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color:isToday ? AppColors.whiteColor:AppColors.calendarWeekDay,
                            ),
                          ),

                          Container(
                              height: 3.w,
                              width: 3.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: afterDay.contains("completed")
                                      ? AppColors.statusButtonCa
                                      : afterDay.contains("cancelled")
                                          ? AppColors.statusButtonCa
                                          : afterDay.contains("upcoming")
                                              ? AppColors.statusButtonCa
                                              : Colors.transparent)
                              /* : const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent),*/
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: AppColors.calendarWeekHide),
                ),
              ),
      ],
    );
  }
}
