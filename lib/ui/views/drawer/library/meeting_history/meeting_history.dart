import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import 'library_product_meeting.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class MeetingHistory extends StatelessWidget {
  const MeetingHistory({super.key,});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, provider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: Column(
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
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: provider.finalUpdatedMeetingHistoryList.length,
                          shrinkWrap: true,
                          controller: provider.meetingHistoryScrollController,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PIPGlobalNavigation(childWidget: LibraryProductMeetingScreen(meetingData: provider.finalUpdatedMeetingHistoryList[i]))));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Theme.of(context).cardColor),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.finalUpdatedMeetingHistoryList[i].meetingName ?? "",
                                          style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                        ),
                                        height5,
                                        Row(
                                          children: [
                                            Text(
                                              provider.finalUpdatedMeetingHistoryList[i].eventId ?? "",
                                              style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                            ),
                                            width15,
                                            Text(
                                              DateFormat("MMM dd, yyyy HH:mm").format(provider.finalUpdatedMeetingHistoryList[i].meetingDate!.toLocal() ?? DateTime.now()).toString(),
                                              style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
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
        ),
      );
    });
  }
}
