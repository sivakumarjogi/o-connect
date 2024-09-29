import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/participants/widgets/blocked_user/blocked_users.dart';
import 'package:o_connect/ui/views/participants/widgets/guest_list.dart';
import 'package:o_connect/ui/views/participants/widgets/speakers_list.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/meeting_lock_icon.dart';
import 'package:oes_chatbot/utils/font_styles_global.dart';
import 'package:provider/provider.dart';
import '../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../utils/textfield_helper/common_textfield.dart';
import '../invite/invites_screen.dart';
import '../meeting/model/user_role.dart';
import 'widgets/handling_participants.dart';

class AllParticipantsPage extends StatefulWidget {
  const AllParticipantsPage({super.key});

  @override
  State<AllParticipantsPage> createState() => _AllParticipantsPageState();
}

class _AllParticipantsPageState extends State<AllParticipantsPage> with MeetingUtilsMixin, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
        length: (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost)
            ? 3
            : (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost || myRole == UserRole.speaker)
                ? 2
                : 1,
        vsync: this,
        initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //webinarThemesProviders.colors.textColor
    return Consumer2<ParticipantsProvider, WebinarThemesProviders>(builder: (context, pro, webinarThemesProviders, child) {
      return Scaffold(
        backgroundColor: webinarThemesProviders.bgColor,
        key: UniqueKey(),
        appBar: AppBar(
          backgroundColor: webinarThemesProviders.colors.bodyColor,
          // leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.all(14.0),
            child: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.sp,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [
            if (context.read<ParticipantsProvider>().myRole != UserRole.speaker &&
                context.read<ParticipantsProvider>().myRole != UserRole.guest &&
                context.read<ParticipantsProvider>().myRole != UserRole.unknown)
              Row(
                children: [
                  Text(
                    "Lock",
                    style: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                  ),
                  width5,
                  SizedBox(
                    height: 24.sp,
                    child: const MeetingLockIcon(),
                  )
                ],
              )
          ],
          // centerTitle: true,
          elevation: 0,
          title: Text(
            "${ConstantsStrings.allParticipants} (${pro.allUsersCount.toString()})",
            style: w500_16Poppins(color: Theme.of(context).hintColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                if (myHubInfo.isHost || myHubInfo.isActiveHost) HandlingParticipants(),
                if (myHubInfo.isHost || myHubInfo.isActiveHost) height10,
                if (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost)
                  SizedBox(
                    height: 45.h,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CommonTextFormField(
                            controller: pro.participantSearchController,
                            suffixIcon: Icon(Icons.search, color: webinarThemesProviders.hintTextColor),
                            hintText: ConstantsStrings.searchByName,
                            hintStyle: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                            fillColor: webinarThemesProviders.headerNotchColor,
                            keyboardType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            onChanged: (v) {
                              setState(() {});
                            },
                          ),
                        ),
                        width5,
                        Container(
                          height: 45.h,
                          width: 45,
                          padding: EdgeInsets.all(8.0.sp),
                          decoration: BoxDecoration(
                            color: context.read<WebinarThemesProviders>().headerNotchColor,
                            borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
                          ),
                          child: SvgPicture.asset(
                            "assets/new_ui_icons/all_participants_icons/filter.svg",
                          ),
                        ),
                        width5,
                        InkWell(
                          onTap: () {
                            customShowDialog(context, const InviteScreen());
                          },
                          child: Container(
                            height: 45.w,
                            width: 45.w,
                            padding: EdgeInsets.all(8.0.sp),
                            decoration: BoxDecoration(
                              color: context.read<WebinarThemesProviders>().headerNotchColor,
                              borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
                            ),
                            child: SvgPicture.asset("assets/new_ui_icons/all_participants_icons/invite.svg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                height10,
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        labelStyle: w400_12Poppins(color: Theme.of(context).focusColor),
                        indicatorColor: Colors.transparent,
                        unselectedLabelStyle: w400_12Poppins(color: Theme.of(context).hintColor),
                        unselectedLabelColor: Theme.of(context).hintColor,
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (idx) {
                          pro.participantSearchController.clear();
                          pro.callNotify();
                        },
                        tabs: [
                          if (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost || myRole == UserRole.speaker)
                            Tab(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 200,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.r),
                                        ),
                                      ),
                                      color: tabController.index == 0 ? Colors.blue : webinarThemesProviders.headerNotchColor,
                                    ),
                                    child: Text(
                                      'Speakers',
                                      style: w400_14Poppins(color: Colors.white),
                                    ))),
                          if (meeting.meetingType != "conference")
                            Tab(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.r),
                                        ),
                                      ),
                                      color: tabController.index == 1 ? Colors.blue : webinarThemesProviders.headerNotchColor,
                                    ),
                                    child: Text(
                                      'Attendees',
                                      style: w400_14Poppins(color: Colors.white),
                                    ))),
                          if (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost)
                            Tab(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.r),
                                      ),
                                    ),
                                    color: tabController.index == 2 ? Colors.blue : webinarThemesProviders.headerNotchColor,
                                  ),
                                  child: Text(
                                    'Blocked',
                                    style: w400_14Poppins(color: Colors.white),
                                  )),
                            ),
                        ],
                      ),
                      height10,
                      SizedBox(
                        height: 500,
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: [
                            if (myRole != UserRole.guest || myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost) const SpeakersGrid(),
                            if (meeting.meetingType !=  "conference") const GuestListWidget(),
                            if (myHubInfo.isHost || myHubInfo.isActiveHost || myHubInfo.isCohost) const BlockedUser()
                          ],
                        ),
                      ),
                    ],
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
