import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/debouncer.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/past_webinar_files.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/save_as_template.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/saved_widget.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../webinar_details_model/meeting_details_model.dart';

class PastWebinarsWidget extends StatefulWidget {
  MeetingDetailsModel? dataList;

  PastWebinarsWidget({
    super.key,
    this.dataList,
  });

  @override
  State<PastWebinarsWidget> createState() => _PastWebinarsWidgetState();
}

class _PastWebinarsWidgetState extends State<PastWebinarsWidget> {
  HomeScreenProvider? homeScreenProvider;
  WebinarDetailsProvider? webinarProvider;
  final ScrollController scrollController = ScrollController();
  final int scrollThreshold = 600;
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  scrollListener() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (maxScroll - currentScroll <= scrollThreshold &&
        !homeScreenProvider!.getAllMeetingLoading) {
      _debouncer.run(() {
        homeScreenProvider?.getMeetings(context);
      });
    }
    // debugPrint('test');
  }

  @override
  void initState() {
    webinarProvider =
        Provider.of<WebinarDetailsProvider>(context, listen: false);
    homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeScreenProvider?.reSetData(context, "past");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(
        builder: (context, provider, homeScreenProvider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 100.sp,
        child: homeScreenProvider.getAllMeetingLoading
            ? Center(
                child: Lottie.asset(AppImages.loadingJson,
                    height: 50.w, width: 50.w),
              )
            : homeScreenProvider.getMeetingList.isEmpty
                ? Center(
                    child: Text(
                    "No records found",
                    style: w400_14Poppins(color: Colors.white),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeScreenProvider.getMeetingList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.sp, vertical: 10.sp),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Theme.of(context).cardColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              5.h.height,
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xff143227)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "COMPLETED",
                                    style: w500_10Poppins(color: Colors.green),
                                  ),
                                ),
                              ),
                              5.h.height,
                              Text(
                                homeScreenProvider
                                    .getMeetingList[i].meetingName!,
                                style: w500_14Poppins(
                                    color: Theme.of(context).hintColor),
                              ),
                              5.h.height,
                              Text(
                                homeScreenProvider
                                    .getMeetingList[i].autoGeneratedId!,
                                style: w400_13Poppins(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              5.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.profileIcon),
                                  10.w.width,
                                  Text(
                                    "${homeScreenProvider.getMeetingList[i].username!.split("@").first}",
                                    style: w400_13Poppins(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  )
                                ],
                              ),
                              10.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.calendarEvent),
                                  10.w.width,
                                  Text(
                                    homeScreenProvider
                                        .getMeetingList[i].meetingDate
                                        .toString()
                                        .toCustomDateFormat(
                                            "MMM dd, yyyy HH:mm")
                                        .toString(),
                                    style: w400_13Poppins(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  )
                                ],
                              ),
                              10.h.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () => detailsPopUp(context,
                                          homeScreenProvider.getMeetingList[i]),
                                      child: Container(
                                        // width: 80.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: const Color(0xff315D92)
                                                .withOpacity(0.2)),
                                        child: Center(
                                          child: Text(
                                            "Details",
                                            style: w400_14Poppins(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  10.w.width,
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PastWebinarsFilesScreen(
                                                        meetingId:
                                                            homeScreenProvider
                                                                    .getMeetingList[
                                                                        i]
                                                                    .id ??
                                                                "")));
                                      },
                                      child: Container(
                                          // width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Colors.blue),
                                          child: Center(
                                            child: Text(
                                              "View Files",
                                              style: w400_14Poppins(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
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

  Future detailsPopUp(BuildContext context, MeetingDetailsModel meetingList) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.r),
                topLeft: Radius.circular(24.r))),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: const Color(0xff202223)),
                  ),
                ),
                25.h.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Details",
                      style: w500_14Poppins(color: Colors.white),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (meetingList.exitUrl == null ||
                                meetingList.exitUrl == "") {
                              CustomToast.showErrorToast(
                                  msg:
                                      "No attendee reports available for this meeting");
                            } else {
                              Provider.of<LibraryProvider>(context,
                                      listen: false)
                                  .fileDownloadLocal(meetingList.exitUrl,
                                      meetingList.meetingName);

                              Navigator.pop(context);
                            }
                          },
                          child: SvgPicture.asset(
                              "assets/new_ui_icons/events/download.svg"),
                        ),
                        10.w.width,
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.cancel,
                              size: 24.sp,
                              color: const Color(0xff5E6272),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
                10.h.height,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xff143227)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "COMPLETED",
                      style: w500_10Poppins(color: Colors.green),
                    ),
                  ),
                ),
                5.h.height,
                TextDarkField(
                  name: meetingList.meetingName!,
                ),
                5.h.height,
                TextLightField(
                  name: meetingList.autoGeneratedId.toString(),
                ),
                15.h.height,
                TextLightField(
                  name: "Host",
                ),
                5.h.height,
                TextDarkField(
                  name: "${meetingList.username!.split("@").first}",
                ),
                15.h.height,
                TextLightField(
                  name: "Start Date & Time",
                ),
                5.h.height,
                TextDarkField(
                  name: meetingList.meetingDate
                      .toString()
                      .toCustomDateFormat("MMM dd, yyyy HH:mm")
                      .toString(),
                ),
                15.h.height,
                TextLightField(
                  name: "Duration",
                ),
                5.h.height,
                TextDarkField(
                  name:
                      "${meetingList.duration.toString().split(":").first} Hrs ${meetingList.duration.toString().split(":").last} Mins",
                ),
                15.h.height,
                TextLightField(name: "Login and Exit time "),
                5.h.height,
                TextDarkField(
                  name:
                      "${meetingList.meetingDate.toString().toCustomDateFormat("HH:mm").toString()} & ${meetingList.endDate.toString().toCustomDateFormat("HH:mm").toString()}",
                ),
                10.h.height,
                TextLightField(
                  name: "Event Type",
                ),
                5.h.height,
                Text(
                  meetingList.meetingType!,
                  style: w400_13Poppins(color: Theme.of(context).hintColor),
                ),
                15.h.height,
                TextLightField(name: "Participants "),
                5.h.height,
                Text(
                  meetingList.invitedDetails!.length.toString(),
                  style: w500_14Poppins(color: Theme.of(context).hintColor),
                ),
                10.h.height,
                30.h.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          customShowDialog(context,
                              DeleteBottomSheetForPastEvent(onTap: () {
                            Provider.of<HomeScreenProvider>(context,
                                    listen: false)
                                .deletePastMeeting(
                                    meetingId: meetingList.id ?? "00",
                                    context: context,
                                    meetingType: "past");
                          }));
                        },
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xff1B2632)),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: w400_14Poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          customShowDialog(
                              context,
                              backGroundColor: Theme.of(context).cardColor,
                              SaveAsTemplate(
                                dataList: meetingList,
                              ));
                        },
                        child: Container(
                            // width: 100.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.blue),
                            child: Center(
                              child: Text(
                                "Save as",
                                style: w400_14Poppins(color: Colors.white),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }).whenComplete(() {
      // commonProvider?.updateSelectedSound();
    });
  }
}

class DeleteBottomSheetForPastEvent extends StatelessWidget {
  DeleteBottomSheetForPastEvent({
    required this.onTap,
    Key? key,
  }) : super(key: key);
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height5,
          showDialogCustomHeader(context,
              headerTitle: "Delete", headerColor: const Color(0xff202223)),
          height15,
          Text(
            "Are you sure to delete this webinar?",
            textAlign: TextAlign.center,
            style: w500_14Poppins(color: Colors.white),
          ),
          height20,
          homeScreenProvider.cancelMeeting
              ? Center(
                  child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: Lottie.asset(AppImages.loadingJson)),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: 'Cancel',
                      height: 30.h,
                      textColor: Colors.blue,
                      buttonColor: const Color(0xff1B2632),
                      buttonTextStyle: w500_14Poppins(color: Colors.white),
                      width: MediaQuery.of(context).size.width / 2 - 40.sp,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    width10,
                    CustomButton(
                      buttonText: 'Delete',
                      width: MediaQuery.of(context).size.width / 2 - 40.sp,
                      height: 30.h,
                      onTap: onTap,
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                    ),
                    width10,
                  ],
                ),
          height15,
        ],
      );
    });
  }
}

//  Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(8.r),
//                 topLeft: Radius.circular(8.r),
//               ),
//               color: Theme.of(context).highlightColor),
//           child: Padding(
//             padding: EdgeInsets.all(12.0.sp),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.6,
//                         child: Text(widget.dataList.meetingName.toString(), overflow: TextOverflow.ellipsis, style: w400_14Poppins(color: Theme.of(context).hintColor)),
//                       ),
//                       height5,
//                       Text(
//                         widget.dataList.autoGeneratedId.toString(),
//                         style: w300_10Poppins(color: Theme.of(context).disabledColor),
//                       )
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                     onTap: () {
//                       customShowDialog(context, DeleteBottomSheetForPastEvent(
//                         isTransfer:true,
//                         onTap: () async {
//                           Provider.of<HomeScreenProvider>(context, listen: false).deletePastMeeting(meetingId: widget.dataList.id ?? "00", context: context);
//                         },
//                       ));
//                     },
//                     child: SvgPicture.asset(
//                       AppImages.delete,
//                       color: const Color(0xFF8186B3),
//                     )),
//                 width5,
//                 InkWell(
//                     onTap: () {
//                       print(widget.dataList.dataUrl);

//                       if (widget.dataList.dataUrl == null || widget.dataList.dataUrl == "") {
//                         CustomToast.showErrorToast(msg: "No attendee reports available for this meeting");
//                       } else {
//                         Provider.of<LibraryProvider>(context, listen: false).fileDownloadLocal(widget.dataList.dataUrl, widget.dataList.meetingName);
//                       }
//                     },
//                     child: SvgPicture.asset(
//                       AppImages.downloadWebinar,
//                       color: const Color(0xFF8186B3),
//                     )),
//               ],
//             ),
//           ),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 15.w, top: 15.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWithFontWidget(
//                       text: ConstantsStrings.dateAndTime,
//                       style: w300_12Poppins(color: Theme.of(context).disabledColor),
//                     ),
//                     height5,
//                     TextWithFontWidget(
//                       text: widget.finalDate,
//                       style: w400_13Poppins(color: Theme.of(context).hintColor),
//                     ),
//                     height10,
//                     TextWithFontWidget(
//                       text: "Organizer",
//                       style: w300_12Poppins(color: Theme.of(context).disabledColor),
//                     ),
//                     height5,
//                     TextWithFontWidget(
//                       text: widget.dataList.username!,
//                       style: w400_13Poppins(color: Theme.of(context).hintColor),
//                     ),
//                     height10,
//                     TextWithFontWidget(
//                       text: "Passcode",
//                       style: w300_12Poppins(color: Theme.of(context).disabledColor),
//                     ),
//                     height5,
//                     TextWithFontWidget(
//                       // text: widget.dataList.participantKey.toString(),
//                       text: "--",
//                       style: w400_13Poppins(color: Theme.of(context).hintColor),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 15.w, top: 15.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     TextWithFontWidget(
//                       text: "Duration",
//                       style: w300_12Poppins(color: Theme.of(context).disabledColor),
//                     ),
//                     height5,
//                     TextWithFontWidget(
//                       text: "${widget.dataList.duration.toString().split(":").first} Hrs ${widget.dataList.duration.toString().split(":").last} Mins",
//                       style: w400_13Poppins(color: Theme.of(context).hintColor),
//                     ),
//                     height10,
//                     TextWithFontWidget(
//                       text: "Time Zone",
//                       style: w300_12Poppins(color: Theme.of(context).disabledColor),
//                     ),
//                     height5,
//                     TextWithFontWidget(
//                       text: widget.dataList.timezone!,
//                       style: w400_13Poppins(color: Theme.of(context).hintColor),
//                     ),
//                     height10,
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//         height5,
