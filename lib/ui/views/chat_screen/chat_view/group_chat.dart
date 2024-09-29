import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_left.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_right.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/message_send_widget.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/screen_configs.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../providers/chat_provider.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController searchController = TextEditingController();
  ChatProvider? chatProvider;
  late ScrollController mainScrollController;

  @override
  void initState() {
    mainScrollController = ScrollController();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider!.clearData();
    chatProvider!.listOfMessages = [];
    searchController.clear();
    chatProvider!.scrollController = ScrollController();
    chatProvider!.getChatHistoryData(context, "groupChat");
    // chatProvider!.getGroupChatCount = 0;
    chatProvider!.chatTabDataFlag = ChatTabDataFlag.Group;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ChatProvider, MeetingRoomProvider, WebinarThemesProviders, ParticipantsProvider>(
        builder: (context, chatProvider, meetingRoomProvider, webinarThemesProviders, participantsProvider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Stack(
          children: [
            webinarThemesProviders.selectedWebinarTheme?.chatUrl != null
                ? SizedBox(
                    width: ScreenConfig.width,
                    height: ScreenConfig.height,
                    child: Lottie.network(webinarThemesProviders.selectedWebinarTheme!.chatUrl.toString()),
                  )
                : const SizedBox.shrink(),
            chatProvider.isGroupChat
                ? Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))
                : Column(
                    children: [
                      height8,
                      SizedBox(
                        height: 50.h,
                        child: CommonTextFormField(
                          fillColor: webinarThemesProviders.headerNotchColor,
                          controller: searchController,
                          hintStyle: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          onChanged: (val) {
                            if (val.length > 1) {
                              debugPrint("chat search value $val");
                              chatProvider.chatMessageFilter(val);
                            } else if (val.isEmpty || val.length < 2) {
                              chatProvider.getChatHistoryData(context, "groupChat");
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
                      Expanded(
                        // height: chatProvider.isReply ? MediaQuery.of(context).size.height * 0.72 - 120.h : MediaQuery.of(context).size.height * 0.72 - 50.h,
                        child: chatProvider.listOfMessages.isEmpty
                            ? Center(
                                child: Text(
                                "No Chat Data Found...",
                                style: w400_16Poppins(color: Theme.of(context).disabledColor),
                              ))
                            : SizedBox(
                                height: chatProvider.isReply ? MediaQuery.of(context).size.height * 0.75 - 120.h : MediaQuery.of(context).size.height * 0.75 - 50.h,
                                child: ListView(
                                    shrinkWrap: true,
                                    controller: chatProvider.scrollController,
                                    children: List.generate(
                                        chatProvider.listOfMessages.length,
                                        (index) => meetingRoomProvider.userData.id.toString() != chatProvider.listOfMessages[index].fromUserId.toString()
                                            ? ChatMessageLeft(
                                                messageData: chatProvider.listOfMessages[index],
                                                isQandA: false,
                                              )
                                            : ChatMessageRight(
                                                messageData: chatProvider.listOfMessages[index],
                                                isQandA: false,
                                              ))),
                              ),
                      ),
                      chatProvider.isReply
                          ? Container(
                              height: 125.h,
                              decoration: BoxDecoration(color: webinarThemesProviders.hintTextColor, borderRadius: BorderRadius.all(Radius.circular(12.r))),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5.0.sp),
                                        child: chatProvider.fileData == null
                                            ? Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.reply),
                                                  width10,
                                                  SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.7,
                                                      child: Text(
                                                        chatProvider.isReplyMessage.toString() ?? "hello",
                                                        style: w400_14Poppins(
                                                          color: Colors.white,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ))
                                                ],
                                              )
                                            : Container(
                                                height: 100.h,
                                                width: ScreenConfig.width,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    image: DecorationImage(image: FileImage(File(chatProvider.fileData!.path)), fit: BoxFit.fill),
                                                    color: Colors.white),
                                              ),
                                      ),
                                     const Spacer(),
                                      MessageSendWidget(
                                        messageCommand: ChatTabDataFlag.Group,
                                        messageType: "groupChat",
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        chatProvider.resetMessage(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0.sp),
                                        child: Icon(Icons.cancel_outlined, color: Colors.red, size: 24.sp),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                chatProvider.fileData != null
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: webinarThemesProviders.hintTextColor),
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
                                                                  color: webinarThemesProviders.headerNotchColor),
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
                                                                color: webinarThemesProviders.headerNotchColor),
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
                                                messageCommand: ChatTabDataFlag.Group,
                                                messageType: "groupChat",
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : MessageSendWidget(
                                        messageCommand: ChatTabDataFlag.Group,
                                        messageType: "groupChat",
                                      ),
                              ],
                            ),
                      height5
                    ],
                  ),
            participantsProvider.globalChatOn == true
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.white.withOpacity(0.2),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70.h,
                        color: Colors.grey.withOpacity(0.2),
                        child: Center(child: Text("Group Chat Disabled", style: w400_16Poppins(color: Colors.red))),
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
