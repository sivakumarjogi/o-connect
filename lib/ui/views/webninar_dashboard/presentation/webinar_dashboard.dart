import 'package:fl_pip/fl_pip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/emoji_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/q_and_a_screen.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/guest_streaming_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/spotlight_user.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_appbar.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_bottom_bar_actions.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_features_actions.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_middle_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_more_options_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../meeting/providers/video_share_provider.dart';
import '../../meeting/utils/meeting_utils_mixin.dart';
import 'widgets/dragger_view.dart';
import 'widgets/minimized_video_call_view.dart';

///Bharat
class WebinarDashboard extends StatefulWidget {
  const WebinarDashboard({Key? key}) : super(key: key);

  @override
  State<WebinarDashboard> createState() => _WebinarDashboardState();
}

class _WebinarDashboardState extends State<WebinarDashboard> with TickerProviderStateMixin, WidgetsBindingObserver, MeetingUtilsMixin {
  late ScreenshotController screenshotController;
  bool pipAvailable = false;

  @override
  void initState() {
    screenshotController = context.read<WebinarProvider>().createScreenshotController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeetingEmojiProvider>().setTickerProvider(this);
    });
    WakelockPlus.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer2<MeetingEmojiProvider, AppGlobalStateProvider>(
        builder: (_, meetingEmojiProvider, appState, child) {
          return AbsorbPointer(
            /// Disable click if not connected to any network
            absorbing: !appState.isConnected,
            child: Stack(
              children: [
                PiPBuilder(builder: (PiPStatusInfo? status) {
                  PiPStatus pipStatus = (status?.status ?? PiPStatus.disabled);
                  switch (pipStatus) {
                    case PiPStatus.enabled:
                      return myRole == UserRole.guest ? Center(child: GuestStreamingView(meetingId: context.read<ParticipantsProvider>().meeting.id!)) : const SpotlightWidget();
                    default:
                      return Positioned.fill(
                        child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          drawerEnableOpenDragGesture: false,
                          appBar: const WebinarAppbar(),

                          /// Screen shot
                          body: Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                /// Background theme
                                const _WebinarBackground(),

                                /// Main content view.
                                const Column(
                                  children: [
                                    /// Contains meeting countdown timer, call to action, bgm, timer etc...
                                    _WebinarTopView(),

                                    /// Contains active page, such as presentation, video view etc..
                                    Expanded(
                                      child: WebinarMiddleView(),
                                    ),

                                    /// Contains meeting controls
                                    // WebinarBottomToolkit(),

                                    ///New Bottom Navigation Bar
                                    WebinarBottomBarActions()
                                  ],
                                ),

                                Consumer<WebinarProvider>(builder: (builder, webinarProvider, child) {
                                  return webinarProvider.showWebinarMoreOptionsPopUp ? const WebinarMoreOptionsPopUp() : const SizedBox.shrink();
                                }),
                                Consumer<WebinarProvider>(builder: (builder, webinarProvider, child) {
                                  return webinarProvider.showMoreFeaturesPopUp ? const WebinarFeaturesPopUp() : const SizedBox.shrink();
                                }),

                                Consumer3<PeersProvider, WebinarProvider, ParticipantsProvider>(builder: (_, provider, webinar, participant, __) {
                                  if ((provider.peers.length >= 2 && webinar.isGridView) || participant.myRole == UserRole.guest) return const SizedBox.shrink();
                                  return const DraggerView(child: MinimizedVideoCallView());
                                }),

                                /// Emoji
                                ...meetingEmojiProvider.animatedEmojieWidgets.map(
                                  (e) => SlideTransition(
                                    position: e.slideAnimation,
                                    child: FadeTransition(
                                      opacity: e.fadeAnimation,
                                      child: e.child,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    // case PiPStatus.unavailable:
                    //   return Container(
                    //     color: Colors.blue,
                    //     height: 100,
                    //     width: 100,
                    //   );
                  }
                }),

                // Place black screen on top of the dashboard, if not connected to internet
                if (!appState.isConnected) Container(color: Colors.black.withOpacity(0.5)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WebinarTopView extends StatelessWidget {
  const _WebinarTopView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        height10,
        Consumer2<WebinarProvider, ParticipantsProvider>(
          builder: (_, provider, participantProvider, __) {
            var myRole = participantProvider.myRole;
            if (myRole == UserRole.unknown) {
              return const SizedBox.shrink();
            }
            return WebinarTopViewActionsList();
            /*  return const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  WebinarTopViewActionsList(),
                  // if (participantProvider.handRiseCount != 0) const HandRiseWidget(),
                  // _SettingsIcon(),
                ],
              ),
            ); */
          },
        ),
      ],
    );
  }
}

class WebinarTopViewActionsList extends StatelessWidget with MeetingUtilsMixin {
  WebinarTopViewActionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (_, webinarProvider, participantsProvider, __) {
      final myRole = participantsProvider.myRole;

      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Consumer3<WebinarProvider, ParticipantsProvider, WebinarThemesProviders>(
                builder: (_, provider, participantProvider, webinarThemesProviders, __) {
                  final activeTopActions = provider.activeTopActions;
                  if (participantProvider.myRole == UserRole.unknown) {
                    return const SizedBox.shrink();
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        if (provider.activeFuture == WebinarTopFutures.screenShare)
                          Container(
                            padding: EdgeInsets.all(1.sp),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: webinarThemesProviders.unSelectButtonsColor),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: webinarThemesProviders.unSelectButtonsColor),
                                  child: Text(
                                    "User",
                                    style: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/new_ui_icons/webinar_dashboard/share_dashboard.svg",
                                  width: 25.w,
                                  height: 25.w,
                                ),
                              ],
                            ),
                          ),
                        if (activeTopActions.contains(MeetingAction.callToAction))
                          InkWell(
                            onTap: () {
                              provider.updateActiveFuture(WebinarTopFutures.callToAction);
                            },
                            child: SvgPicture.asset(
                              AppImages.ctaIcon,
                              width: 25.w,
                              color: Colors.blue,
                              height: 25.w,
                            ),
                          ),
                        // CollapsibleWidget(
                        //   expandedWidget: const CallToActionFloatingPopUp(),
                        //   icon: SvgPicture.asset(AppImages.callToAction_icon),
                        // ),
                        if (activeTopActions.contains(MeetingAction.pushLink))
                          InkWell(
                            onTap: () {
                              provider.updateActiveFuture(WebinarTopFutures.pushLink);
                            },
                            child: SvgPicture.asset(
                              AppImages.pushLinkIcon,
                              width: 25.w,
                              color: Colors.blue,
                              height: 25.w,
                            ),
                          ),
                        // CollapsibleWidget(
                        //   expandedWidget: const PushLinkFloatingPopUp(),
                        //   icon: SvgPicture.asset(AppImages.shareLink),
                        // ),
                        if (activeTopActions.contains(MeetingAction.bgm))
                          InkWell(
                            onTap: () {
                              provider.updateActiveFuture(WebinarTopFutures.bgm);
                            },
                            child: SvgPicture.asset(
                              AppImages.bgmICon,
                              width: 25.w,
                              color: Colors.blue,
                              height: 25.w,
                            ),
                          ),
                        // CollapsibleWidget(
                        //   expandedWidget: const BGMAudioPlayer(),
                        //   icon: SvgPicture.asset(AppImages.bgm),
                        // ),
                        if (activeTopActions.contains(MeetingAction.timer))
                          InkWell(
                            onTap: () {
                              provider.updateActiveFuture(WebinarTopFutures.timer);
                            },
                            child: SvgPicture.asset(
                              AppImages.timerNewIcon,
                              width: 25.w,
                              color: Colors.blue,
                              height: 25.w,
                            ),
                          ),
                        // CollapsibleWidget(
                        //   expandedWidget: const ParticipantTimer(),
                        //   icon: SvgPicture.asset(AppImages.timer_Icon),
                        // ),
                        //6281698311@ybl  ///sriram ///140
                        if (activeTopActions.contains(MeetingAction.recording))
                          InkWell(
                            onTap: () {
                              provider.updateActiveFuture(WebinarTopFutures.record);
                            },
                            child: Container(
                              decoration: BoxDecoration(color: webinarThemesProviders.hintTextColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppImages.recordOnIcon,
                                    width: 23.w,
                                    color: Colors.red,
                                    height: 23.w,
                                  ),
                                  width10,
                                  Text(
                                    "Rec",
                                    style: w400_14Poppins(color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          ),
                        // CollapsibleWidget(
                        //   expandedWidget: const RecordScreenWidget(),
                        //   icon: SvgPicture.asset(AppImages.record),
                        // ),
                        if(context.read<WebinarProvider>().activePage==ActivePage.qna)
                        InkWell(
                          onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => const QAndAScreen(),));
                          },
                          child: SvgPicture.asset(
                            AppImages.qAndAIcon,
                            width: 25.w,
                            color: Colors.blue,
                            height: 25.w,
                          ),
                        ),
                      ].withHs(7).toList(),
                    ),
                  );
                },
              ),
            ),
            if (myRole != UserRole.unknown && myRole != UserRole.unknown && participantsProvider.myRole != UserRole.guest && participantsProvider.myRole != UserRole.tempBlocked)
              PopupMenuButton<bool>(
                onSelected: (bool value) {
                  webinarProvider.setIsGridView(value);
                },
                position: PopupMenuPosition.under,
                padding: EdgeInsets.zero,
                initialValue: webinarProvider.isGridView,
                child: SvgPicture.asset(
                  webinarProvider.isGridView ? AppImages.gridViewActiveIcon : AppImages.stackViewActiveIcon,
                  width: 25.w,
                  height: 25.w,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: true,
                        child: Row(
                          children: [SvgPicture.asset(AppImages.gridViewIcon), width5, const Text("Grid View")],
                        )),
                    PopupMenuItem(
                        value: false,
                        child: Row(
                          children: [SvgPicture.asset(AppImages.stackViewIcon), width5, const Text("Focus View")],
                        ))
                  ];
                },
              ),
            width5,
            ...List.generate(
                webinarProvider.webinarTopViewItems.length,
                (index) => Consumer2<VideoShareProvider, ParticipantsProvider>(builder: (_, videoShareProvider, participantsProvider, __) {
                      final userData = participantsProvider.speakers.where((element) => element.handRaise ?? false).toList();
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: (webinarProvider.webinarTopViewItems[index].icon == AppImages.speakerRequestIcon && meeting.meetingType != "webinar")
                            ? SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  debugPrint('${webinarProvider.webinarTopViewItems[index].icon}');
                                  videoShareProvider.speakerRequestedList;
                                  webinarProvider.webinarTopViewItems[index].onTap();
                                },
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      webinarProvider.webinarTopViewItems[index].icon,
                                      width: 26.w,
                                      height: 26.w,
                                    ),
                                    if (webinarProvider.webinarTopViewItems[index].icon == AppImages.speakerRequestIcon && videoShareProvider.speakerRequestedList.isNotEmpty)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          height: 14.w,
                                          width: 14.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.r)), color: Colors.green),
                                          child: Text(
                                            videoShareProvider.speakerRequestedList.isEmpty ? "0" : videoShareProvider.speakerRequestedList.length.toString(),
                                            style: w400_10Poppins(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    if (webinarProvider.webinarTopViewItems[index].icon == AppImages.handraiseIcon && userData.isNotEmpty)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          height: 14.w,
                                          width: 14.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.r)), color: Colors.green),
                                          child: Text(
                                            userData.length.toString(),
                                            style: w400_10Poppins(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      );
                    }))
          ],
        ),
      );
    });
  }
}

///siva
class CollapsibleWidget extends StatefulWidget {
  const CollapsibleWidget({super.key, required this.expandedWidget, required this.icon});

  final Widget expandedWidget;
  final Widget icon;

  @override
  State<CollapsibleWidget> createState() => _CollapsibleWidgetState();
}

class _CollapsibleWidgetState extends State<CollapsibleWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: webinarThemesProviders.colors.cardColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4.0),
          child: Row(
            children: [
              if (!expanded)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: webinarThemesProviders.colors.itemColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: widget.icon,
                    ),
                  ),
                ),
              if (expanded) widget.expandedWidget,
              SizedBox(width: expanded ? 6.w : 12.w),
              InkWell(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Icon(
                  expanded ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
                  color: webinarThemesProviders.colors.textColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// class _SettingsIcon extends StatelessWidget {
//   const _SettingsIcon();

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () async {
//         // PiPStatus pipActive =   await FlPiP().isActive;
//         //     const FlPiPConfig(enabledWhenBackground: false,path:'assets/landscape.mp4' );
//         context.read<WebinarProvider>().pipInstance.disable();

//         // print(pipActive);
//         // if(pipActive == PiPStatus.enabled){

//         // await FlPiP().disable().then((value) {
//         //   print("disabledddddddddddd");
//         // });
//         // }

//         //  bool pipAvailable  = await FlPiP().isAvailable;
//         //  print("===================$pipAvailable");
//         //  if(pipAvailable){
//         //   // FlPiP().enable(
//         //   //     ios: const FlPiPiOSConfig(),
//         //   //     android: const FlPiPAndroidConfig(aspectRatio: Rational.vertical(),));
//         //   try {
//         //     // FlPiP().toggle(AppState.background);
//         //     // await FlPiP().enable(

//         //     //     ios: const FlPiPiOSConfig(enablePlayback: true,enabledWhenBackground: true,),
//         //     //     android: const FlPiPAndroidConfig(
//         //     //       enabledWhenBackground: true,
//         //     //       aspectRatio: Rational.vertical(),
//         //     //     ));
//         //   } catch (e) {
//         //     log(e.toString());
//         //   }
//         //  }
//         //   CustomToast.showInfoToast(msg: "Coming Soon....");
//         // customShowDialog(context, const SettingPopUPPage());
//       },
//       icon: Icon(
//         Icons.settings,
//         color: context.watch<WebinarThemesProviders>().colors.textColor,
//       ),
//     );
//   }
// }

class HandRiseWidget extends StatelessWidget {
  const HandRiseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ParticipantsProvider, HandRaiseProvider, WebinarThemesProviders>(builder: (_, participantsProvider, handRaiseProvider, webinarThemesProviders, __) {
      return Container(
        height: 30.h,
        width: 160.w,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.r)), color: webinarThemesProviders.colors.itemColor),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${handRaiseProvider.handRiseUserName.last.toString() ?? ""}    (${participantsProvider.handRiseCount.toString()})",
                style: w400_12Poppins(color: webinarThemesProviders.colors.textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (participantsProvider.myHubInfo.isHostOrActiveHost) ...[
              width15,
              GestureDetector(
                onTap: () {
                  context.read<HandRaiseProvider>().lowerHandForAll();
                },
                child: Container(
                  height: 25.h,
                  width: 25.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.r)), color: webinarThemesProviders.colors.buttonColor),
                  child: Center(
                    child: Text(
                      "✋",
                      style: w400_12Poppins(),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _WebinarBackground extends StatelessWidget {
  const _WebinarBackground();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, provider, __) {
      return SizedBox(
        height: ScreenConfig.height,
        child: provider.selectedWebinarTheme == null || provider.selectedWebinarTheme!.backgroundImageUrl == null
            ? null
            : Image.network(
                Provider.of<WebinarThemesProviders>(
                  context,
                  listen: false,
                ).selectedWebinarTheme!.backgroundImageUrl!,
                fit: BoxFit.cover,
              ),
      );
    });
  }
}

extension WidgetListExt on Iterable<Widget> {
  Iterable<Widget> withHs(double width) {
    return expand((element) => [element, SizedBox(width: width)]);
  }
}
