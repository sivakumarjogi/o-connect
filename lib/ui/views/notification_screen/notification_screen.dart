import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/notification_screen/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showDialogCustomHeader(context,
              headerTitle: ConstantsStrings.allNotifications),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const NotificationCard(
                    organizerName: "XYZ" ?? "",
                    timeNZone: "XYZ" ?? "",
                    dateNTime: "XYZ" ?? "",
                    meetingID: "1234567890" ?? "",
                    meetingTitle: "O-Connect daily standup meeting" ?? "",
                  );
                },
              ),
            ),
          ),
          const CloseWidget()
        ],
      ),
    );
  }
}
