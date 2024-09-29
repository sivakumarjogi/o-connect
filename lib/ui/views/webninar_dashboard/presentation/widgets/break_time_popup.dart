import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../meeting/providers/meeting_room_provider.dart';
import '../../../themes/providers/webinar_themes_provider.dart';

class BreakTimePopup extends StatefulWidget {
  const BreakTimePopup({super.key});

  @override
  State<BreakTimePopup> createState() => _BreakTimePopupState();
}

class _BreakTimePopupState extends State<BreakTimePopup> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MeetingRoomProvider>().breakTimeHelper.resetBreaktimeCount());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MeetingRoomProvider, WebinarThemesProviders>(builder: (context, meetingRoomProvider, webinarThemesProviders, __) {
      return Scaffold(
        backgroundColor: webinarThemesProviders.colors.bodyColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showDialogCustomHeader(context, headerTitle: "Break Time"),
            Container(
              color: webinarThemesProviders.colors.bodyColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "Set break time in mins",
                      style: w400_12Poppins(color: const Color(0xFFAEB5E3)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: Container(
                      decoration: BoxDecoration(color: webinarThemesProviders.colors.itemColor, borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(meetingRoomProvider.breakTimeHelper.breakTimeCout.toString()),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => meetingRoomProvider.breakTimeHelper.incrementBreakTime(),
                                  child: const Icon(Icons.keyboard_arrow_up, size: 20),
                                ),
                                GestureDetector(
                                  onTap: () => meetingRoomProvider.breakTimeHelper.decrementBreakTime(),
                                  child: const Icon(Icons.keyboard_arrow_down, size: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      CustomButton(
                        buttonText: "Cancel",
                        buttonColor: Colors.transparent,
                        borderColor: webinarThemesProviders.colors.buttonColor,
                        buttonTextStyle: w600_14Poppins(color: Colors.white),
                        width: 85.w,
                        height: 32.h,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      width15,
                      CustomButton(
                        buttonText: "Set Time",
                        width: 85.w,
                        height: 32.h,
                        buttonColor: webinarThemesProviders.colors.buttonColor,
                        buttonTextStyle: w600_14Poppins(color: Colors.white),
                        onTap: () {
                          Navigator.of(context).pop();
                          meetingRoomProvider.breakTimeHelper.setBreakTime(context,setTimeStatus: ConstantsStrings.setTime);
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class CustomCountdown extends AnimatedWidget {
  CustomCountdown({Key? key, required this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: TextStyle(
        fontSize: 110,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
