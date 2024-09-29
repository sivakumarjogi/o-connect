import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../utils/close_widget.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class BlockedUser extends StatefulWidget {
  const BlockedUser({super.key});

  @override
  State<BlockedUser> createState() => _BlockedUserState();
}

class _BlockedUserState extends State<BlockedUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(builder: (_, provider, child) {
      return provider.tempBlockedUsers.isEmpty
          ? const Center(
              child: Text("No Blocked Users..."),
            )
          : Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      height10,
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.tempBlockedUsers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            final blockedUser = provider.tempBlockedUsers[i];

                            return
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: context.read<WebinarThemesProviders>().headerNotchColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0.w,vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2.w, color: Colors.white),
                                            borderRadius: BorderRadius.circular(64.r),
                                          ),
                                          // child: Image.asset(
                                          //   getAllBlockedUsers[i].userImage!
                                          //       ? AppImages.imageIcon
                                          //       : AppImages.groups,
                                          //   fit: BoxFit.fill,
                                          // ),

                                          child: SizedBox(height: 40.w, width: 40.w, child: ImageServiceWidget(imageBorderRadius: 64.r, networkImgUrl: blockedUser.profilePic)),
                                        ),
                                        width20,
                                        SizedBox(
                                          width: ScreenConfig.width * 0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                blockedUser.displayName ?? "",
                                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                blockedUser.email ?? "",
                                                style: w300_12Poppins(color: Theme.of(context).hintColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      SvgPicture.asset("assets/new_ui_icons/all_participants_icons/block_user.svg"),
                                      if (provider.canHandleParticipants)
                                        InkWell(
                                          onTap: (){
                                            provider.toggleTempBlockStatus(
                                              id: blockedUser.id!,
                                              ri: blockedUser.roomId,
                                              peerId: blockedUser.peerId,
                                            );
                                            // Navigator.of(context).pop();
                                          },
                                          child: Text("Unblock",style: w400_14Poppins(color: Colors.blue),),
                                        ),

                                        // CustomButton(
                                        //   width: 80.w,
                                        //   height: 40.h,
                                        //   buttonColor: AppColors.mainBlueColor,
                                        //   buttonText: ConstantsStrings.unblock,
                                        //   buttonTextStyle: w400_14Poppins(color: AppColors.whiteColor),
                                        //   onTap: () {
                                        //
                                        //   },
                                        // )
                                    ],
                                  ),
                                ),
                              );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // const CloseWidget()
              ],
            );
    });
  }
}
