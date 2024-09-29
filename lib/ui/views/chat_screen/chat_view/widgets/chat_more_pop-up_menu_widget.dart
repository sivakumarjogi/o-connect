import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../meeting/utils/meeting_utils_mixin.dart';
import '../../chat_model/chat_model.dart';
import '../../providers/chat_provider.dart';

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class ChatMorePopUpMenuWidget extends StatelessWidget with MeetingUtilsMixin {
  final ChatModel messageDetails;

  ChatMorePopUpMenuWidget({Key? key, required this.messageDetails})
      : super(key: key);

  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    print(messageDetails.roleType.toString());
    return Consumer2<ChatProvider, WebinarThemesProviders>(
        builder: (context, chatProvider, webinarThemesProviders, child) {
      return PopupMenuButton<SampleItem>(
        elevation: 0,
        icon:
            Icon(Icons.more_vert, color: webinarThemesProviders.hintTextColor),
        color: webinarThemesProviders.headerNotchColor,
        initialValue: selectedMenu,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
        onSelected: (SampleItem item) {},
        itemBuilder: (BuildContext context) {
          if (messageDetails.fromUserId == userData.id) {
            return <PopupMenuEntry<SampleItem>>[
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.reply)
                      .then((value) {
                    chatProvider.reSendMessage(context, messageDetails);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      color: webinarThemesProviders.hintTextColor,
                      size: 24.h,
                    ),
                    width10,
                    Text(
                      ConstantsStrings.reply,
                      style: w400_14Poppins(
                        color: webinarThemesProviders.hintTextColor,
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemThree,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.edit)
                      .then((value) {
                    chatProvider.editMessage(messageDetails);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/new_ui_icons/chat_icons/edit.svg",
                      color: webinarThemesProviders.hintTextColor,
                      height: 24.w,
                      width: 24.w,
                    ),
                    width10,
                    Text(ConstantsStrings.edit,
                        style: w400_14Poppins(
                          color: webinarThemesProviders.hintTextColor,
                        )),
                  ],
                ),
              ),
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.delete)
                      .then((value) {
                    chatProvider.deleteChatMessage(
                      context: context,
                      messageId: messageDetails.id.toString(),
                      meetingId: messageDetails.meetingId.toString(),
                      fromUserId: messageDetails.fromUserId as int,
                      chatId: messageDetails.chatId!,
                    );
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/new_ui_icons/chat_icons/delete.svg",
                      color: webinarThemesProviders.hintTextColor,
                      height: 24.w,
                      width: 24.w,
                    ),
                    width10,
                    Text(
                      ConstantsStrings.delete,
                      style: w400_14Poppins(
                        color: webinarThemesProviders.hintTextColor,
                      ),
                    )
                  ],
                ),
              ),
            ];
          } else if (messageDetails.fromUserId != userData.id &&
              messageDetails.roleType.toString().toLowerCase() != "host" &&
              myRole == UserRole.host) {
            return <PopupMenuEntry<SampleItem>>[
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.reply)
                      .then((value) {
                    chatProvider.reSendMessage(context, messageDetails);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      color: webinarThemesProviders.hintTextColor,
                      size: 24.h,
                    ),
                    width10,
                    Text(
                      ConstantsStrings.reply,
                      style: w400_14Poppins(
                        color: webinarThemesProviders.hintTextColor,
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.delete)
                      .then((value) {
                    chatProvider.deleteChatMessage(
                      context: context,
                      messageId: messageDetails.id.toString(),
                      meetingId: messageDetails.meetingId.toString(),
                      fromUserId: messageDetails.fromUserId as int,
                      chatId: messageDetails.chatId!,
                    );
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/new_ui_icons/chat_icons/delete.svg",
                      color: webinarThemesProviders.hintTextColor,
                      height: 24.w,
                      width: 24.w,
                    ),
                    width10,
                    Text(
                      ConstantsStrings.delete,
                      style: w400_14Poppins(
                        color: webinarThemesProviders.hintTextColor,
                      ),
                    )
                  ],
                ),
              ),
            ];
          } else {
            return <PopupMenuEntry<SampleItem>>[
              PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                onTap: () {
                  chatProvider
                      .chatMessageFlagUpdate(ChatMessageFlag.reply)
                      .then((value) {
                    chatProvider.reSendMessage(context, messageDetails);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      color: webinarThemesProviders.hintTextColor,
                      size: 24.h,
                    ),
                    width10,
                    Text(
                      ConstantsStrings.reply,
                      style: w400_14Poppins(
                        color: webinarThemesProviders.hintTextColor,
                      ),
                    )
                  ],
                ),
              ),
            ];
          }
        },
      );
    });
  }
}

class QAndAMorePopUpMenuWidget extends StatelessWidget with MeetingUtilsMixin {
  final ChatModel messageDetails;
  final bool isQuestionSelected;

  QAndAMorePopUpMenuWidget(
      {Key? key,
      required this.messageDetails,
      required this.isQuestionSelected})
      : super(key: key);

  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    var attendee = context.read<MeetingRoomProvider>().attendee;
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      var hostMsgPublishOptions = <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          onTap: () {
            chatProvider.deleteQAnsAMessageDelete(context, messageDetails.id);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/publish.svg",
                color: context.read<WebinarThemesProviders>().hintTextColor,
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                ConstantsStrings.unPublished,
                style: w400_14Poppins(
                    color:
                        context.read<WebinarThemesProviders>().hintTextColor),
              )
            ],
          ),
        ),
      ];
      var hostMsgOptions = <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          onTap: () {
            chatProvider.selectedMessages(messageDetails);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/select.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                isQuestionSelected
                    ? ConstantsStrings.deselect
                    : ConstantsStrings.select,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          onTap: () {
            chatProvider
                .chatMessageFlagUpdate(ChatMessageFlag.edit)
                .then((value) {
              chatProvider.editMessage(messageDetails);
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/edit.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(ConstantsStrings.edit,
                  style: w400_14Poppins(
                    color: context.read<WebinarThemesProviders>().hintTextColor,
                  )),
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          onTap: () {
            chatProvider
                .chatMessageFlagUpdate(ChatMessageFlag.delete)
                .then((value) {
              chatProvider.deleteChatMessage(
                context: context,
                messageId: messageDetails.id.toString(),
                meetingId: messageDetails.meetingId.toString(),
                fromUserId: messageDetails.fromUserId as int,
                chatId: messageDetails.chatId!,
              );
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/delete.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                ConstantsStrings.delete,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          onTap: () {
            chatProvider.publishQAndA(context, messageDetails);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/publish.svg",
                height: 30.w,
                width: 30.w,
              ),
              width10,
              Text(
                ConstantsStrings.publish,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
      ];
      var attendeeMsgOptions = <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          onTap: () {
            chatProvider
                .chatMessageFlagUpdate(ChatMessageFlag.edit)
                .then((value) {
              chatProvider.editMessage(messageDetails);
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/edit.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(ConstantsStrings.edit,
                  style: w400_14Poppins(
                    color: context.read<WebinarThemesProviders>().hintTextColor,
                  )),
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          onTap: () {
            chatProvider
                .chatMessageFlagUpdate(ChatMessageFlag.delete)
                .then((value) {
              chatProvider.deleteChatMessage(
                context: context,
                messageId: messageDetails.id.toString(),
                meetingId: messageDetails.meetingId.toString(),
                fromUserId: messageDetails.fromUserId as int,
                chatId: messageDetails.chatId!,
              );
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/delete.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                ConstantsStrings.delete,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
      ];
      var hostVsAttendeeMsgOptions = <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          onTap: () {
            chatProvider.selectedMessages(messageDetails);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/select.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                ConstantsStrings.select,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          onTap: () {
            chatProvider
                .chatMessageFlagUpdate(ChatMessageFlag.delete)
                .then((value) {
              chatProvider.deleteChatMessage(
                context: context,
                messageId: messageDetails.id.toString(),
                meetingId: messageDetails.meetingId.toString(),
                fromUserId: messageDetails.fromUserId as int,
                chatId: messageDetails.chatId!,
              );
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/delete.svg",
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Text(
                ConstantsStrings.delete,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          onTap: () {
            chatProvider.publishQAndA(context, messageDetails);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/new_ui_icons/chat_icons/publish.svg",
                height: 30.w,
                width: 30.w,
              ),
              width10,
              Text(
                ConstantsStrings.publish,
                style: w400_14Poppins(
                  color: context.read<WebinarThemesProviders>().hintTextColor,
                ),
              )
            ],
          ),
        ),
      ];
      return PopupMenuButton<SampleItem>(
        elevation: 0,
        icon: Icon(Icons.more_vert,
            color: context.watch<WebinarThemesProviders>().hintTextColor),
        color: context.watch<WebinarThemesProviders>().headerNotchColor,
        initialValue: selectedMenu,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
        onSelected: (SampleItem item) {},
        itemBuilder: (BuildContext context) {
          if (chatProvider.webinarQAndAMessagesList
                  .any((element) => element.chatId == messageDetails.id) &&
              myRole == UserRole.host) {
            return hostMsgPublishOptions;
          } else if (messageDetails.roleType.toString().toLowerCase() ==
                  "host" &&
              chatProvider.chatTabDataFlag == ChatTabDataFlag.QA &&
              attendee.roleType.toString().toLowerCase() == "host") {
            return hostMsgOptions;
          } else if ((messageDetails.roleType.toString().toLowerCase() ==
                      "attendee" ||
                  messageDetails.roleType.toString().toLowerCase() ==
                      "guest") &&
              chatProvider.chatTabDataFlag == ChatTabDataFlag.QA &&
              attendee.roleType.toString().toLowerCase() == "attendee") {
            return attendeeMsgOptions;
          } else if ((messageDetails.roleType.toString().toLowerCase() ==
                      "attendee" ||
                  messageDetails.roleType.toString().toLowerCase() ==
                      "guest") &&
              chatProvider.chatTabDataFlag == ChatTabDataFlag.QA &&
              myRole == UserRole.host) {
            return hostVsAttendeeMsgOptions;
          } else {
            return <PopupMenuEntry<SampleItem>>[];
          }
        },
      );
    });
  }
}
