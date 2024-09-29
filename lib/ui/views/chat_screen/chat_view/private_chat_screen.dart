import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_left.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_right.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/message_send_widget.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum/view_state_enum.dart';
import '../../../../core/screen_configs.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/images/images.dart';
import '../../../utils/network_image_helpers/cached_image_validation.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../meeting/providers/meeting_room_provider.dart';
import '../../themes/providers/webinar_themes_provider.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatProvider, MeetingRoomProvider, WebinarThemesProviders>(builder: (_, chatProvider, meetingRoomProvider, webinarThemesProviders, __) {
      return Column(
        children: [
          height5,
          Container(
            height: 55.h,
            width: MediaQuery.of(context).size.width - 30.sp,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: webinarThemesProviders.headerNotchColor,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                      onTap: () {
                        chatProvider.isChatLayoutChange("", false);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: webinarThemesProviders.hintTextColor,
                      )),
                ),

                Container(
                  height: 45.w,
                  width: 45.w,
                  decoration: BoxDecoration(border: Border.all(color: webinarThemesProviders.hintTextColor, width: 2.w), borderRadius: BorderRadius.all(Radius.circular(25.r))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: ImageServiceWidget(
                          networkImgUrl: chatProvider.privateChatUserInfo.profilePic.toString() ??
                              "https://de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png")),
                ),
                width10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${chatProvider.privateChatUserInfo.displayName}",
                      style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    Text(
                      "Hi this is ${chatProvider.privateChatUserInfo.displayName.toString()}",
                      style: w400_10Poppins(color: Theme.of(context).disabledColor),
                    )
                  ],
                ),
              ],
            ),
          ),
          height8,
          SizedBox(
            height: 50.h,
            width: MediaQuery.of(context).size.width - 30.sp,
            child: Padding(
              padding: EdgeInsets.symmetric( vertical: 3.h),
              child: CommonTextFormField(
                fillColor: webinarThemesProviders.headerNotchColor,
                borderColor: webinarThemesProviders.hintTextColor,
                controller: chatProvider.searchControllerForSpeakerChat,
                hintStyle: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                keyboardType: TextInputType.text,
                inputAction: TextInputAction.next,
                onChanged: (val) {
                  if (val.length > 1) {
                    debugPrint("chat search value $val");
                    chatProvider.chatSpeakerMessageFilter(val);
                  } else if (val.isEmpty || val.length < 2) {
                    chatProvider.getPrivateChatHistoryData(context, chatProvider.chatSpeakerListId.toString(), "");
                  } else {}
                },
                suffixIcon: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Icon(
                    Icons.search,
                    size: 18.sp,
                    color: webinarThemesProviders.hintTextColor,
                  ),
                ),
                hintText: ConstantsStrings.search,
              ),
            ),
          ),
          Expanded(
            child: chatProvider.listOfMessagesPrivate.isEmpty
                ? Center(
                    child: Text(
                    "No Chat Data Found...",
                    style: w400_16Poppins(color: Theme.of(context).disabledColor),
                  ))
                : ListView(
                    shrinkWrap: true,
                    controller: chatProvider.scrollController,
                    children: List.generate(
                        chatProvider.listOfMessagesPrivate.length,
                        (index) => meetingRoomProvider.userData.id.toString() != chatProvider.listOfMessagesPrivate[index].fromUserId.toString()
                            ? ChatMessageLeft(
                                messageData: chatProvider.listOfMessagesPrivate[index],
                                isQandA: false,
                              )
                            : ChatMessageRight(
                                messageData: chatProvider.listOfMessagesPrivate[index],
                                isQandA: false,
                              ))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: chatProvider.isReply
                ? Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: SizedBox(
                      height: 120.h,
                      child: Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Container(
                          decoration: BoxDecoration(color: webinarThemesProviders.colors.cardColor, borderRadius: BorderRadius.all(Radius.circular(12.r))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.reply),
                                        width10,
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Text(
                                              chatProvider.isReplyMessage.toString(),
                                              style: w400_14Poppins(
                                                color: Theme.of(context).hintColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                      ],
                                    ),
                                    MessageSendWidget(
                                      messageCommand: ChatTabDataFlag.Private,
                                      messageType: "privateChat",
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      chatProvider.resetMessage(context);
                                    },
                                    child: Icon(Icons.cancel_outlined, color: Colors.red, size: 24.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      chatProvider.fileData != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color:webinarThemesProviders.hintTextColor),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        chatProvider.fileName.toString().endsWith(".pdf")
                                            ? Padding(
                                                padding: EdgeInsets.all(5.0.sp),
                                                child: Container(
                                                    height: 100.h,
                                                    width: ScreenConfig.width,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        image: DecorationImage(image: FileImage(File(chatProvider.fileData!.path)), fit: BoxFit.fill),
                                                        color: AppColors.whiteColor),
                                                    child: SvgPicture.asset(AppImages.pollFile)),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(8.0.sp),
                                                child: Container(
                                                  height: 100.h,
                                                  width: ScreenConfig.width,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8.r),
                                                      image: DecorationImage(image: FileImage(File(chatProvider.fileData!.path)), fit: BoxFit.fill),
                                                      color: AppColors.whiteColor),
                                                ),
                                              ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () {
                                              chatProvider.resetMessage(context);
                                            },
                                            child: Icon(Icons.cancel_outlined, color: Colors.red, size: 24.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    MessageSendWidget(
                                      messageCommand: ChatTabDataFlag.Private,
                                      messageType: "privateChat",
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : MessageSendWidget(
                              messageCommand: ChatTabDataFlag.Private,
                              messageType: "privateChat",
                            ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
