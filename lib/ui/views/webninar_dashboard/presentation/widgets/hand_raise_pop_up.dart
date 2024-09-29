import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class HandRisePopUp extends StatelessWidget {
  const HandRisePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(
        builder: (_, participantsProvider, __) {
      int count = participantsProvider.speakers
          .where((element) => element.handRaise ?? false)
          .toList()
          .length;

      return Column(
        children: [
          showDialogCustomHeader(context, headerTitle: "Hand Raise"),
          Expanded(
            child: count > 0
                ? ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final userData = participantsProvider.speakers
                          .where((element) => element.handRaise ?? false)
                          .toList();
                      return Column(
                        children: [
                          _HandRisePopUpItem(
                            index: index,
                            userData: userData[index],
                          ),
                          index == count - 1
                              ? CustomButton(
                                  width: ScreenConfig.width * 0.5,
                                  buttonText: 'Lower All Hands',
                                  onTap: () {
                                    context
                                        .read<HandRaiseProvider>()
                                        .lowerHandForAll()
                                        .then(
                                            (value) => Navigator.pop(context));
                                  },
                                )
                              : const IgnorePointer(),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No Users Found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          )
        ],
      );
    });
  }
}

class _HandRisePopUpItem extends StatelessWidget {
  const _HandRisePopUpItem(
      {super.key, required this.index, required this.userData});
  final int index;
  final HubUserData userData;

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarThemesProviders, ParticipantsProvider>(
        builder: (_, webinarThemesProviders, participantsProvider, __) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 16.w),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: webinarThemesProviders.colors.bodyColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userData.displayName ?? "N/A",
              style: w400_14Poppins(
                  color: webinarThemesProviders.colors.textColor),
            ),
            IconButton(
              onPressed: () {
                context.read<HandRaiseProvider>().lowerHandForIndividual(
                    id: userData.id!, name: userData.displayName!);
              },
              icon: Icon(Icons.cancel),
            ),
          ],
        ),
      );
    });
  }
}
