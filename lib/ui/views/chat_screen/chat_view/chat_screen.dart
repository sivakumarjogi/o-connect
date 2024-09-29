import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/private_chat_participants_list_screen.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/q_and_a_screen.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/enum/view_state_enum.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../meeting/model/user_role.dart';
import '../../meeting/providers/participants_provider.dart';
import '../../meeting/utils/meeting_utils_mixin.dart';
import '../providers/chat_provider.dart';
import 'group_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.isFromQAndAScreen}) : super(key: key);
  final bool isFromQAndAScreen;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin, MeetingUtilsMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  late TabController _tabController;

  late ChatProvider _chatProvider;
  var guestUser;

  @override
  void initState() {
    guestUser = context.read<ParticipantsProvider>().myRole;

    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _chatProvider.globalChatCount = 0;
    _chatProvider.chatTabDataFlag = ChatTabDataFlag.Group;
    _chatProvider.isReply = false;
    _chatProvider.listOfMessages = [];
    _chatProvider.listOfMessagesPrivate = [];
    _chatProvider.getChatHistoryData(context, "groupChat");
    _tabController = TabController(
      initialIndex: 0,
      length: (context.read<ParticipantsProvider>().myRole != UserRole.guest && context.read<ParticipantsProvider>().myRole != UserRole.unknown)?2: 1,
      vsync: this,
    );

    _chatProvider.listenForPermissions();
    // if (!_chatProvider.speechTextEnabled) {
    _chatProvider.startSpeech();
    // }
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _chatProvider.chatMessageTabUpdate(ChatTabDataFlag.Private).then((value) {
          _chatProvider.chatUpdate(ChatTabDataFlag.Private, _tabController.index);
        });
      } else if (_tabController.index == 0) {
        _chatProvider.chatMessageTabUpdate(ChatTabDataFlag.Group).then((value) {
          _chatProvider.chatUpdate(ChatTabDataFlag.Group, _tabController.index);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _searchController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<WebinarThemesProviders>().colors.bodyColor,
      // resizeToAvoidBottomInset: true,
      body: Consumer3<ThemeProvider, ChatProvider, WebinarThemesProviders>(builder: (context, themeProvider, chatProvider, webinarThemesProviders, child) {
        return SafeArea(
          child: Column(
            children: [
              Container(
                color: webinarThemesProviders.colors.bodyColor,
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          chatProvider.clearData();
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: webinarThemesProviders.hintTextColor,
                          size: 24.sp,
                        )),
                    InkWell(
                      onTap: () {
                        chatProvider.questionAndAnsClose(context);
                      },
                      child: Center(
                        child: Text(
                          ConstantsStrings.chatText,
                          style: w600_16Poppins(color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.sp, vertical: 5.sp),
                child: Container(
                  decoration: BoxDecoration(color: webinarThemesProviders.bgColor, borderRadius: BorderRadius.circular(5.r)),
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(5.0.r),
                      //     ),
                      //     color: _tabController.index == 0
                      //         ? webinarThemesProviders.colors.buttonColor
                      //         : _tabController.index == 1
                      //             ? webinarThemesProviders.colors.buttonColor
                      //             : Colors.white),
                      // indicatorWeight: 3,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      controller: _tabController,
                      labelStyle: w600_10Poppins(),
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        Tab(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                              ),
                              color: _tabController.index == 0 ? Colors.blue : context.read<WebinarThemesProviders>().unSelectButtonsColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Group",
                                  style: w500_12Poppins(color: Colors.white),
                                ),
                                width5,
                                Visibility(
                                  visible: chatProvider.globalChatCount == 0 ? false : true,
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(color: webinarThemesProviders.colors.headerColor, borderRadius: BorderRadius.circular(50.r)),
                                    child: Center(
                                        child: Text(
                                      chatProvider.globalChatCount.toString(),
                                      style: w600_14Poppins(color: AppColors.whiteColor),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                        if (context.read<ParticipantsProvider>().myRole != UserRole.guest && context.read<ParticipantsProvider>().myRole != UserRole.unknown)
                        Tab(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                              ),
                              color: _tabController.index == 1 ? Colors.blue : context.read<WebinarThemesProviders>().unSelectButtonsColor,
                            ),
                            child: Text(
                              "Private",
                              style: w500_12Poppins(color: Colors.white),
                            ),
                          ),
                        )),
                      ]),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    GroupChat(),
                    if (context.read<ParticipantsProvider>().myRole != UserRole.guest && context.read<ParticipantsProvider>().myRole != UserRole.unknown) PrivateChat(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
