import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:provider/provider.dart';

import '../../themes/providers/webinar_themes_provider.dart';
import 'guest_popup.dart';
import 'presenter_antendee_popup.dart';

class ParticipantWidget extends StatelessWidget {
  final bool isGuest;

  const ParticipantWidget({super.key, required this.participant, this.isGuest = false});

  final HubUserData participant;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProviders, child) {
      return GestureDetector(
        onTap: () {
          if (isGuest) {
            final provider = context.read<ParticipantsProvider>();

            if (provider.canHandleParticipants) {
              customShowDialog(
                context,
                GuestUserPopup(guest: participant),
                height: MediaQuery.of(context).size.height * 0.6,
              );
            }
          } else {
            final provider = context.read<ParticipantsProvider>();
            final myUserId = context.read<MeetingRoomProvider>().attendee.userId;
            final myHubInfo = provider.myHubInfo;

            if (myHubInfo.isHost && myUserId != participant.id) {
              _openOptionsDialog(context);
            } else if (myHubInfo.isActiveHost && !participant.isActiveHost && !participant.isHost) {
              _openOptionsDialog(context);
            } else if (myHubInfo.isCohost && !participant.isActiveHost && !participant.isHost && !participant.isCohost) {
              _openOptionsDialog(context);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70.h,
            decoration: BoxDecoration(
              color: webinarThemesProviders.headerNotchColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 5.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (participant.profilePic != null && !participant.profilePic!.endsWith('null'))
                        Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(participant.profilePic!),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        SvgPicture.asset(
                          AppImages.allParticipants,
                          height: 50.w,
                          width: 50.w,
                          fit: BoxFit.fill,
                        ),
                      if (participant.pu ?? false)
                        Positioned(
                          left: 0,
                          top: 5.h,
                          child: SvgPicture.asset(
                            AppImages.pinUserIcon,
                            height: 20.w,
                            width: 20.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      Container(alignment: Alignment.bottomCenter, child: commonWidget(participant))
                    ],
                  ),
                  width10,
                  SizedBox(
                    width: 133.sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${participant.displayName!.toString()}...",
                          style: w400_15Poppins(color: Theme.of(context).hintColor),
                        ),
                        // SizedBox(
                        //   width: 200.sp,
                        //   child: Text(
                        //     participant.email!,
                        //     style: w400_15Poppins(color: Theme.of(context).hintColor),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 147.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        if (participant.handRaise == true)
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: Image.asset(
                              "assets/new_ui_icons/all_participants_icons/hand.png",
                              height: 24.w,
                              width: 24.w,
                            ),
                          ),
                        width5,

                        SvgPicture.network(
                            height: 16.w, width: 24.w, "https://cdn.jsdelivr.net/gh/hampusborgos/country-flags@main/svg/${participant.countryFlag.toString().toLowerCase() ?? "in"}.svg"),

                        if (participant.isAudioEnabled == true && isGuest == false)
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: SvgPicture.asset(
                              "assets/new_ui_icons/all_participants_icons/global_mic_off.svg",
                              height: 24.w,
                              width: 24.w,
                            ),
                          ),
                        if (participant.isVideoEnabled == true && isGuest == false)
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: SvgPicture.asset(
                              "assets/new_ui_icons/all_participants_icons/global_video_off.svg",
                              height: 24.w,
                              width: 24.w,
                            ),
                          ),

                        participant.isHost
                            ? const SizedBox.shrink()
                            : Icon(
                                Icons.more_vert_rounded,
                                color: webinarThemesProviders.hintTextColor,
                              )

                        // Icon(
                        //   participant.isAudioEnabled == true ? Icons.mic : Icons.mic_off,
                        //   color: AppColors.appmainThemeColor,
                        //   size: 16.sp,
                        // ),
                        // width5,
                        // Icon(
                        //   participant.isVideoEnabled == true ? Icons.videocam : Icons.videocam_off,
                        //   color: AppColors.appmainThemeColor,
                        //   size: 16.sp,
                        // ),
                        // width5,
                        // Icon(
                        //   Icons.comments_disabled,
                        //   color: AppColors.appmainThemeColor,
                        //   size: 16.sp,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _openOptionsDialog(BuildContext context) {
    customShowDialog(
      context,
      AllParticipantsPopUp(userId: participant.id!),
      height: MediaQuery.of(context).size.height * 0.6,
    );
  }

  Widget commonWidget(HubUserData user) {
    if (user.isHost) {
      return customUserBadge("H", Colors.deepPurpleAccent);
    }
    if (user.isActiveHost) {
      return customUserBadge("AH", Colors.deepOrangeAccent);
    }
    if (user.isCohost) {
      return customUserBadge("CH", Colors.grey);
    }

    switch (user.role) {
      case "user":
        return customUserBadge("U", Colors.green);
      default:
        return Container();
    }
  }

  Widget customUserBadge(String text, Color color) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
          child: Text(
        text,
        style: w300_10Poppins(color: Colors.white),
      )),
    );
  }
}
