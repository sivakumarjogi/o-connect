import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/participants/widgets/presenter_antendee_popup.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import 'block_user_dialog.dart';
import 'user_widget_presenter.dart';

class GuestUserPopup extends StatelessWidget {
  const GuestUserPopup({super.key, required this.guest});

  final HubUserData guest;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider,WebinarThemesProviders>(builder: (_, provider,webinarThemesProviders, __) {
      var participants = provider.guests.where((element) => element.id == guest.id);
      if (participants.isEmpty) return const SizedBox();

      final participant = participants.first;
      final actions = [
        AllParticipantsModel(
          name: ConstantsStrings.makeSpeaker,
          imagePath: AppImages.attendee,
        ),
        AllParticipantsModel(
          name: ConstantsStrings.blockAttendee,
          imagePath: AppImages.blocked_participant,
        ),
        AllParticipantsModel(
          name: ConstantsStrings.removeAttendee,
          imagePath: AppImages.cross,
        ),
      ];

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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: webinarThemesProviders.headerNotchColor ),
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
                    return InkWell(
                      onTap: () {
                        final action = actions[index];

                        if (action.name == ConstantsStrings.makeSpeaker) {
                          Navigator.of(context).pop();
                          context.read<ParticipantsProvider>().makeSpeaker(participant.id!);
                        } else if (action.name == ConstantsStrings.blockAttendee) {
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
                                  ri: participant.roomId,
                                  activeHost: false,
                                ),
                              );
                            },
                          ).then((value) {
                            if (value == true) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else if (action.name == ConstantsStrings.removeAttendee) {
                          Navigator.of(context).pop();

                          context.read<ParticipantsProvider>().removeParticipant(participant.id!, participant.roomId);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 4.0.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(actions[index].imagePath, height: 24.w, width: 24.w, color: Theme.of(context).hintColor),
                            width20,
                            Text(
                              actions[index].name,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color:Colors.transparent,
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
