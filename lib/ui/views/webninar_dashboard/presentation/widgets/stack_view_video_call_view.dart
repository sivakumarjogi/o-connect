// import 'dart:developer';
// import 'package:fl_pip/fl_pip.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:o_connect/core/providers/app_global_state_provider.dart';
// import 'package:o_connect/core/providers/emoji_provider.dart';
// import 'package:o_connect/core/screen_configs.dart';
// import 'package:o_connect/ui/utils/colors/colors.dart';
// import 'package:o_connect/ui/utils/images/images.dart';
// import 'package:o_connect/ui/utils/replykit_channel.dart';
// import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
// import 'package:o_connect/ui/views/meeting/model/model.dart';
// import 'package:o_connect/ui/views/meeting/providers/base_meeting_provider.dart';
// import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
// import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
// import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
// import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
// import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
// import 'package:o_connect/ui/views/poll/end_poll.dart';
// import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
// import 'package:o_connect/ui/views/poll/widgets/speaker_end_poll_view.dart';
// import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard.dart';
// import 'package:o_connect/ui/views/push_link/push_link_floating_pop_up.dart';
// import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
// import 'package:o_connect/ui/views/ticker/ticker_widget.dart';
// import 'package:o_connect/ui/views/timer/provider/timer_provider.dart';
// import 'package:o_connect/ui/views/video_audio_player/video_player.dart';
// import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/bgm_audio_player.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/dashboard_floating_pop_ups/call_to_action_floating_pop_up.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/dragger_view.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/grid_view_video_call_view.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/guest_streaming_view.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/meeting_timer.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/minimized_video_call_view.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/qa_view.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/record_screen_widget.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/spotlight_user.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/timer.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_appbar.dart';
// import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_bottom_toolkit.dart';
// import 'package:o_connect/ui/views/whiteboard/presentation/whiteboard_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

// ///Bharat
// class WebinarDashboard extends StatefulWidget {
//   const WebinarDashboard({Key? key}) : super(key: key);

//   @override
//   State<WebinarDashboard> createState() => _WebinarDashboardState();
// }

// class _WebinarDashboardState extends State<WebinarDashboard> with TickerProviderStateMixin, WidgetsBindingObserver {
//   late ScreenshotController screenshotController;
//   bool pipAvailable = false;

//   @override
//   void initState() {
//     context.read<MeetingEmojiProvider>().setTickerProvider(this);
//     screenshotController = context.read<WebinarProvider>().createScreenshotController();
//     // context.read<MeetingRoomProvider>().setReplyKitChannel = ReplayKitChannel();
//     print("--------------------");
//     // context.read<WebinarProvider>().pipInstance.enable(
//     //             ios: const FlPiPiOSConfig(
//     //                 enabledWhenBackground: true,
//     //                 packageName: null),
//     //             android: const FlPiPAndroidConfig(
//     //                 enabledWhenBackground: true,
//     //                 aspectRatio: Rational.vertical()));
//     WakelockPlus.enable();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // context.read<MeetingRoomProvider>().replayKitChannel= null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Consumer2<MeetingEmojiProvider, AppGlobalStateProvider>(
//         builder: (_, meetingEmojiProvider, appState, child) {
//           return AbsorbPointer(
//             /// Disable click if not connected to any network
//             absorbing: !appState.isConnected,
//             child: Stack(
//               children: [
//                 PiPBuilder(builder: (PiPStatusInfo? status) {
//                   PiPStatus pipStatus = (status?.status ?? PiPStatus.disabled);

//                   switch (pipStatus) {
//                     case PiPStatus.enabled:
//                       return const SpotlightWidget();
//                     case PiPStatus.disabled:
//                       return Positioned.fill(
//                         child: Scaffold(
//                           resizeToAvoidBottomInset: false,
//                           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                           drawerEnableOpenDragGesture: false,
//                           appBar: const WebinarAppbar(),

//                           /// Screen shot
//                           body: Screenshot(
//                             controller: screenshotController,
//                             child: Stack(
//                               children: [
//                                 /// Background theme
//                                 const _WebinarBackground(),

//                                 /// Main content view.
//                                 const Column(
//                                   children: [
//                                     /// Contains meeting countdown timer, call to action, bgm, timer etc...
//                                     _WebinarTopView(),

//                                     /// Contains active page, such as presentation, video view etc..
//                                     Expanded(
//                                       child: WebinarMiddleView(),
//                                     ),

//                                     /// Contains meeting controls
//                                     WebinarBottomToolkit(),
//                                   ],
//                                 ),

//                                 Consumer3<PeersProvider, WebinarProvider, ParticipantsProvider>(builder: (_, provider, webinar, participant, __) {
//                                   if ((provider.peers.length >= 2 && webinar.isGridView) || participant.myRole == UserRole.guest) return const SizedBox();
//                                   return const DraggerView(child: MinimizedVideoCallView());
//                                 }),

//                                 /// Emoji
//                                 ...meetingEmojiProvider.animatedEmojieWidgets.map(
//                                   (e) => SlideTransition(
//                                     position: e.slideAnimation,
//                                     child: FadeTransition(
//                                       opacity: e.fadeAnimation,
//                                       child: e.child,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     case PiPStatus.unavailable:
//                       return Container(
//                         color: Colors.blue,
//                         height: 100,
//                         width: 100,
//                       );
//                   }
//                 }),

//                 // Place black screen on top of the dashboard, if not connected to internet
//                 if (!appState.isConnected) Container(color: Colors.black.withOpacity(0.5)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class WebinarMiddleView extends StatelessWidget {
//   const WebinarMiddleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (context, webinar, participantProvider, child) {
//       var userRole = participantProvider.myRole;

//       if (userRole == UserRole.unknown) return const SizedBox();

//       if (webinar.isGridView) {
//         return const Column(
//           children: [
//             Expanded(child: GridViewVideoCallView()),
//             TickerWidget(),
//           ],
//         );
//       }

//       Widget child;

//       switch (webinar.activePage) {
//         case ActivePage.presentation:
//           child = PresentationWhiteboardScreen(
//             height: context.whiteboardHeight,
//           );
//           break;
//         case ActivePage.poll:
//           child = participantProvider.myRole == UserRole.host || context.read<PollProvider>().pollListeners.resultsShared ? const EndPollScreen() : const SpeakerEndPollView();
//           break;
//         case ActivePage.qna:
//           child = QAView();
//           break;
//         case ActivePage.videoPlayer:
//           child = const VideoPlayerScreen();
//           break;
//         case ActivePage.whiteboard:
//           child = WhiteboardScreen(height: context.whiteboardHeight);
//           break;
//         case ActivePage.audioVideo:
//           if (userRole == UserRole.guest) {
//             child = Center(child: GuestStreamingView(meetingId: participantProvider.meeting.id!));
//           } else {
//             child = const SpotlightWidget();
//           }

//           break;
//       }

//       return Column(
//         children: [
//           Expanded(child: child),
//           const TickerWidget(),
//         ],
//       );
//     });
//   }
// }

// class _WebinarTopView extends StatelessWidget {
//   const _WebinarTopView();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const MeetingCountdownTimerWidget(),
//             Consumer2<WebinarProvider, ParticipantsProvider>(
//               builder: (_, provider, participantProvider, __) {
//                 var myRole = participantProvider.myRole;
//                 if (myRole == UserRole.unknown) {
//                   return const SizedBox();
//                 }

//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       if (participantProvider.handRiseCount != 0) const HandRiseWidget(),
//                       const _SettingsIcon(),
//                     ],
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//         Consumer2<WebinarProvider, ParticipantsProvider>(
//           builder: (_, provider, participantProvider, __) {
//             final activeTopActions = provider.activeTopActions;
//             if (participantProvider.myRole == UserRole.unknown) {
//               return const SizedBox.shrink();
//             }

//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 children: [
//                   if (activeTopActions.contains(MeetingAction.callToAction))
//                     CollapsibleWidget(
//                       expandedWidget: const CallToActionFloatingPopUp(),
//                       icon: SvgPicture.asset(AppImages.callToAction_icon),
//                     ),
//                   if (activeTopActions.contains(MeetingAction.pushLink))
//                     CollapsibleWidget(
//                       expandedWidget: const PushLinkFloatingPopUp(),
//                       icon: SvgPicture.asset(AppImages.shareLink),
//                     ),
//                   if (activeTopActions.contains(MeetingAction.bgm))
//                     CollapsibleWidget(
//                       expandedWidget: const BGMAudioPlayer(),
//                       icon: SvgPicture.asset(AppImages.bgm),
//                     ),
//                   if (activeTopActions.contains(MeetingAction.timer))
//                     CollapsibleWidget(
//                       expandedWidget: const ParticipantTimer(),
//                       icon: SvgPicture.asset(AppImages.timer_Icon),
//                     ),
//                   if (activeTopActions.contains(MeetingAction.recording))
//                     CollapsibleWidget(
//                       expandedWidget: const RecordScreenWidget(),
//                       icon: SvgPicture.asset(AppImages.record),
//                     ),
//                 ].withHs(6).toList(),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class CollapsibleWidget extends StatefulWidget {
//   const CollapsibleWidget({super.key, required this.expandedWidget, required this.icon});

//   final Widget expandedWidget;
//   final Widget icon;

//   @override
//   State<CollapsibleWidget> createState() => _CollapsibleWidgetState();
// }

// class _CollapsibleWidgetState extends State<CollapsibleWidget> {
//   bool expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
//       return DecoratedBox(
//         decoration: BoxDecoration(
//           color: webinarThemesProviders.colors.cardColor,
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4.0),
//           child: Row(
//             children: [
//               if (!expanded)
//                 DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: webinarThemesProviders.colors.itemColor,
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: widget.icon,
//                     ),
//                   ),
//                 ),
//               if (expanded) widget.expandedWidget,
//               SizedBox(width: expanded ? 6.w : 12.w),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     expanded = !expanded;
//                   });
//                 },
//                 child: Icon(
//                   expanded ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
//                   color: webinarThemesProviders.colors.textColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

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

// class HandRiseWidget extends StatelessWidget {
//   const HandRiseWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer3<ParticipantsProvider, HandRaiseProvider, WebinarThemesProviders>(builder: (_, participantsProvider, handRaiseProvider, webinarThemesProviders, __) {
//       return Container(
//         height: 30.h,
//         width: 160.w,
//         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.r)), color: webinarThemesProviders.colors.itemColor),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "${handRaiseProvider.handRiseUserName.last.toString() ?? ""}    (${participantsProvider.handRiseCount.toString()})",
//                 style: w400_12Poppins(color: webinarThemesProviders.colors.textColor),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               ),
//             ),
//             if (participantsProvider.myHubInfo.isHostOrActiveHost) ...[
//               width15,
//               GestureDetector(
//                 onTap: () {
//                   context.read<HandRaiseProvider>().lowerHandForAll();
//                 },
//                 child: Container(
//                   height: 25.h,
//                   width: 25.h,
//                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.r)), color: webinarThemesProviders.colors.buttonColor),
//                   child: Center(
//                     child: Text(
//                       "✋",
//                       style: w400_12Poppins(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       );
//     });
//   }
// }

// class _WebinarBackground extends StatelessWidget {
//   const _WebinarBackground();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WebinarThemesProviders>(builder: (_, provider, __) {
//       return SizedBox(
//         height: ScreenConfig.height,
//         child: provider.selectedWebinarTheme == null || provider.selectedWebinarTheme!.backgroundImageUrl == null
//             ? null
//             : Image.network(
//                 Provider.of<WebinarThemesProviders>(
//                   context,
//                   listen: false,
//                 ).selectedWebinarTheme!.backgroundImageUrl!,
//                 fit: BoxFit.cover,
//               ),
//       );
//     });
//   }
// }

// extension WidgetListExt on Iterable<Widget> {
//   Iterable<Widget> withHs(double width) {
//     return expand((element) => [element, SizedBox(width: width)]);
//   }
// }
