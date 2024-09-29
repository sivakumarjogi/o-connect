import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    context.read<HomeScreenProvider>().invitedMeetings(context, "", 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left_rounded,
              color: Theme.of(context).primaryColorLight,
            )),
        title: Text(
          "Notifications",
          style: w400_15Poppins(color: Theme.of(context).hintColor),
        ),
      ),
      body: Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
        return Column(
          children: [
            5.h.height,
            ListView.separated(
              itemCount: homeScreenProvider.getInviteMeetingList.length,
              shrinkWrap: true,
              itemBuilder: (context, int) {
                DateTime dateTime = DateTime.parse(homeScreenProvider.getInviteMeetingList[int].createdOn.toString());

                // Format the DateTime object to display only the time
                String formattedTime = DateFormat.jm().format(dateTime);
                return homeScreenProvider.getInviteMeetingList[int].isInvitationAccepted == 0
                    ? Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  5.h.height,
                                  Container(
                                    width: 40.w,
                                    height: 30.h,
                                    child: SvgPicture.asset(AppImages.logo),
                                  ),
                                  10.w.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300.w,
                                        child: RichText(
                                            maxLines: 2,
                                            text: TextSpan(children: [
                                              TextSpan(text: homeScreenProvider.getInviteMeetingList[int].username, style: w400_15Poppins(color: Theme.of(context).hintColor)),
                                              TextSpan(text: " invited you for ", style: w400_14Poppins(color: Theme.of(context).primaryColorLight)),
                                              TextSpan(text: homeScreenProvider.getInviteMeetingList[int].meetingName, style: w400_15Poppins(color: Theme.of(context).hintColor)),
                                            ])),
                                      ),
                                      7.h.height,
                                      Text(
                                        " ${homeScreenProvider.getInviteMeetingList[int].meetingDate.toString().toCustomDateFormat("MMM dd yyyy,HH:mm").split(":").last.toString()} mins ago",
                                        style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                      ),
                                      10.h.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.getInviteMeetingList[int].id.toString(), 2);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2 - 60.sp,
                                              height: 35.h,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff1B2632)),
                                              child: Center(
                                                child: Text(
                                                  "Decline",
                                                  style: w400_14Poppins(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          10.w.width,
                                          // if (homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted != 2)
                                          InkWell(
                                            onTap: () {
                                              if (homeScreenProvider.getInviteMeetingList[int].isInvitationAccepted == 0) {
                                                context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.getInviteMeetingList[int].id.toString(), 1);
                                              }
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context).size.width / 2 - 60.sp,
                                                height: 35.h,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                                child: Center(
                                                  child: Text(
                                                    "Accept",
                                                    style: w400_14Poppins(color: Colors.white),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox();
              },
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 3,
              ),
            ),
          ],
        );
      }),
    );
  }
}
