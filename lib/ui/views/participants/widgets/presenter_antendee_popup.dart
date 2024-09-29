import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/chat_screen.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import 'block_user_dialog.dart';
import 'user_widget_presenter.dart';

class AllParticipantsPopUp extends StatelessWidget with MeetingUtilsMixin {
   AllParticipantsPopUp({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider, WebinarThemesProviders>(builder: (_, provider, webinarThemesProviders, __) {
      var participants = provider.speakers.where((element) => element.id == userId);
      if (participants.isEmpty) {
        Navigator.of(context).pop();
        return const SizedBox();
      }

      final participant = participants.first;
      final actions = getParticipantActions(participant, provider);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              height10,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.h,
                  width: 50.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: webinarThemesProviders.headerNotchColor),
                ),
              ),
              height10,
              UserWidgetInPresenterAndAntendeePopup(
                profilePic: participant.profilePic ?? '',
                displayName: participant.displayName ?? '',
                country: participant.country ?? '',
                countryFlag: participant.countryFlag ?? '',
                email: '',
              ),
              height20,
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: actions.length,
                  itemBuilder: (_, index) {
                    return( meeting.meetingType == "conference" && actions[index].name == "Make Attendee")?const SizedBox.shrink(): InkWell(
                      onTap: () {
                        final provider = context.read<ParticipantsProvider>();
                        final action = actions[index];

                        if (action.name == ConstantsStrings.host || action.name == ConstantsStrings.removeHost) {
                          provider.toggleHostStatus(participant);
                          Navigator.of(context).pop();
                        } else if (action.name == ConstantsStrings.makeCoHost || action.name == ConstantsStrings.removeCoHost) {
                          provider.toggleCoHostStatus(participant, action);
                          Navigator.of(context).pop();
                        } else if (action.name == ConstantsStrings.makeAttendee) {
                          provider.makeAttendee(participant);
                          Navigator.of(context).pop();
                        } else if (action.name == ConstantsStrings.presenter) {
                          provider.makeSpeaker(participant.id!);
                        } else if (action.name == ConstantsStrings.pinAttendee || action.name == ConstantsStrings.unpinAttendee) {
                          provider.togglePinnedStatus(participant);
                          Navigator.of(context).pop();
                        }
                        // else if (action.name == ConstantsStrings.privateChat) {
                        //   Navigator.of(context).pop();
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const ChatScreen(isFromQAndAScreen: false),
                        //       ));
                        // }
                        else if (action.name == ConstantsStrings.block) {
                          // provider.blockUser(
                          //   id: participant.id!,
                          //   activeHost: participant.isActiveHost,
                          //   ri: participant.roomId,
                          // );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BlockUserDialog(
                                onTemporaryBlock: () => provider.toggleTempBlockStatus(
                                  id: participant.id!,
                                  ri: participant.roomId,
                                  peerId: participant.peerId,
                                ),
                                onPermanentBlock: () => provider.blockUser(
                                  id: participant.id!,
                                  activeHost: participant.isActiveHost,
                                  ri: participant.roomId,
                                ),
                                isTempBlock: true,
                              );
                            },
                          ).then((value) {
                            if (value == true) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else if (action.name == ConstantsStrings.removeFromMeeting) {
                          provider.removeParticipant(participant.id!, participant.roomId);
                          Navigator.of(context).pop();
                        } else if (action.name == ConstantsStrings.videoOn || action.name == ConstantsStrings.videoOff) {
                          provider.toggleVideo(participant);
                        } else if (action.name == ConstantsStrings.mute || action.name == ConstantsStrings.unMute) {
                          provider.toggleAudio(participant);
                        } else if (action.name == ConstantsStrings.terminate) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BlockUserDialog(
                                onTemporaryBlock: () => provider.toggleTempBlockStatus(
                                  id: participant.id!,
                                  ri: participant.roomId,
                                  peerId: participant.peerId,
                                ),
                                onPermanentBlock: () => provider.blockUser(
                                  id: participant.id!,
                                  activeHost: participant.isActiveHost,
                                  ri: participant.roomId,
                                ),
                                isTempBlock: false,
                              );
                            },
                          ).then((value) {
                            if (value == true) {
                              Navigator.of(context).pop();
                            }
                          });
                          // provider.blockUser(
                          //   id: participant.id!,
                          //   activeHost: participant.isActiveHost,
                          //   ri: participant.roomId,
                          // );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.0.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(actions[index].imagePath, height: 24.w, width: 24.w, color: webinarThemesProviders.hintTextColor),
                            width20,
                            Text(
                              actions[index].name,
                              style: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.transparent,
                    );
                  },
                ),
              )
            ]),
          ),
          height20,
          const CloseWidget()
        ],
      );
    });
  }
}

class AllParticipantsModel {
  AllParticipantsModel({required this.name, required this.imagePath});

  final String name;
  final String imagePath;
}

List<AllParticipantsModel> getParticipantActions(HubUserData user, ParticipantsProvider provider) => [
      if (provider.myRole == UserRole.host && (!provider.hasActiveHost || user.isActiveHost))
        AllParticipantsModel(
          name: user.activeHost == true ? ConstantsStrings.removeHost : ConstantsStrings.host,
          imagePath: "assets/new_ui_icons/all_participants_icons/make_active_host.svg",
        ),
      if (user.activeHost == false) ...[
        if (!provider.hasReachedMaxCohostLimit && !provider.myHubInfo.isCohost)
          AllParticipantsModel(
            name: user.makeCohost == true ? ConstantsStrings.removeCoHost : ConstantsStrings.makeCoHost,
            imagePath: "assets/new_ui_icons/all_participants_icons/make_co_host.svg",
          ),
        if (user.makeCohost == false) ...[
          AllParticipantsModel(name: ConstantsStrings.makeAttendee, imagePath: "assets/new_ui_icons/all_participants_icons/make_attendee.svg"),

          AllParticipantsModel(
            name: user.pu == true ? ConstantsStrings.unpinAttendee : ConstantsStrings.pinAttendee,
            imagePath: user.pu == true ? "assets/new_ui_icons/all_participants_icons/unpin.svg" : "assets/new_ui_icons/all_participants_icons/pin.svg",
          ),
          // AllParticipantsModel(name: ConstantsStrings.privateChat, imagePath: "assets/new_ui_icons/all_participants_icons/private_chat.svg"),

          // if (user.isAudioEnabled == true)
          //   AllParticipantsModel(name: ConstantsStrings.mute, imagePath: AppImages.mic_off)
          // else
          //   AllParticipantsModel(name: ConstantsStrings.unMute, imagePath: AppImages.mic_icon),
          // if (user.isVideoEnabled == true)
          //   AllParticipantsModel(name: ConstantsStrings.videoOff, imagePath: AppImages.video_off)
          // else
          //   AllParticipantsModel(name: ConstantsStrings.videoOn, imagePath: AppImages.video),
        ],
        AllParticipantsModel(name: ConstantsStrings.block, imagePath: "assets/new_ui_icons/all_participants_icons/block.svg"),
      ],
      AllParticipantsModel(name: ConstantsStrings.removeFromMeeting, imagePath: AppImages.cross),
      AllParticipantsModel(name: ConstantsStrings.terminate, imagePath: "assets/new_ui_icons/all_participants_icons/block_user.svg"),
    ];
