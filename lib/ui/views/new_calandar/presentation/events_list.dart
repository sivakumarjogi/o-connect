import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:oes_chatbot/utils/extensions/calendar_extensions.dart';

import '../../../../core/models/calender_model/day_model.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import 'UpCoomingMeeting.dart';

class EventList extends StatelessWidget {
  EventList(this.calenderMonthEvent, {super.key,this.isSelected,this.dateTimeC});

  CalenderDayModel? calenderMonthEvent;
  bool? isSelected;
  DateTime? dateTimeC;

  @override
  Widget build(BuildContext context) {
    return  calenderMonthEvent != null && calenderMonthEvent!.events!.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calenderMonthEvent!.events!.length,
            itemBuilder: (context, index) {

        //      calenderMonthEvent!.events!.sort((a,b)=> a.startTime.compareTo(b.startTime));
              return containerList(context, index,calenderMonthEvent!.emailId!, calenderMonthEvent!.events!,isSelected!,dateTimeC);
            })
        : const Text("Data not Found");
  }
}

Widget containerList(
    BuildContext context, int index,String emailId, List<Event> eventsListData,bool isSelected,DateTime? dateTimeC) {
  print("eventsListDatam ${eventsListData[index].startTime}");
  return GestureDetector(
    onTap: () {
      if (eventsListData[index].status.contains("upcoming")) {
        customShowDialog(context, UpComingMeeting(eventsListData, index,emailId));
      } else {
        customShowDialog(
            context, otherStatusMeeting(context, eventsListData, index));
      }
    },
    child: isSelected
        ? eventsListData[index].startTime.isSameDay(dateTime: dateTimeC)
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.calendarBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(AppImages.loadingJson,
                            height: 40.w, width: 40.w),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(eventsListData[index].name),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormat(
                              eventsListData[index].startTime.toString()),
                          style:
                              w400_10Poppins(color: AppColors.calendarWeekDay),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: eventsListData[index]
                                      .status
                                      .contains("completed")
                                  ? AppColors.statusButtonCa.withOpacity(0.3)
                                  : eventsListData[index]
                                          .status
                                          .contains("cancelled")
                                      ? AppColors.redColors.withOpacity(0.3)
                                      : AppColors.calendarMonthText
                                          .withOpacity(0.3)),
                          child: Text(
                            eventsListData[index].status,
                            style: w400_9Poppins(
                                color: eventsListData[index]
                                        .status
                                        .contains("completed")
                                    ? AppColors.statusButtonCa
                                    : eventsListData[index]
                                            .status
                                            .contains("cancelled")
                                        ? AppColors.redColors
                                        : AppColors.calendarMonthText),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const SizedBox()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.calendarBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset(AppImages.loadingJson,
                        height: 40.w, width: 40.w),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(eventsListData[index].name),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat(eventsListData[index].startTime.toString()),
                      style: w400_10Poppins(color: AppColors.calendarWeekDay),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color:
                              eventsListData[index].status.contains("completed")
                                  ? AppColors.statusButtonCa.withOpacity(0.3)
                                  : eventsListData[index]
                                          .status
                                          .contains("cancelled")
                                      ? AppColors.redColors.withOpacity(0.3)
                                      : AppColors.calendarMonthText
                                          .withOpacity(0.3)),
                      child: Text(
                        eventsListData[index].status,
                        style: w400_9Poppins(
                            color: eventsListData[index]
                                    .status
                                    .contains("completed")
                                ? AppColors.statusButtonCa
                                : eventsListData[index]
                                        .status
                                        .contains("cancelled")
                                    ? AppColors.redColors
                                    : AppColors.calendarMonthText),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
  );
}

Widget otherStatusMeeting(
    BuildContext context, List<Event> eventsListData, int index) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
        color: AppColors.calendarBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.r),
          topLeft: Radius.circular(10.r),
        )),
    child: Wrap(
      /*mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,*/
      children: [
        Container(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 6.h,
              width: 60.w,
              decoration: BoxDecoration(
                  color: AppColors.appmainThemeColor,
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ],
        ),
        Container(
          height: 20.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Event ",
                style: w600_14Poppins(color: AppColors.whiteColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.iconClose,
                  color: Theme.of(context).primaryColorLight,
                  height: 22.w,
                  width: 22.w,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.grey.withOpacity(0.2),
        ),
        Container(
          height: 10.h,
        ),
        Container(
          //  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.calendarBg2.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset(AppImages.loadingJson,
                      height: 40.w, width: 40.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(eventsListData[index].name),
                  ),
                ],
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey.withOpacity(0.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat(eventsListData[index].startTime.toString()),
                    style: w400_10Poppins(color: AppColors.calendarWeekDay),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color:eventsListData[index].status.contains("completed")? AppColors.statusButtonCa.withOpacity(0.3):eventsListData[index].status.contains("cancelled")?AppColors.redColors.withOpacity(0.3):AppColors.calendarMonthText.withOpacity(0.3)),
                    child: Text(
                      eventsListData[index].status,
                      style: w400_9Poppins(color: eventsListData[index].status.contains("completed")? AppColors.statusButtonCa:eventsListData[index].status.contains("cancelled")?AppColors.redColors:AppColors.calendarMonthText),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          height: 20.h,
        ),
        Text(eventsListData[index].description,
       //   "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
          style: w400_11Poppins(color: AppColors.calendarWeekDay),
        ),
        Container(
          height: 20.h,
        ),
      ],
    ),
  );
}

String dateFormat(String startDate) {
  // Convert the string to a DateTime object
  DateTime dateTime = DateTime.parse(startDate);
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

void dateFormatDuration(String startDate, String endDateS) {
  // Convert the string to a DateTime object
  DateTime dateTime = DateTime.parse(startDate);
  DateTime endDate = DateTime.parse(endDateS);
  // DateTime sss= DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  int hour = endDate.difference(dateTime).inHours;
  int minutes = endDate.difference(dateTime).inMinutes;
  int second = endDate.difference(dateTime).inSeconds;
}
