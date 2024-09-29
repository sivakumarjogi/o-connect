import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_timer_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class MeetingCountdownTimerWidget extends StatelessWidget {
  const MeetingCountdownTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
      return Container(
        width: 90.w,
        height: 25.h,
        margin: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          // color: webinarThemesProviders.colors.itemColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // width5,
            // Image.asset(
            //   AppImages.timerIcon,
            //   color: webinarThemesProviders.colors.textColor,
            // ),
            width5,
            Consumer<MeetingTimerProvider>(
              builder: (_, provider, __) {
                return Text(
                  provider.timerText,
                  style: w400_12Poppins(color: webinarThemesProviders.colors.textColor),
                );
              },
            ),
            width5,
          ],
        ),
      );
    });
  }
}
