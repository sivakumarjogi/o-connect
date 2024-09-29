import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/participants/widgets/guest_popup.dart';
import 'package:o_connect/ui/views/participants/widgets/participant_widget.dart';
import 'package:provider/provider.dart';

import '../../../utils/countrie_flags.dart';
import '../../themes/providers/webinar_themes_provider.dart';
import 'speakers_list.dart';

class GuestListWidget extends StatelessWidget {
  const GuestListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(builder: (context, participantsProvider, __) {
      print("participantsProvider ${participantsProvider.filteredGuests.length}");
      return participantsProvider.filteredGuests.isEmpty
          ? Center(
              child: Text(
                'No users found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            )
          : ListView.builder(
              itemCount: participantsProvider.filteredGuests.length,
              itemBuilder: ((context, index) {
                return SizedBox(width: MediaQuery.of(context).size.width, child: ParticipantWidget(participant: participantsProvider.filteredGuests[index], isGuest: true));
              }));
    });

    //   ParticipantsGrid(
    //   getItems: (provider) => provider.filteredGuests,
    //   itemBuilder: (provider, item) {
    //     return _GuestListItemView(guestUser: item);
    //   },
    // );
  }
}

class _GuestListItemView extends StatelessWidget {
  const _GuestListItemView({required this.guestUser});

  final HubUserData guestUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider = context.read<ParticipantsProvider>();

        if (provider.canHandleParticipants) {
          customShowDialog(
            context,
            GuestUserPopup(guest: guestUser),
            height: MediaQuery.of(context).size.height * 0.6,
          );
        }
      },
      child: Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProviders, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: webinarThemesProviders.colors.itemColor, borderRadius: BorderRadius.circular(8.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: Row(
              children: [
                CircleAvatar(
                  child: Stack(
                    children: [
                      if (guestUser.profilePic?.isNotEmpty == true)
                        Container(
                          height: 45.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(guestUser.profilePic!),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        SvgPicture.asset(
                          AppImages.allParticipants,
                          height: 40.w,
                          width: 40.w,
                          fit: BoxFit.fill,
                        ),
                      Align(alignment: Alignment.bottomCenter, child: Countries(countriesFlag: guestUser.countryFlag))
                    ],
                  ),
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${guestUser.displayName}',
                                style: w400_15Poppins(color: Theme.of(context).hintColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).disabledColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Make Speaker",
                                style: w300_10Poppins(color: Theme.of(context).disabledColor),
                              ),
                            ),
                          )
                          // Text(
                          //   "😀",
                          //   style: w400_12Poppins(),
                          // ),
                          // SizedBox(
                          //   width: 4.w,
                          // ),
                          // width5,
                          // Icon(
                          //   Icons.comments_disabled,
                          //   color: AppColors.appmainThemeColor,
                          //   size: 16.sp,
                          // ),
                        ],
                      ),
                      height5
                    ],
                  ),
                ),
                Icon(Icons.more_vert_rounded, color: Theme.of(context).disabledColor)
              ],
            ),
          ),
        );
      }),
    );
  }
}
