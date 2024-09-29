import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_dotted_divider.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/meeting_entry_point.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/textfield_helper/app_fonts.dart';
import '../webinar_details_model/meeting_details_model.dart';

class AllWebinarWidget extends StatefulWidget {
  const AllWebinarWidget({super.key});
  @override
  State<AllWebinarWidget> createState() => _AllWebinarWidgetState();
}

class _AllWebinarWidgetState extends State<AllWebinarWidget> {
  HomeScreenProvider? homeScreenProvider;
  WebinarDetailsProvider? webinarProvider;
  @override
  void initState() {
    webinarProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeScreenProvider?.searchController.clear();
    });

    homeScreenProvider?.getMeetings(context, searchHistory: "", selectedValue: "upcoming");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          homeScreenProvider.getMeetingList.isEmpty == true
              ? const Text("No records found")
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: homeScreenProvider.getMeetingList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Theme.of(context).cardColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  5.h.height,
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xff152E3C)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        "SCHEDULED",
                                        style: w500_10Poppins(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  5.h.height,
                                  Text(
                                    homeScreenProvider.getMeetingList[i].meetingName!,
                                    style: w500_14Poppins(color: Theme.of(context).hintColor),
                                  ),
                                  5.h.height,
                                  Text(
                                    homeScreenProvider.getMeetingList[i].autoGeneratedId.toString(),
                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                  ),
                                  5.h.height,
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppImages.profileIcon),
                                      10.w.width,
                                      Text(
                                        homeScreenProvider.getMeetingList[i].username!,
                                        style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      )
                                    ],
                                  ),
                                  5.h.height,
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppImages.calendarEvent),
                                      10.w.width,
                                      Text(
                                        homeScreenProvider.getMeetingList[i].meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString(),
                                        style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      )
                                    ],
                                  ),
                                  5.h.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Container(
                                                            height: 5.h,
                                                            width: 100.w,
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
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
                                                                Icon(
                                                                  Icons.copy_outlined,
                                                                  color: Theme.of(context).primaryColorLight,
                                                                ),
                                                                10.w.width,
                                                                Icon(
                                                                  Icons.edit,
                                                                  color: Theme.of(context).primaryColorLight,
                                                                ),
                                                                10.w.width,
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Theme.of(context).primaryColorLight,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        size: 18,
                                                                        color: Theme.of(context).scaffoldBackgroundColor,
                                                                      ),
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
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xff152E3C)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(
                                                              "SCHEDULED",
                                                              style: w500_10Poppins(color: Colors.blue),
                                                            ),
                                                          ),
                                                        ),
                                                        5.h.height,
                                                        Text(
                                                          homeScreenProvider.getMeetingList[i].meetingName!,
                                                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                                                        ),
                                                        5.h.height,
                                                        Text(
                                                          homeScreenProvider.getMeetingList[i].autoGeneratedId.toString(),
                                                          style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                        ),
                                                        10.h.height,
                                                        Text(
                                                          "Host",
                                                          style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                        ),
                                                        5.h.height,
                                                        Text(
                                                          homeScreenProvider.getMeetingList[i].hostKey!,
                                                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                                                        ),
                                                        10.h.height,
                                                        Text(
                                                          "Date & Time",
                                                          style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                        ),
                                                        5.h.height,
                                                        Text(
                                                          homeScreenProvider.getMeetingList[i].meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString(),
                                                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                                                        ),
                                                        10.h.height,
                                                        Text(
                                                          "Participants",
                                                          style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                        ),
                                                        5.h.height,
                                                        Text(
                                                          "5655",
                                                          style: w400_13Poppins(color: Theme.of(context).hintColor),
                                                        ),
                                                        10.h.height,
                                                        const CustomDottedDivider(),
                                                        10.h.height,
                                                        Text(
                                                          "Passcode",
                                                          style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                                        ),
                                                        5.h.height,
                                                        Container(
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Text(
                                                                  homeScreenProvider.getMeetingList[i].meetingPassword.toString() ?? "--",
                                                                  style: w400_14Poppins(color: Colors.white),
                                                                ),
                                                              ),
                                                              const Icon(Icons.link)
                                                            ],
                                                          ),
                                                        ),
                                                        30.h.height,
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  // width: 80.w,
                                                                  height: 40.h,
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff1B2632)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Cancel",
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
                                                                onTap: () {},
                                                                child: Container(
                                                                    // width: 100.w,
                                                                    height: 40.h,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "Transfer",
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
                                                });
                                          },
                                          child: Container(
                                            // width: 80.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff1B2632)),
                                            child: Center(
                                              child: Text(
                                                "Details",
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
                                        child: Consumer<AppGlobalStateProvider>(builder: (_, appGlobalStateProvider, __) {
                                          return CustomButton(
                                            height: 40.h,
                                            buttonText: appGlobalStateProvider.isMeetingInProgress ? "In progress" : ConstantsStrings.start,
                                            onTap: () {
                                              if (appGlobalStateProvider.isMeetingInProgress) {
                                                CustomToast.showErrorToast(msg: "You are already in an another meeting.");
                                              } else {
                                                tryJoinMeeting(context, isHostJoing: true, meetingId: homeScreenProvider.getMeetingList[i].id);
                                              }
                                            },
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
        ],
      );
    });
  }
}