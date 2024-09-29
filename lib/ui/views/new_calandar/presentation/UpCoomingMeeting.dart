import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/calender_model/day_model.dart';
import '../../../../core/providers/app_global_state_provider.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/custom_toast_helper/custom_toast.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../meeting_entry_point.dart';
import 'new_calendar_cancel_meeting_pop.dart';

class UpComingMeeting extends StatelessWidget {
  UpComingMeeting(this.eventsListData, this.index, this.emailId, {super.key});

  final List<Event> eventsListData;
  final int index;
  String emailId;

  @override
  Widget build(BuildContext context) {
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
                    height: 16.w,
                    width: 16.w,
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
                      eventsListData[index].startTime.toString(),
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
          Container(
            height: 20.h,
          ),
          Text(
            eventsListData[index].description,
            //   "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
            style: w400_11Poppins(color: AppColors.calendarWeekDay),
          ),
          Container(
            height: 20.h,
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PIPGlobalNavigation(
                                      childWidget: CreateWebinarScreen(
                                    eventModel: eventsListData[index],
                                    isEdit: true,
                                    eventId: eventsListData[index].id ?? "",
                                  ))));
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.editTextColors.withOpacity(0.2)),
                      child: Center(
                        child: Text(
                          "Edit",
                          textAlign: TextAlign.center,
                          style: w400_14Poppins(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      customShowDialog(
                          context,
                          NewCalendarCancelMeetingPopup(
                            meetingId: eventsListData[index].id,
                            emailId: emailId,
                            userName: eventsListData[index].name,
                          ));
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.calendarMonthText),
                      child: Center(
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: w400_14Poppins(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      AppGlobalStateProvider appGlobalStateProvider =
                          Provider.of<AppGlobalStateProvider>(context,
                              listen: false);

                      if (appGlobalStateProvider.isMeetingInProgress) {
                        CustomToast.showErrorToast(
                            msg: "You are already in an another meeting.");
                      } else {
                        await tryJoinMeeting(context,
                            isHostJoing: true,
                            meetingId: eventsListData[index].id);

                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.calendarMonthText),
                      child: Center(
                        child: Text(
                          "Start",
                          textAlign: TextAlign.center,
                          style: w400_14Poppins(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
