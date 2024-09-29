import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library/meeting_history/library_product_meeting.dart';
import 'package:o_connect/ui/views/more/archive_files_screen.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

class ArchiveHistory extends StatelessWidget {
  const ArchiveHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          provider.isMeetingHistoryFirstLoadRunning
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Lottie.asset(AppImages.loadingJson, height: 70.h, width: 100.w),
                  ),
                )
              : provider.finalUpdatedMeetingHistoryList.isNotEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: provider.finalUpdatedMeetingHistoryList.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        provider.finalUpdatedMeetingHistoryList[i].meetingName ?? "",
                                      ),
                                      height10,
                                      Text(
                                        provider.finalUpdatedMeetingHistoryList[i].eventId ?? "",
                                        style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                      ),
                                      height10,
                                      Row(
                                        children: [
                                          SizedBox(width: 20.w, child: SvgPicture.asset(AppImages.archivePersonIcon)),
                                          width5,
                                          Text(
                                            provider.finalUpdatedMeetingHistoryList[i].meetingType.toString(),
                                            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                          )
                                        ],
                                      ),
                                      height5,
                                      Row(
                                        children: [
                                          SizedBox(width: 20.w, child: SvgPicture.asset(AppImages.archiveCalendarIcon)),
                                          width5,
                                          Text(
                                            DateFormat("dd MMM, yyyy, HH:mm").format(provider.finalUpdatedMeetingHistoryList[i].meetingDate!.toLocal() ?? DateTime.now()).toString(),
                                            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                          )
                                        ],
                                      ),
                                      height5,
                                      Row(
                                        children: [
                                          SizedBox(width: 20.w, child: SvgPicture.asset(AppImages.archiveClockIcon)),
                                          width5,
                                          Text(
                                            " ${provider.finalUpdatedMeetingHistoryList[i].duration.toString()}hr" ?? "",
                                            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                          )
                                        ],
                                      ),
                                      height15,
                                      CustomButton(
                                        buttonText: "View Files",
                                        buttonColor: const Color(0xff0E78F9),
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const ArchiveFilesScreen()));
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => PIPGlobalNavigation(childWidget: ArchiveFilesScreen(meetingData: provider.finalUpdatedMeetingHistoryList[i]))));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text(
                          "No Records Found",
                          style: w400_15Poppins(color: Theme.of(context).hintColor),
                        ),
                      )),

          // when the loadMore function is running
          if (provider.isMeetingHistoryLoadMoreRunning == true)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)),
            ),
          // When nothing else to load
          /* if (provider.hasMeetingHistoryNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 5),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ),*/
        ],
      );
    });
  }
}
