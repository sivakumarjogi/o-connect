import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/private_chat_screen.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/screen_configs.dart';
import '../../meeting/providers/participants_provider.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({super.key});

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  ChatProvider? chatProvider;

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider!.clearData();
    chatProvider!.privateChatUserId = 0;
    chatProvider!.chatTabDataFlag = ChatTabDataFlag.Private;
    chatProvider!.listOfMessagesPrivate = [];
    chatProvider!.isEditReplyMessageID = "";
    chatProvider!.isEditMessageID = "";
    chatProvider!.isChatSpeakerList = false;
    chatProvider!.scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (chatProvider!.listOfMessagesPrivate.isNotEmpty) {
        chatProvider!.scrollController!.animateTo(chatProvider!.scrollController!.position.extentAfter, duration: const Duration(milliseconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
    chatProvider!.chatMessageFlag = ChatMessageFlag.initial;
    chatProvider!.updateChatStatus(context, context.read<MeetingRoomProvider>().userData.id.toString(), "");
    chatProvider!.getChatCountsByMeetingId(
      context,
      context.read<MeetingRoomProvider>().userData.id.toString(),
      context.read<MeetingRoomProvider>().meeting.id.toString(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.watch<WebinarThemesProviders>().colors.bodyColor,
      body: Consumer4<ParticipantsProvider, MeetingRoomProvider, ChatProvider, WebinarThemesProviders>(
          builder: (context, participantsProvider, meetingRoomProvider, chatProvider, webinarThemesProviders, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Stack(
            children: [
              webinarThemesProviders.selectedWebinarTheme?.chatUrl != null
                  ? SizedBox(
                      width: ScreenConfig.width,
                      height: ScreenConfig.height,
                      child: Lottie.network(webinarThemesProviders.selectedWebinarTheme!.chatUrl.toString()),
                    )
                  : const SizedBox.shrink(),
              chatProvider.isChatSpeakerList == false ? const ChatSpeakerList() : const PrivateChatScreen(),
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
                          child: Center(child: Text("Private Chat Disabled", style: w400_16Poppins(color: Colors.red))),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}

class ChatSpeakerList extends StatefulWidget {
  const ChatSpeakerList({super.key});

  @override
  State<ChatSpeakerList> createState() => _ChatSpeakerListState();
}

class _ChatSpeakerListState extends State<ChatSpeakerList> {
  ChatProvider? chatProvider;

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider?.getParticipantsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ParticipantsProvider, MeetingRoomProvider, ChatProvider, WebinarThemesProviders>(
        builder: (context, participantsProvider, meetingRoomProvider, chatProvider, webinarThemesProviders, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8.sp,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                height8,
                SizedBox(
                  height: 50.h,
                  child: CommonTextFormField(
                    fillColor: webinarThemesProviders.headerNotchColor,
                    controller: chatProvider.searchControllerForSpeaker,
                    borderColor: webinarThemesProviders.hintTextColor,
                    hintStyle: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    onChanged: (val) {
                      if (val.length > 1) {
                        debugPrint("chat search value $val");
                        chatProvider.chatParticipantsFilter(val, context);
                      } else if (val.isEmpty || val.length < 2) {
                        chatProvider.getParticipantsList();
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
                chatProvider.participantsList.isEmpty
                    ? Center(
                        child: Text(
                          "No Speakers Found",
                          style: w400_14Poppins(color: Theme.of(context).disabledColor),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.sp),
                          child: ListView.builder(
                              itemCount: chatProvider.participantsList.length,
                              itemBuilder: (_, index) {
                                print("kjsfksfskjfhk ${chatProvider.participantsList[index]}");
                                return InkWell(
                                  onTap: () {
                                    chatProvider.getPrivateChatHistoryData(context, chatProvider.participantsList[index].id.toString(), chatProvider.participantsList[index]);
                                    chatProvider.updateChatStatus(context, context.read<MeetingRoomProvider>().userData.id.toString(), chatProvider.participantsList[index].id.toString());

                                    chatProvider.isChatLayoutChange(chatProvider.participantsList[index].id.toString(), true);
                                  },
                                  child: Container(
                                    height: 62.h,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: webinarThemesProviders.headerNotchColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            width10,
                                            Container(
                                              height: 45.w,
                                              width: 45.w,
                                              decoration:
                                                  BoxDecoration(border: Border.all(color: webinarThemesProviders.hintTextColor, width: 2.w), borderRadius: BorderRadius.all(Radius.circular(25.r))),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(50.r),
                                                  child: ImageServiceWidget(
                                                      networkImgUrl: chatProvider.participantsList[index].profilePic != null
                                                          ? chatProvider.participantsList[index].profilePic.toString()
                                                          : "https://de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png")),
                                            ),
                                            width10,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  chatProvider.participantsList[index].displayName == null ? "User" : chatProvider.participantsList[index].displayName!,
                                                  style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                                                ),
                                                Text(
                                                  "Hi this is ${chatProvider.participantsList[index].displayName == null ? "User" : chatProvider.participantsList[index].displayName!}",
                                                  style: w400_10Poppins(color: Theme.of(context).disabledColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (chatProvider.getAllUsersCount != null && chatProvider.getAllUsersCount!.containsKey(chatProvider.participantsList[index].id.toString()))
                                          Padding(
                                            padding: EdgeInsets.only(right: 10.w),
                                            child: Container(
                                              width: 20.w,
                                              height: 20.w,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: Colors.green),
                                              child: Center(
                                                  child: Text(
                                                chatProvider.getAllUsersCount![chatProvider.participantsList[index].id.toString()].toString(),
                                                style: w400_10Poppins(color: Colors.white),
                                              )),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
