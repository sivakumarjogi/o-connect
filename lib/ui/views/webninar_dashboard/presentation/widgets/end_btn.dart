import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../meeting/providers/video_share_provider.dart';

class EndMeetingButton extends StatelessWidget {
  const EndMeetingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider, HomeScreenProvider>(
        builder: (_, pro, homeScreenProvider, __) {
      if (pro.speakers.isEmpty) return const SizedBox.shrink();

      return InkWell(
        onTap: () {
          endMeeting(context);
        },
        child: Container(
          width: 70.w,
          height: 35.h,
          decoration: BoxDecoration(
            color: AppColors.orangeRedColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
                pro.canEndMeeting
                    ? ConstantsStrings.end
                    : ConstantsStrings.leave,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: poppins)
                //w600_14Poppins(color: Colors.white),
                ),
          ),
        ),
      );
    });
  }

  static void endMeeting(BuildContext context) async {
    context.read<VideoShareProvider>().speakerRequestedList = [];
    var myHubInfo = context.read<ParticipantsProvider>().myHubInfo;
    var homeScreenProvider = context.read<HomeScreenProvider>();
    final hostOrActiveHost = myHubInfo.isHostOrActiveHost;
    final bool confirmed = await customShowDialog(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                hostOrActiveHost
                    ? 'Are you sure you want to end the event?'
                    : 'Do you want to leave this event?',
              ),
              Consumer<WebinarThemesProviders>(
                  builder: (___, webinarThemesProviders, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      buttonText: 'No',
                      onTap: () => Navigator.of(context).pop(false),
                      buttonColor: Colors.transparent,
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                      borderColor: Theme.of(context).primaryColor,
                      width: ScreenConfig.width * 0.4,
                    ),
                    CustomButton(
                      buttonText: 'Yes',
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                      buttonColor: webinarThemesProviders.colors.buttonColor,
                      onTap: () => Navigator.of(context).pop(true),
                      width: ScreenConfig.width * 0.4,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.2);
    // final confirmed = await ConfirmationDialog.showConfirmationDialog(
    //   context,
    //   hostOrActiveHost
    //       ? 'Are you sure you want to end the event?'
    //       : 'Do you want to leave this event?',
    //   cancelText: 'No',
    //   okText: 'Yes',
    // );

    if (!confirmed) return;
    if (context.mounted) {
      context.read<VideoShareProvider>().stopVideoShare();

      context.read<MeetingRoomProvider>().leaveMeeting().then((value) {
        //  homeScreenProvider.getMeetings(context, searchHistory: "").then((value) =>  Navigator.of(context).pop());

        context.read<HomeScreenProvider>().getMeetings(
              context,
              selectedValue: "upcoming",
              searchHistory: "",
            );
        Navigator.of(context).pop();
      });
    }
  }
}
