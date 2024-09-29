import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/calender_model/day_model.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/calendar_event_data.dart';
import 'package:o_connect/ui/views/meeting_entry_point.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/cancel_reason_pop_up.dart';

class EventsModalSheet extends StatefulWidget {
  final CalendarEventData events;

  const EventsModalSheet({super.key, required this.events});

  @override
  State<EventsModalSheet> createState() => _EventsModalSheetState();
}

class _EventsModalSheetState extends State<EventsModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(builder: (context, value, child) {
      return Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                showDialogCustomHeader(context, headerTitle: widget.events.status ?? "NA"),
                EventCard(events: widget.events),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      style: w500_14Poppins(color: AppColors.mainBlueColor),
                    ))
              ],
            ),
          ],
        ),
      );
    });
  }
}

Widget imageWithLogo(image, {double? height, width}) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        height: height ?? 60.h,
        width: width ?? 60.w,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black,width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SvgPicture.asset(image),
      ),
      if (image == AppImages.oConnectIcon1) Container(height: 20.h, width: 20.w, color: Colors.white, child: Lottie.asset(AppImages.splashImage))
    ],
  );
}

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.events});

  final CalendarEventData events;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final TextEditingController _cancelReasonController = TextEditingController();
  late CalenderProvider cProvider;
  String? status;

  late String uiStartTime;
  late String uiEndTime;

  @override
  void initState() {
    cProvider = Provider.of<CalenderProvider>(context, listen: false);
    uiStartTime = DateFormat("hh:mm aa").format(widget.events.startTime);
    uiEndTime = DateFormat("hh:mm aa").format(widget.events.endTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Event? event = widget.events.event as Event?;

    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWithLogo(getSvgProductLogoFromName(event?.productName ?? '')),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ScreenConfig.width * 0.6,
                      child: Text(
                        widget.events.name,
                        style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                    Text(
                      "${DateFormat("dd MMM").format(widget.events.startTime).toString()} , "
                      "$uiStartTime"
                      " - "
                      "$uiEndTime",
                      style: w300_14Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    Text(
                      widget.events.description,
                      style: w400_12Poppins(color: Theme.of(context).disabledColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          widget.events.status == "upcoming" && widget.events.startTime.isAfter(DateTime.now()) && event?.productId == ConstantsStrings.oconnectProductId
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CustomButton(
                        buttonText: "Cancel",
                        width: 85.w,
                        height: 32.h,
                        buttonColor: const Color(0xff03BAF5).withOpacity(0.2),
                        buttonTextStyle: w600_14Poppins(color: AppColors.mainBlueColor),
                        onTap: () {
                          customShowDialog(
                              context,
                              CancelReasonPopUp(
                                controller: _cancelReasonController,
                                events: widget.events,
                              )).then((cancelled) {
                            if (cancelled == true) navigationKey.currentContext?.read<CalenderProvider>().fetchEventsInDay(navigationKey.currentContext);
                          });
                        },
                      ),
                      width15,
                      CustomButton(
                        buttonText: "Edit",
                        buttonColor: Colors.transparent,
                        borderColor: AppColors.mainBlueColor,
                        buttonTextStyle: w600_14Poppins(color: Colors.white),
                        width: 85.w,
                        height: 32.h,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PIPGlobalNavigation(
                                        childWidget: CreateWebinarScreen(
                                          eventModel: widget.events,
                                          eventId: widget.events.id ?? "",
                                          isEdit: widget.events.id != null,
                                        ),
                                      ))).then((value) {
                            navigationKey.currentContext?.read<CalenderProvider>().fetchEventsInDay(navigationKey.currentContext);
                          });
                        },
                      ),
                      width15,
                      CustomButton(
                        buttonText: "Start",
                        width: 85.w,
                        height: 32.h,
                        buttonTextStyle: w600_14Poppins(color: Colors.white),
                        onTap: () {
                          Navigator.of(context).pop();
                          tryJoinMeeting(navigationKey.currentContext!, isHostJoing: true, meetingId: widget.events.id);
                        },
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          height15,
        ],
      ),
    );
  }
}
