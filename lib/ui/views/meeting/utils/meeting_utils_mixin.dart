import 'package:flutter/material.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/q_and_a_screen.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/model/new_attendee_response/data.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/room_socket.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import '../../pip_views/pip_global_navigation.dart';
import '../providers/meeting_room_provider.dart';

mixin MeetingUtilsMixin {
  HubSocket hubSocket = HubSocket.instance;

  MeetingRoomWebsocket roomSocket = MeetingRoomWebsocket.instance;

  final MeetingRoomRepository globalStatusRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  final MeetingRoomRepository gloablSetRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessSetUrl,
  );

  BuildContext get context => navigationKey.currentContext!;

  MeetingData get meeting => context.read<MeetingRoomProvider>().meeting;

  AttendeeData get attendee => context.read<MeetingRoomProvider>().attendee;

  GenerateTokenUser get userData => context.read<MeetingRoomProvider>().userData;

  HubUserData get myHubInfo => context.read<ParticipantsProvider>().myHubInfo;

  UserRole get myRole => context.read<ParticipantsProvider>().myRole;

  bool get isInPipView => context.read<AppGlobalStateProvider>().isPIPEnabled;

  void addHeaderActionToDashboard(MeetingAction action) {
    context.read<WebinarProvider>().activeHeaderActions.add(action);
    context.read<WebinarProvider>().callNotify();
  }

  void removeHeaderAction(MeetingAction action) {
    context.read<WebinarProvider>().activeHeaderActions.remove(action);
    context.read<WebinarProvider>().callNotify();
  }

  void addTopActionToDashboard(MeetingAction action) {
    context.read<WebinarProvider>().activeTopActions.add(action);
    context.read<WebinarProvider>().callNotify();
  }

  void removeTopAction(MeetingAction action) {
    context.read<WebinarProvider>().activeTopActions.remove(action);
    context.read<WebinarProvider>().callNotify();
  }

  void refreshAllowedActionsUI() {
    context.read<WebinarProvider>().updateAllowedActions(myRole, from: "mixin");
    context.read<WebinarProvider>().updatedAllowedMoreOptions(myRole, from: "mixin");
  }

    final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.meetingBaseUrl,
  );

  void handleOpenAction({
    required ActivePage current,
    required ActivePage target,
    required VoidCallback onProceed,
  }) {
    final isScreensShareOn = context.read<WebinarProvider>().isScreenShare;
    if (current == ActivePage.audioVideo && !isScreensShareOn) {
      onProceed();
    } else if (current == target) {
      if (current == ActivePage.qna) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PIPGlobalNavigation(childWidget: QAndAScreen())));
      } else {
        final webinar = context.read<WebinarProvider>();
        final me = myHubInfo;

        List<Widget> actions = [];
        String content;

        if (me.isHost && webinar.activePageBy?.id != me.id) {
          content = '${webinar.activePageBy?.displayName} is accessing ${current.title}. Do you want to take control of ${current.title}?';
          actions = _buildOkayCancelActions(context.read<WebinarThemesProviders>(), current, context, onProceed);
        } else {
          content = 'You are already accessing ${current.title}';
          actions = [
            CustomButton(buttonText: 'Okay', onTap: context.pop),
          ];
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Icon(Icons.warning_rounded, color: Colors.white),
            content: Text(
              content,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: actions,
          ),
        );
      }
    } else {
      String message = isScreensShareOn ? 'You are accessing Screen Share. Do you want to switch to ${target.title}' : 'You are accessing ${current.title}. Do you want to switch to ${target.title}?';

      showDialog(
        context: context,
        builder: (context2) => Consumer<WebinarThemesProviders>(builder: (context2, webinarThemesProviders, __) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: webinarThemesProviders.colors.cardColor,
            title: const Icon(Icons.warning_rounded, color: Colors.white),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: _buildOkayCancelActions(webinarThemesProviders, current, context2, onProceed),
          );
        }),
      );
    }
  }

  List<Widget> _buildOkayCancelActions(WebinarThemesProviders webinarThemesProviders, ActivePage current, BuildContext context2, VoidCallback onProceed) {
    return [
      CustomButton(
        buttonText: 'Cancel',
        onTap: context.pop,
        buttonColor: Colors.transparent,
        borderColor: Theme.of(context).primaryColor,
      ),
      CustomButton(
        buttonText: 'Yes',
        buttonColor: webinarThemesProviders.colors.buttonColor,
        onTap: () async {
          switch (current) {
            case ActivePage.audioVideo:
              break;
            case ActivePage.presentation:
              await context.read<PresentationWhiteBoardProvider>().closeWhiteBoard();
              break;
            case ActivePage.poll:
              context.read<PollProvider>().endPollGlobalSet();
              break;
            case ActivePage.qna:
              await context.read<ChatProvider>().questionAndAnsClose(context);
              break;
            case ActivePage.videoPlayer:
              context.read<VideoShareProvider>().stopVideoShare();
              break;
            case ActivePage.whiteboard:
              await context.read<WhiteboardProvider>().closeWhiteBoard();
              break;
          }

          if (context.read<WebinarProvider>().isScreenShare) {
            await context.read<MeetingRoomProvider>().toggleScreenShare();
          }

          context.read<WebinarProvider>().setIsGridView(false);

          if (context2.mounted) Navigator.of(context2).pop();
          onProceed();
        },
      ),
    ];
  }

  void showWarningPopUpDialog({required String description}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Icon(Icons.warning_rounded, color: Colors.white),
        content: Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          CustomButton(buttonText: 'Okay', onTap: context.pop),
        ],
      ),
    );
  }
}
