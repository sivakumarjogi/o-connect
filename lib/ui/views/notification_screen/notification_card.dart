import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import '../../../core/routes/routes_name.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {required this.organizerName,
      required this.timeNZone,
      required this.dateNTime,
      required this.meetingTitle,
      required this.meetingID,
      Key? key})
      : super(key: key);

  final String organizerName;
  final String dateNTime;
  final String timeNZone;
  final String meetingTitle;
  final String meetingID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ConstantsStrings.dearUser ?? "",
                    style: w300_12Poppins(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    ConstantsStrings.hostNameText ?? "",
                    style: w300_12Poppins(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      detailsWithTag(
                          tagName: ConstantsStrings.organiser ?? "",
                          detail: organizerName,
                          context),
                      detailsWithTag(
                          tagName: ConstantsStrings.dateAndTime ?? "",
                          detail: dateNTime,
                          context),
                      detailsWithTag(
                          tagName: ConstantsStrings.timeZone ?? "",
                          detail: timeNZone,
                          context),
                    ],
                  )
                ],
              ),
            ),
            joinMeetingWithDetails(
                meetingTitle: meetingTitle, meetingId: meetingID, context),
          ],
        ),
      ),
    );
  }
}

/// Details With Tag
Widget detailsWithTag(BuildContext context,
    {required String tagName, required String detail}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        tagName,
        style: w300_10Poppins(color: Theme.of(context).disabledColor),
      ),
      const SizedBox(
        height: 5.0,
      ),
      Text(
        detail,
        style: w400_12Poppins(color: Theme.of(context).hintColor),
      ),
    ],
  );
}

/// Container
Widget joinMeetingWithDetails(BuildContext context,
    {required String meetingTitle, required String meetingId}) {
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.r),
            bottomLeft: Radius.circular(10.r))),
    child: Padding(
      padding: EdgeInsets.all(7.sp),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meetingTitle,
              style: w400_12Poppins(color: Theme.of(context).hintColor),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              meetingId,
              style: w300_10Poppins(color: Theme.of(context).disabledColor),
            )
          ],
        ),
        CustomButton(
          width: 70.w,
          buttonText: ConstantsStrings.join,
          onTap: () {
            Navigator.pushNamed(
                context, RoutesManager.lobbyScreen);
          },
        ),
      ]),
    ),
  );
}
