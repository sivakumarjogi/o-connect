import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../meeting/model/user_role.dart';
import '../../providers/chat_provider.dart';

class MessageSendWidget extends StatelessWidget with MeetingUtilsMixin {
  MessageSendWidget({
    super.key,
    required this.messageType,
    required this.messageCommand,
  });

  final String messageType;
  final ChatTabDataFlag messageCommand;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      var userRole = context.read<MeetingRoomProvider>().attendee;
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        height: 50.h,
        decoration: BoxDecoration(
          color: context.watch<WebinarThemesProviders>().headerNotchColor,
          border: Border.all(color: context.watch<WebinarThemesProviders>().headerNotchColor),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            width5,
            Visibility(
              visible: messageCommand == ChatTabDataFlag.QA ? false : true,
              child: userRole.roleType.toString() != "Host"
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        chatProvider.fileUpload(context);
                      },
                      child: Transform.rotate(
                          angle: 120.0,
                          child: Icon(
                            Icons.attach_file_outlined,
                            size: 24.sp,
                            color: context.watch<WebinarThemesProviders>().hintTextColor,
                          )),
                    ),
            ),
            width5,
            Expanded(
              child: TextField(
                controller: chatProvider.textController,
                style: w400_14Poppins(color: Theme.of(context).hintColor),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ConstantsStrings.enterYourText,
                    hintStyle: w400_14Poppins(color: context.watch<WebinarThemesProviders>().hintTextColor),
                    helperStyle: w400_14Poppins(color: context.watch<WebinarThemesProviders>().hintTextColor)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: GestureDetector(
                  onLongPress: () {
                    chatProvider.startListening();
                  },
                  onLongPressEnd: (data) {
                    chatProvider.stopListening();
                    FocusScope.of(context).unfocus();
                  },
                  onTap: () {
                    chatProvider.startListening();
                    FocusScope.of(context).unfocus();
                  },
                  onSecondaryTap: () {
                    chatProvider.stopListening();
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(
                    chatProvider.speechIconActive ? Icons.mic : Icons.mic_off,
                    color: context.watch<WebinarThemesProviders>().hintTextColor,
                    size: 24.sp,
                  )),
            ),
            (myRole == UserRole.speaker || myRole == UserRole.guest)
                ? const SizedBox.shrink()
                : ((messageCommand == ChatTabDataFlag.Group && chatProvider.listOfMessages.isEmpty))
                    ? const SizedBox.shrink()
                    : (messageCommand == ChatTabDataFlag.Private && chatProvider.listOfMessagesPrivate.isEmpty)
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: InkWell(
                                onTap: () {
                                  chatProvider.saveChatTemplate(messageType);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(
                                  Icons.save_outlined,
                                  color: context.watch<WebinarThemesProviders>().hintTextColor,
                                  size: 24.sp,
                                )),
                          ),
            Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: InkWell(
                  onTap: () {
                    if (chatProvider.textController.text.isEmpty && chatProvider.fileName!.isNotEmpty) {
                      chatProvider.messageHitMethod(
                        messageCommand,
                        context,
                        messageType,
                      );
                    } else if (chatProvider.textController.text.isEmpty) {
                    } else {
                      chatProvider.messageHitMethod(
                        messageCommand,
                        context,
                        messageType,
                      );
                    }
                    // FocusScope.of(context).unfocus();
                  },
                  child: SvgPicture.asset(
                    "assets/new_ui_icons/chat_icons/chat_send.svg",
                    height: 40.w,
                    width: 40.w,
                  ),

                  // Container(
                  //               height: 35.w,
                  //               width: 35.w,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.all(
                  //                     Radius.circular(5.r),
                  //                   ),
                  //                   color: context.watch<WebinarThemesProviders>().colors.buttonColor),
                  //               child: Center(
                  //                 child: Transform.rotate(angle: -3.14 / 3.8, alignment: Alignment.center, child: const Icon(Icons.send_rounded)),
                  //               ),
                  //             )
                )),
          ],
        ),
      );
    });
  }
}
