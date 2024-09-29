import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_left.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/chat_message_right.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/widgets/message_send_widget.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum/view_state_enum.dart';
import '../../../../core/screen_configs.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../../themes/providers/webinar_themes_provider.dart';

class  QAndAScreen extends StatefulWidget {
  const QAndAScreen({super.key});

  @override
  State<QAndAScreen> createState() => _QAndAScreenState();
}

class _QAndAScreenState extends State<QAndAScreen> {
  TextEditingController searchController = TextEditingController();

  ChatProvider? chatProvider;

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // chatProvider!.clearData();
    chatProvider!.getQAndAHistoryData(context, "questions");
    chatProvider!.chatTabDataFlag = ChatTabDataFlag.QA;
    chatProvider!.listOfSelectedQAndAMessages = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<WebinarThemesProviders>().colors.bodyColor,
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: EdgeInsets.only(left: 14.sp),
          child: Center(
            child: Text(
              "Q&A ",
              style: w600_16Poppins(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ))
        ],
      ),
      floatingActionButton:
          Consumer<ChatProvider>(builder: (context, chatProvider, child) {
        return chatProvider.listOfSelectedQAndAMessages.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: FloatingActionButton(
                  backgroundColor: context
                      .watch<WebinarThemesProviders>()
                      .colors
                      .buttonColor,
                  elevation: 0.0,
                  onPressed: () {
                    chatProvider.publishQAndA(context, null);
                  },
                  child: const Icon(
                    Icons.upload,
                    size: 24,
                  ),
                ),
              )
            : const SizedBox.shrink();
      }),
      body:
          Consumer3<ChatProvider, MeetingRoomProvider, WebinarThemesProviders>(
              builder: (context, chatProvider, meetingRoomProvider,
                  webinarThemesProviders, child) {
        return Stack(
          children: [
            webinarThemesProviders.selectedWebinarTheme?.chatUrl != null
                ? SizedBox(
                    width: ScreenConfig.width,
                    height: ScreenConfig.height,
                    child: Lottie.network(webinarThemesProviders
                        .selectedWebinarTheme!.chatUrl
                        .toString()),
                  )
                : const SizedBox.shrink(),
            Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    child: CommonTextFormField(
                      fillColor: webinarThemesProviders.unSelectButtonsColor,
                      borderColor: webinarThemesProviders.hintTextColor,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      onChanged: (val) {
                        if (val.length > 1) {
                          debugPrint("chat search value $val");
                          chatProvider.qAndAMessageFilter(val);
                        } else if (val.isEmpty || val.length < 2) {
                          chatProvider.getQAndAHistoryData(
                              context, "questions");
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
                      hintStyle: w400_14Poppins(
                          color: webinarThemesProviders.hintTextColor),
                    ),
                  ),
                ),
                Consumer<ChatProvider>(builder: (context, chatProvider, child) {
                  return chatProvider.listOfSelectedQAndAMessages.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                buttonText: 'Delete',
                                onTap: () {
                                  chatProvider
                                      .chatMessageFlagUpdate(
                                          ChatMessageFlag.delete)
                                      .then((value) {
                                    for (var element in chatProvider
                                        .listOfSelectedQAndAMessages) {
                                      chatProvider.deleteChatMessage(
                                          context: context,
                                          messageId: element.id.toString(),
                                          chatId: element.chatId!,
                                          fromUserId: element.fromUserId as int,
                                          meetingId:
                                              element.meetingId.toString());
                                    }
                                  });
                                },
                                leadingWidget: const Icon(
                                  Icons.delete_outline,
                                  size: 24,
                                ),
                                buttonColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                buttonTextStyle:
                                    w400_14Poppins(color: Colors.white),
                                borderColor: Theme.of(context).primaryColor,
                                width: ScreenConfig.width * 0.3,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CustomButton(
                                width: ScreenConfig.width * 0.3,
                                buttonText: 'Publish',
                                leadingWidget: const Icon(
                                  Icons.upload,
                                  size: 24,
                                ),
                                onTap: () {
                                  chatProvider.publishQAndA(context, null);
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                Expanded(
                  child: chatProvider.listOfQAndAMessages.isEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: SizedBox(
                              height: 290.w,
                              width: 290.w,
                              child: Column(
                                children: [
                                  Image.asset(
                                    AppImages.qAndAEmptyIconPng,
                                    width: 225.w,
                                    height: 175.h,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30.h,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "The Q&A window is empty",
                                      style: w600_18Poppins(
                                          color: const Color(0xff0E78F9)),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 224.w,
                                    height: 42.h,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "The attendees haven't asked any questions yet for you to answer",
                                      style: w400_14Poppins(
                                          color: context
                                              .read<WebinarThemesProviders>()
                                              .hintTextColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: chatProvider.isReply
                              ? MediaQuery.of(context).size.height * 0.75 -
                                  120.h
                              : MediaQuery.of(context).size.height * 0.75 -
                                  50.h,
                          child: ListView(
                              shrinkWrap: true,
                              controller: chatProvider.scrollController,
                              children: List.generate(
                                  chatProvider.listOfQAndAMessages.length,
                                  (index) => meetingRoomProvider.userData.id
                                              .toString() !=
                                          chatProvider
                                              .listOfQAndAMessages[index]
                                              .fromUserId
                                              .toString()
                                      ? ChatMessageLeft(
                                          messageData: chatProvider
                                              .listOfQAndAMessages[index],
                                          onTap: () {
                                            chatProvider.selectedMessages(
                                                chatProvider
                                                        .listOfQAndAMessages[
                                                    index]);
                                          },
                                          isQandA: true)
                                      : ChatMessageRight(
                                          messageData: chatProvider
                                              .listOfQAndAMessages[index],
                                          onTap: () {
                                            chatProvider.selectedMessages(
                                                chatProvider
                                                        .listOfQAndAMessages[
                                                    index]);
                                          },
                                          isQandA: true))),
                        ),
                ),
                chatProvider.isQAEnabled
                    ? (chatProvider.isReply
                        ? Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: SizedBox(
                              height: 120.h,
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.r))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.reply),
                                            width10,
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.67,
                                                child: Text(
                                                  chatProvider.isReplyMessage
                                                          .toString() ??
                                                      "hello",
                                                  style: w400_14Poppins(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            width10,
                                            InkWell(
                                                onTap: () {
                                                  chatProvider
                                                      .resetMessage(context);
                                                },
                                                child: const Icon(
                                                    Icons.cancel_outlined))
                                          ],
                                        ),
                                        MessageSendWidget(
                                          messageCommand: ChatTabDataFlag.QA,
                                          messageType: "questions",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : MessageSendWidget(
                            messageCommand: ChatTabDataFlag.QA,
                            messageType: "questions",
                          ))
                    : const SizedBox.shrink()
              ],
            ),
            chatProvider.isQAEnabled
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
                        child: Center(
                            child: Text("Q&A Disabled",
                                style: w400_16Poppins(color: Colors.red))),
                      ),
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
