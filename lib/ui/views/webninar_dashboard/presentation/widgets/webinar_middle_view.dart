import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/active_page.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/poll/end_poll.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/poll/widgets/speaker_end_poll_view.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard.dart';
import 'package:o_connect/ui/views/share_files/provider/share_files_provider.dart';
import 'package:o_connect/ui/views/share_files/share_files_speaker_view.dart';
import 'package:o_connect/ui/views/ticker/ticker_widget.dart';
import 'package:o_connect/ui/views/video_audio_player/video_player.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/grid_view_video_call_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/guest_streaming_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/qa_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/spotlight_user.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/timer.dart';
import 'package:o_connect/ui/views/whiteboard/presentation/whiteboard_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum/view_state_enum.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart' as ticker;
import '../../../meeting/providers/meeting_room_provider.dart';
import '../../../push_link/push_link_floating_pop_up.dart';
import '../../bgm_audio_player.dart';
import 'dashboard_floating_pop_ups/call_to_action_floating_pop_up.dart';

class WebinarMiddleView extends StatelessWidget {
  const WebinarMiddleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (context, webinar, participantProvider, child) {
      var userRole = participantProvider.myRole;

      if (userRole == UserRole.unknown) {
        return const SizedBox(
          width: 500,
          height: 300,
        );
      }

      if (webinar.isGridView) {
        return Stack(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.76, child: const GridViewVideoCallView()),
            const ShareFileDownloadFloadingPopUp(),
            Align(alignment: Alignment.center, child: updatedWidget(webinar.activeFuture, context)),
            const Align(alignment: Alignment.bottomCenter, child: TickerWidget()),
          ],
        );
      }

      Widget child;

      switch (webinar.activePage) {
        case ActivePage.presentation:
          child = PresentationWhiteboardScreen(
            height: context.whiteboardHeight,
          );
          break;
        case ActivePage.poll:
          child = participantProvider.myRole == UserRole.host || context.read<PollProvider>().pollListeners.resultsShared ? const EndPollScreen() : const SpeakerEndPollView();
          break;
        case ActivePage.qna:
          child = QAView();
          break;
        case ActivePage.videoPlayer:
          child = const VideoPlayerScreen();
          break;
        case ActivePage.whiteboard:
          child = WhiteboardScreen(height: context.whiteboardHeight);
          break;
        case ActivePage.audioVideo:
          if (userRole == UserRole.guest) {
            child = Center(child: GuestStreamingView(meetingId: participantProvider.meeting.id!));
          } else {
            child = const SpotlightWidget();
          }

          break;
      }

      return Stack(
        alignment: webinar.activeFuture == WebinarTopFutures.screenShare ? Alignment.bottomCenter : Alignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.70, child: child),
          const ShareFileDownloadFloadingPopUp(),
          const Align(alignment: Alignment.bottomCenter, child: TickerWidget()),
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 15.sp,
                    vertical: webinar.activeFuture == WebinarTopFutures.screenShare
                        ? context.read<ticker.MeetingTickerProvider>().displayTicker
                            ? 90.h
                            : 50.h
                        : 0.sp),
                child: updatedWidget(webinar.activeFuture, context),
              )),
        ],
      );
    });
  }

  Widget updatedWidget(value, BuildContext context) {
    if (value == WebinarTopFutures.callToAction) {
      return const CallToActionFloatingPopUp();
    } else if (value == WebinarTopFutures.pushLink) {
      return const PushLinkFloatingPopUp();
    } else if (value == WebinarTopFutures.record) {
      return const SizedBox.shrink();
    } else if (value == WebinarTopFutures.bgm) {
      return const BGMAudioPlayer();
    } else if (value == WebinarTopFutures.screenShare) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: InkWell(
            onTap: () {
              context.read<WebinarProvider>().setIsScreenshareOn(!context.read<WebinarProvider>().isScreenShare);
              context.read<WebinarProvider>().updateActiveFuture(WebinarTopFutures.initialAction);
              context.read<MeetingRoomProvider>().toggleScreenShare();
            },
            child: Container(
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  "Stop Sharing",
                  style: w600_14Poppins(color: Colors.white),
                )),
          ),
        ),
      );
    } else if (value == WebinarTopFutures.timer) {
      return const ParticipantTimer();
    } else {
      return const SizedBox.shrink();
    }
  }
}
