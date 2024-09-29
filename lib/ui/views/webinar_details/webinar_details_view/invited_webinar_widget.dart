import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/textfield_helper/app_fonts.dart';

class InvitedWebinarWidget extends StatefulWidget {
  const InvitedWebinarWidget({super.key});

  @override
  State<InvitedWebinarWidget> createState() => _InvitedWebinarWidgetState();
}

class _InvitedWebinarWidgetState extends State<InvitedWebinarWidget> {
  LibraryProvider? provider;
  HomeScreenProvider? homeScreenProvider;
  WebinarDetailsProvider? webinarProvider;

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeScreenProvider?.searchController.clear();
      homeScreenProvider?.getMeetingRequests();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: homeScreenProvider.getMeetingRequestLoading
            ? Center(
                child: Lottie.asset(AppImages.loadingJson, height: 50.w, width: 50.w),
              )
            : homeScreenProvider.meetingRequestList.isEmpty
                ? Center(
                    child: Text(
                    "No Records Found",
                    style: w400_14Poppins(color: Colors.white),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeScreenProvider.meetingRequestList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 147.h,
                          width: homeScreenProvider.getInviteMeetingList.length == 1 ? MediaQuery.of(context).size.width / 1.1.sp : MediaQuery.of(context).size.width / 1.2.sp,
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).cardColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              5.h.height,
                              Text(
                                homeScreenProvider.meetingRequestList[index].meetingName!,
                                style: w500_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              5.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.profileIcon),
                                  5.w.width,
                                  Text(
                                    homeScreenProvider.meetingRequestList[index].username!,
                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                  )
                                ],
                              ),
                              5.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.calendarEvent),
                                  5.w.width,
                                  Text(
                                    "${homeScreenProvider.meetingRequestList[index].meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString()} - ${homeScreenProvider.meetingRequestList[index].endDate.toString().toCustomDateFormat("MMM dd yyyy,HH:mm").toString().split(",").last.toString()}",
                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                  )
                                ],
                              ),
                              10.h.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  5.w.width,
                                  InkWell(
                                    onTap: () {
                                      if (homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0) {
                                        context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.meetingRequestList[index].id.toString(), 2, isReceived: true);
                                      } else {
                                        homeScreenProvider.joinMeetingById(homeScreenProvider.meetingRequestList[index].autoGeneratedId.toString(),context);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2 - 40.sp,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3), color: homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0 ? const Color(0xff1B2632) : Colors.blue),
                                      child: Center(
                                        child: Text(
                                          homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0 ? "Decline" : "Join",
                                          style: w400_14Poppins(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  10.w.width,
                                  if (homeScreenProvider.meetingRequestList[index].isInviteAccepted != 2)
                                    InkWell(
                                      onTap: () {
                                        if (homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0) {
                                          context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.meetingRequestList[index].id.toString(), 1, isReceived: true);
                                        }
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 2 - 40.sp,
                                          height: 35.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3.r), color: homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0 ? Colors.blue : Colors.green),
                                          child: Center(
                                            child: Text(
                                              homeScreenProvider.meetingRequestList[index].isInviteAccepted == 0 ? "Accept" : "Accepted",
                                              style: w400_14Poppins(color: Colors.white),
                                            ),
                                          )),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
      );
    });
  }
}
