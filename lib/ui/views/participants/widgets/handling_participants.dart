import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class HandlingParticipants extends StatelessWidget with MeetingUtilsMixin {
  HandlingParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(builder: (context, allParticipant, child) {
      final canEditGlobalAccess = allParticipant.canEditGlobalAccess;

      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: context.read<WebinarThemesProviders>().headerNotchColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: !canEditGlobalAccess
                    ? null
                    : () {
                        allParticipant.toggleGlobalAudio();
                      },
                child: allParticipant.globalMicOn
                    ? SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_mic_off.svg")
                    : SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_mic_on.svg")),
            GestureDetector(
                onTap: !canEditGlobalAccess
                    ? null
                    : () {
                        allParticipant.toggleGlobalVideo();
                      },
                child: allParticipant.globalVideoOn
                    ? SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_video_off.svg")
                    : SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_video_on.svg")),
            GestureDetector(
                onTap: !canEditGlobalAccess
                    ? null
                    : () {
                        allParticipant.toggleGlobalChat();
                      },
                child: allParticipant.globalChatOn
                    ? SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_chat_off.svg")
                    : SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_chat_on.svg")),
            GestureDetector(
                onTap: !canEditGlobalAccess
                    ? null
                    : () {
                        allParticipant.toggleGlobalEmoji();
                      },
                child: allParticipant.globalEmojiOn
                    ? SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_emoji_off.svg")
                    : SvgPicture.asset("assets/new_ui_icons/all_participants_icons/global_emoji_on.svg")),
            // GestureDetector(
            //     onTap: () {
            //       allParticipant.changeHandStatus();
            //     },
            //     child: allParticipant.isHand
            //         ? SvgPicture.asset(AppImages.handRaiseVariant)
            //         : SvgPicture.asset(
            //             AppImages.handRaiseVariant_off,
            //           )),
            if (meeting.meetingType == "webinar")
              GestureDetector(
                child: SvgPicture.asset(
                    (allParticipant.isSpeakerRequest) ? "assets/new_ui_icons/all_participants_icons/global_blockuser_on.svg" : "assets/new_ui_icons/all_participants_icons/global_blockuser_off.svg"),
                onTap: () {
                  allParticipant.speakerRequest(!allParticipant.isSpeakerRequest);
                },
              )
          ],
        ),
      );
    });
  }
}
