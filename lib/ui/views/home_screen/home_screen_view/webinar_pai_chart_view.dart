import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class RequestedMeetings extends StatefulWidget {
  const RequestedMeetings({super.key});

  @override
  State<RequestedMeetings> createState() => _RequestedMeetingsState();
}

class _RequestedMeetingsState extends State<RequestedMeetings> {
  @override
  void initState() {
    context.read<HomeScreenProvider>().invitedMeetings(context, "", 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  homeScreenProvider.getInviteMeetingList.length == 0
                      ? Text(
                          "Meeting Requests",
                          style: w500_14Poppins(color: Colors.white),
                        )
                      : Text(
                          "Meeting Requests (${homeScreenProvider.getInviteMeetingList.length.toString()})",
                          style: w500_14Poppins(color: Colors.white),
                        ),
                  homeScreenProvider.getInviteMeetingList.length > 3
                      ? Padding(
                          padding: EdgeInsets.only(right: 8.0.sp),
                          child: GestureDetector(
                              onTap: () {
                                homeScreenProvider.updateCurrentPage(1);
                                Provider.of<WebinarDetailsProvider>(context, listen: false).selectedRadioValue = 2;
                                Provider.of<WebinarDetailsProvider>(context, listen: false).isCreated = false;
                              },
                              child: Text(
                                "View All",
                                style: w500_14Poppins(color: Colors.blue),
                              )),
                        )
                      : const SizedBox()
                ],
              ),
              10.h.height,
              SizedBox(
                height: 175.h,
                child: homeScreenProvider.getInviteMeetingList.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            15.h.height,
                            SvgPicture.asset(AppImages.noMeetingRequests),
                            10.h.height,
                            Text(
                              "No Meeting Requests",
                              style: w400_14Poppins(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: homeScreenProvider.getInviteMeetingList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.all(4.0.sp),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 140.h,
                              width: homeScreenProvider.getInviteMeetingList.length == 1 ? MediaQuery.of(context).size.width / 1.1.sp : MediaQuery.of(context).size.width / 1.2.sp,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Theme.of(context).scaffoldBackgroundColor),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    5.h.height,
                                    Text(
                                      homeScreenProvider.getInviteMeetingList[index].meetingName!,
                                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                                    ),
                                    5.h.height,
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppImages.profileIcon),
                                        5.w.width,
                                        Text(
                                          homeScreenProvider.getInviteMeetingList[index].username!,
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
                                          "${homeScreenProvider.getInviteMeetingList[index].meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString()} - ${homeScreenProvider.getInviteMeetingList[index].endDate.toString().toCustomDateFormat("MMM dd yyyy,HH:mm").toString().split(",").last.toString()}",
                                          style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                        )
                                      ],
                                    ),
                                    15.h.height,
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // 5.w.width,
                                        InkWell(
                                          onTap: () {
                                            if (homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0) {
                                              context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.getInviteMeetingList[index].id.toString(), 2);
                                            } else {
                                              homeScreenProvider.joinMeetingById(homeScreenProvider.getInviteMeetingList[index].autoGeneratedId.toString(),context);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 2 - 55.sp,
                                            height: 35.h,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0 ? const Color(0xff1B2632) : Colors.blue),
                                            child: Center(
                                              child: Text(
                                                homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0 ? "Decline" : "Join",
                                                style: w400_14Poppins(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        10.w.width,
                                        if (homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted != 2)
                                          InkWell(
                                            onTap: () {
                                              if (homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0) {
                                                context.read<HomeScreenProvider>().invitedUpDataMeetings(context, homeScreenProvider.getInviteMeetingList[index].id.toString(), 1);
                                              }
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context).size.width / 2 - 55.sp,
                                                height: 35.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0 ? Colors.blue : Colors.green),
                                                child: Center(
                                                  child: Text(
                                                    homeScreenProvider.getInviteMeetingList[index].isInvitationAccepted == 0 ? "Accept" : "Accepted",
                                                    style: w400_14Poppins(color: Colors.white),
                                                  ),
                                                )),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              )
            ],
          ),
        ),
      );
    });
  }
}
// Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, child) {
//       return Container(
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
//         child: homeScreenProvider.getAllMeetingChartLoading == true
//             ? Center(
//                 child: Lottie.asset(
//                 AppImages.loadingJson,
//                 height: 40.w,
//                 width: 40.w,
//               ))
//             : homeScreenProvider.chartData.isEmpty
//                 ? Center(
//                     child: Text(
//                       "Data not available...",
//                       style: w500_18Poppins(color: Theme.of(context).primaryColorLight),
//                     ),
//                   )
//                 : Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                     ),
//                     child: SfCircularChart(
//                       margin: EdgeInsets.zero,
//                       tooltipBehavior: TooltipBehavior(enable: true),
//                       title: ChartTitle(text: "All Webinars", alignment: ChartAlignment.near, textStyle: w500_15Poppins(color: Theme.of(context).hintColor)),
//                       legend: Legend(
//                           position: LegendPosition.bottom,
//                           // orientation: LegendItemOrientation.vertical,
//                           textStyle: w400_12Poppins(color: Theme.of(context).disabledColor),
//                           isVisible: true,
//                           isResponsive: true,
//                           toggleSeriesVisibility: false,
//                           // overflowMode: LegendItemOverflowMode.none,
//                           legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
//                             return Container(
//                               width: 90.w,
//                               height: 40.h,
//                               margin: EdgeInsets.symmetric(horizontal: 1.w),
//                               alignment: Alignment.center,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: point.color),
//                                     height: 15.w,
//                                     width: 15.w,
//                                   ),
//                                   width5,
//                                   Text(
//                                     name,
//                                     style: w400_12Poppins(color: Theme.of(context).disabledColor),
//                                     textAlign: TextAlign.left,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                       series: <CircularSeries>[
//                         DoughnutSeries<ChartData, String>(
//                             animationDuration: 10,
//                             dataSource: homeScreenProvider.chartData,
//                             pointColorMapper: (ChartData data, _) => data.eventColor,
//                             xValueMapper: (ChartData data, _) => data.eventName,
//                             yValueMapper: (ChartData data, _) => data.eventValue.toInt(),
//                             groupMode: CircularChartGroupMode.point,
//                             explodeOffset: '60%',
//                             dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: w400_12Poppins(color: Theme.of(context).primaryColor)),
//                             // Radius for each segment from data source
//                             onPointTap: (pointInteractionDetails) {
//                               ChartPointDetails mychart = pointInteractionDetails;

//                               print( homeScreenProvider.chartData );
//                               print( homeScreenProvider.chartData[0].eventName);
//                             },
//                             enableTooltip: true)
//                       ],
//                     ),
//                   ),
//       );
//     });
