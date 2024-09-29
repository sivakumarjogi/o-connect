import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/chat_model/chat_model.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/library_provider.dart';
import '../../../../utils/images/images.dart';
import '../../../meeting/utils/meeting_utils_mixin.dart';
import '../../providers/chat_provider.dart';
import 'chat_more_pop-up_menu_widget.dart';

class ChatMessageLeft extends StatelessWidget with MeetingUtilsMixin {
  ChatMessageLeft({
    Key? key,
    required this.messageData,
    required this.isQandA,
    this.onTap,
  }) : super(key: key);

  final ChatModel messageData;
  final bool isQandA;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, ChatProvider, WebinarThemesProviders>(
        builder: (context, themeProvider, chatProvider, webinarThemesProviders,
            child) {
      var messageColor = webinarThemesProviders.unSelectButtonsColor;

      var replyMessage = [];
      var selectQAndAMessage = [];
      if (messageData.replyChatId != null &&
          chatProvider.chatTabDataFlag == ChatTabDataFlag.Group) {
        replyMessage = chatProvider.listOfMessages.where((element) {
          return element.id == messageData.replyChatId;
        }).toList();
      } else if (messageData.replyChatId != null &&
          chatProvider.chatTabDataFlag == ChatTabDataFlag.Private) {
        replyMessage = chatProvider.listOfMessagesPrivate.where((element) {
          return element.id == messageData.replyChatId;
        }).toList();
      } else if (chatProvider.chatTabDataFlag == ChatTabDataFlag.QA) {
        selectQAndAMessage =
            chatProvider.listOfSelectedQAndAMessages.where((element) {
          return element.id == messageData.id;
        }).toList();
      }

      return Padding(
        padding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 3.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h, right: 3.w),
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.whiteColor, width: 2.w),
                  borderRadius: BorderRadius.all(Radius.circular(25.r))),
              child: isQandA
                  ? selectQAndAMessage.isNotEmpty
                      ? InkWell(
                          onTap: onTap,
                          child: Stack(
                            children: [
                              Container(
                                height: 40.w,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.whiteColor, width: 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.r))),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: messageData.fileName
                                            .toString()
                                            .endsWith(".pdf")
                                        ? Padding(
                                            padding: EdgeInsets.all(5.0.sp),
                                            child: SvgPicture.asset(
                                                AppImages.pollFile),
                                          )
                                        : ImageServiceWidget(
                                            networkImgUrl:
                                                messageData.ppic.toString())),
                              ),
                              Container(
                                height: 40.w,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.whiteColor, width: 1),
                                    color: Colors.blue.withOpacity(0.4),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.r))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child: SvgPicture.asset(
                                    AppImages.tickIconSvg,
                                    height: 30.w,
                                    width: 30.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : chatProvider.webinarQAndAMessagesList.any(
                              (element) => element.chatId == messageData.id)
                          ? Stack(
                              children: [
                                Container(
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.whiteColor,
                                          width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.r))),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: ImageServiceWidget(
                                          networkImgUrl: messageData.ppic !=
                                                  null
                                              ? messageData.ppic.toString()
                                              : "https: //de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png")),
                                ),
                                Container(
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.whiteColor,
                                          width: 1),
                                      color: Colors.blue.withOpacity(0.4),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.r))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: ImageServiceWidget(
                                  networkImgUrl: messageData.ppic != null
                                      ? messageData.ppic.toString()
                                      : "https: //de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: ImageServiceWidget(
                          networkImgUrl: messageData.ppic != null
                              ? messageData.ppic.toString()
                              : "https: //de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png")),
            ),
            width5,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0.sp),
                      child: Text(
                        messageData.fromUser ?? "User",
                        style: w500_12Poppins(
                            color: webinarThemesProviders.hintTextColor),
                      ),
                    ),
                    messageData.messageType.toString() == "text" ||
                            messageData.messageType == null
                        ? messageData.replyChatId == null ||
                                replyMessage.isEmpty
                            ? Container(
                                padding: EdgeInsets.all(12.sp),
                                width: 220.w,
                                margin: EdgeInsets.symmetric(vertical: 3.h),
                                decoration: BoxDecoration(
                                    color: messageColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12.r),
                                        bottomLeft: Radius.circular(12.r),
                                        bottomRight: Radius.circular(12.r))),
                                child: Text(
                                  messageData.message.toString() ?? "Hi.",
                                  style: w400_12Poppins(
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(12.sp),
                                width: 220.w,
                                margin: EdgeInsets.symmetric(vertical: 3.h),
                                decoration: BoxDecoration(
                                    color: messageColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12.r),
                                        topLeft: Radius.circular(12.r),
                                        bottomRight: Radius.circular(12.r))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.reply,
                                        color: Colors.white),
                                    Text(
                                      replyMessage[0].message.toString() ??
                                          "User",
                                      style: w400_12Poppins(
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                    replyMessage[0].url != null
                                        ? SizedBox(
                                            height: 150.w,
                                            width: 220.w,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: ImageServiceWidget(
                                                    tempImage: chatProvider
                                                        .fileTypeUpdate(
                                                            replyMessage[0]
                                                                .fileName),
                                                    networkImgUrl:
                                                        replyMessage[0]
                                                            .url
                                                            .toString())))
                                        : const SizedBox.shrink(),
                                    Text(
                                      replyMessage[0].fromUser.toString() ??
                                          "User",
                                      style: w400_12Poppins(
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Text(
                                      messageData.message.toString() ?? "Hi.",
                                      style: w400_12Poppins(
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  ],
                                ),
                              )
                        : Container(
                            // height: 280.h,
                            width: 220.w,
                            decoration: BoxDecoration(
                                color: messageColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                    bottomRight: Radius.circular(12.r))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 150.w,
                                    width: 200.w,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: ImageServiceWidget(
                                            tempImage:
                                                chatProvider.fileTypeUpdate(
                                                    messageData.fileName),
                                            networkImgUrl:
                                                messageData.url.toString()))),
                                Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: 140.h,
                                          child: Text(
                                            messageData.fileName.toString() ??
                                                ".png",
                                            style: w400_12Poppins(
                                                color: Theme.of(context)
                                                    .hintColor),
                                          )),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Provider.of<LibraryProvider>(context,
                                                  listen: false)
                                              .fileDownloadLocal(
                                                  messageData.url.toString(),
                                                  messageData.fileName
                                                          .toString() ??
                                                      "test${DateTime.now()}");
                                        },
                                        child: SizedBox(
                                            height: 40.h,
                                            child: Icon(
                                              Icons.arrow_circle_down_rounded,
                                              color:
                                                  Theme.of(context).hintColor,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Text(
                                    "File Size : ${context.read<ChatProvider>().formatBytes(int.parse(messageData.fileSize.toString()), 2).toString()}" ??
                                        "0.0 MB",
                                    style: w400_12Poppins(
                                        color: Theme.of(context).hintColor),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context).disabledColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Text(
                                    messageData.message.toString() ?? "Hi.",
                                    style: w500_14Poppins(
                                        color: webinarThemesProviders
                                            .colors.textColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0.sp, right: 15.sp),
                  child: Text(
                    DateFormat("HH:mm")
                        .format(DateTime.parse(messageData.createdOn == null
                                ? "2023-11-22T00:00z"
                                : messageData.createdOn.toString())
                            .toLocal())
                        .toString(),
                    style: w400_12Poppins(
                        color: webinarThemesProviders.hintTextColor),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0.sp),
              child: isQandA == false
                  ? ChatMorePopUpMenuWidget(
                      messageDetails: messageData,
                    )
                  : chatProvider.webinarQAndAMessagesList.any(
                              (element) => element.chatId == messageData.id) &&
                          myHubInfo.role != "Host"
                      ? const SizedBox.shrink()
                      : QAndAMorePopUpMenuWidget(
                          messageDetails: messageData,
                          isQuestionSelected: selectQAndAMessage.isNotEmpty,
                        ),
            )
          ],
        ),
      );
    });
  }
}
