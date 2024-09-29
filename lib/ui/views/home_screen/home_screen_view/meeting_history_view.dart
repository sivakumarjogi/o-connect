import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/drawer/library/library.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/library_provider.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../drawer/library/meeting_history/library_product_meeting.dart';

class MeetingsHistory extends StatelessWidget {
  const MeetingsHistory({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, libraryProvider, child) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Text(
                ConstantsStrings.meetingHistory,
                style: w500_15Poppins(color: Theme.of(context).hintColor),
              ),
            ),
            libraryProvider.isMeetingHistoryFirstLoadRunning
                ? Center(
                    child: SizedBox(
                    height: 50.w,
                    width: 50.w,
                    child: Lottie.asset(AppImages.loadingJson),
                  ))
                : libraryProvider.finalUpdatedMeetingHistoryList.isEmpty
                    ? Center(
                        child: Text(
                          "No Record Found",
                          style: w500_18Poppins(color: Theme.of(context).primaryColorLight),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: libraryProvider.finalUpdatedMeetingHistoryList.length > 5 ? 5 : libraryProvider.finalUpdatedMeetingHistoryList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 8.w, right: 8.w),
                            child: Container(
                              height: 62.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColor),
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8.w, right: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            libraryProvider.finalUpdatedMeetingHistoryList[index].meetingName.toString(),
                                            style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                                          ),
                                          height5,
                                          Text(
                                            DateFormat('dd MMM, yyyy').format(libraryProvider.finalUpdatedMeetingHistoryList[index].meetingDate!.toLocal()).toString(),
                                            style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    height10,
                                    CustomButton(
                                      onTap: () {
                                        // CustomToast.showInfoToast(
                                        //     msg: "coming soon...");
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PIPGlobalNavigation(childWidget: LibraryProductMeetingScreen(meetingData: libraryProvider.finalUpdatedMeetingHistoryList[index]))));
                                      },
                                      buttonColor: Theme.of(context).primaryColor,
                                      borderColor: Colors.blue,
                                      width: 80.w,
                                      buttonText: ConstantsStrings.view,
                                      buttonTextStyle: w500_14Poppins(color: AppColors.mainBlueColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
            height5,
          ],
        ),
      );
    });
  }
}
