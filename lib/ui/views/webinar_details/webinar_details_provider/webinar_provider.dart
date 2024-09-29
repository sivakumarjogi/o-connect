import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_pip/fl_pip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/providers/calculator_provider.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/resound_provider.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/bgm/providers/bgm_provider.dart';
import 'package:o_connect/ui/views/call_to_action/call_to_action_pop_up.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/chat_screen.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/emojis/emojis_view.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/recording_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/screen_shot.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/poll/poll_screen.dart';
import 'package:o_connect/ui/views/presentation/presentation_popup.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/prompter/prompter_view.dart';
import 'package:o_connect/ui/views/push_link/push_link.dart';
import 'package:o_connect/ui/views/resound/resound_view.dart';
import 'package:o_connect/ui/views/share_files/sharefiles_pop_up.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/themes/themes_pop_up.dart';
import 'package:o_connect/ui/views/ticker/ticker_popup.dart';
import 'package:o_connect/ui/views/timer/timer_pop_up.dart';
import 'package:o_connect/ui/views/video_audio_player/video_player_popup.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/break_time_popup.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/hand_raise_pop_up.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/webinar_bottom_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/enum/view_state_enum.dart';
import '../../../../core/models/auth_models/generate_token_o_connect_model.dart';
import '../../../../core/service/api_helper/api_helper.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/user_cache_service.dart';
import '../../../utils/base_urls.dart';
import '../../bgm/bgm_pop_up.dart';
import '../../home_screen/home_screen_provider/home_screen_provider.dart';
import '../../invite/invites_screen.dart';
import '../../meeting/data/meeting_room_repository.dart';
import '../../meeting/model/meeting_data_response/data.dart';
import '../../meeting/providers/base_meeting_provider.dart';
import '../../seaker_request/speaker_request.dart';

class WebinarProvider extends BaseProvider with MeetingUtilsMixin {
  bool isGridView = false;

  late ScreenShotService _screenShotService;

  WebinarProvider() {
    _screenShotService = ScreenShotService(this);
  }

  int virtualThemeIndex = -1;
  String? selectedThemeImage;
  String? selectedVirtualImage;
  var activeFuture = WebinarTopFutures.initialAction;

  bool isScreenShare = false;
  bool isPresent = false;

  ScreenshotController screenshotController = ScreenshotController();
  FlPiP pipInstance = FlPiP();

  /// Main content visible in the meeting screen
  ActivePage activePage = ActivePage.audioVideo;
  HubUserData? activePageBy;

  /// Content visible on top of the main content
  Set<MeetingAction> activeTopActions = {};

  /// Content visible on top of the main content
  Set<MeetingAction> activeHeaderActions = {};

  @Deprecated('do not use this. this will be removed later. user activePage to display whiteboard')
  bool isWhiteboardView = false;

  bool isStartedRecording = false;

  bool isExpandedWebinarScreen = false;

  /// List of meeting actions allowed for this user. These can change during the meeting
  List<WebinarButtonToolkitModel> allowedActions = [];

  ///New bottom Navigation Icons List
  List<WebinarDashBoardBottomBarImagesModel> webinarBottomBarAllowedActions = [];
  List<WebinarDashBoardBottomBarImagesModel> webinarAllowedFeatures = [];
  List<WebinarDashBoardBottomBarImagesModel> webinarAllowedMoreOptions = [];

  List<WebinarTopViewItemsModel> webinarTopViewItems = [];

  bool showMoreFeaturesPopUp = false;
  bool showWebinarMoreOptionsPopUp = false;

  // late ScreenshotController screenshotController;

  ScreenshotController createScreenshotController() {
    screenshotController = ScreenshotController();
    return screenshotController;
  }

  void setActivePage(ActivePage page) {
    activePage = page;
    notifyListeners();
  }

  void disableActiveFuture() {
    activeFuture = WebinarTopFutures.initialAction;
    notifyListeners();
  }

  void updateActiveFuture(value) {
    switch (value) {
      case WebinarTopFutures.callToAction:
        activeFuture = WebinarTopFutures.callToAction;
        break;
      case WebinarTopFutures.pushLink:
        activeFuture = WebinarTopFutures.pushLink;
        break;
      case WebinarTopFutures.timer:
        activeFuture = WebinarTopFutures.timer;
        break;
      case WebinarTopFutures.record:
        context.read<RecordingProvider>().toggleRecording(false, value);
        activeFuture = WebinarTopFutures.record;
        break;
      case WebinarTopFutures.screenShare:
        activeFuture = WebinarTopFutures.screenShare;
        break;
      case WebinarTopFutures.bgm:
        activeFuture = WebinarTopFutures.bgm;
        break;
      case WebinarTopFutures.initialAction:
        activeFuture = WebinarTopFutures.initialAction;
        break;
    }
    notifyListeners();
  }

  void setActivePageBy(HubUserData? by) {
    activePageBy = by;
    notifyListeners();
  }

  whiteboardView() {
    isWhiteboardView = true;
    isScreenShare = false;
    setActivePage(ActivePage.whiteboard);
    notifyListeners();
  }

  void updateAllowedActions(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
    String? from,
  }) {
    debugPrint("UPDATING ALLOWED ACTIONS FROM: $from");
    allowedActions = _getAllowedActions(role, allowAudio: allowAudio, allowVideo: allowVideo);
    notifyListeners();
  }

  void updateWebinarTopViewItemAction(UserRole role, {String? from}) {
    webinarTopViewItems = _getWebinarTopViewItemActions(role);
    notifyListeners();
  }

  void updateNewBottomBarAllowedActions(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
    String? from,
  }) {
    webinarBottomBarAllowedActions = _getNewAllowedActions(role);
    notifyListeners();
  }

  void updatedAllowedFeatures(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
    String? from,
  }) {
    webinarAllowedFeatures = _getAllowedFeatures(role);
    notifyListeners();
  }

  void updatedAllowedMoreOptions(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
    String? from,
  }) {
    webinarAllowedMoreOptions = _getAllowedMoreOptions(role);
    notifyListeners();
  }
  final MeetingRoomRepository templateRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );
  Future getNewAttendee (context) async{

    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");
    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    String getMeetingKey = context.read<HomeScreenProvider>().getMeetingKey.toString();
     addNewAttendee(userData, meeting, "india", getMeetingKey);

  }
  Future<NewAttendeeResponse> addNewAttendee(
      GenerateTokenUser user,
      MeetingData meeting,
      String countryName,
      String userKey,
      ) async {

    final payload = {
      'country': countryName,
      'user_id': user.id,
      'meeting_id': meeting.id,
      'meeting_name': meeting.meetingName,
      'user_name': user.userName,
      'email': user.userEmail,
      'is_organizer': user.id == meeting.userId,
      'is_presenter': false,
      'is_speaker': meeting.guestKey == userKey ? false : true,
    };

    print("payloaddddddddddddddddddd   $payload");

    NewAttendeeResponse attendData = await templateRepo.addNewAttendee(payload);
    print("the attendee details are the ${attendData.data?.userId ?? "Nooo"} && ${attendData.data.toString()}");

    return attendData;
  }

  void setupHubsocketListeners(UserRole userRole, BuildContext context) {
    final context = navigationKey.currentContext!;
    final meetingRoomProvider = context.read<MeetingRoomProvider>();

    // updateNewBottomBarAllowedActions(userRole, from: "INITIAL");

    ///New Allowed Actions Updating
    updateWebinarTopViewItemAction(userRole, from: "INITIAL");
    updateNewBottomBarAllowedActions(userRole, from: "INITIAL");
    updatedAllowedFeatures(userRole, from: "INITIAL");
    updatedAllowedMoreOptions(userRole, from: "INITIAL");

    meetingRoomProvider.hubSocket.socket?.on('commandResponse', (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      final data = decoded['data'];
      final command = data['command'];

      if (command == 'singleAccess') {
        getNewAttendee(context);
        print("myroleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${context.read<ParticipantsProvider>().myRole}");



        final type = data['type'];
        if (['mch'].contains(type) && data['id'] == meetingRoomProvider.userData.id) {

          final value = data['value'];
          final activeHost = data['activeHost'];
          var currentRoleOfMe = context.read<ParticipantsProvider>().myRole;
          bool makeCallBacksNull = currentRoleOfMe == UserRole.speaker || currentRoleOfMe == UserRole.guest || currentRoleOfMe == UserRole.tempBlocked || currentRoleOfMe == UserRole.unknown;
          log("makeCallBacksNull $makeCallBacksNull");
          updateWhiteBoardPresentationCallBacks(
            makeNull: makeCallBacksNull,
          );
          if (activeHost == 'Active-Host') {
            // Host made me active host
            if (value) {
              // updateAllowedActions(UserRole.activeHost, from: "active host");
              updateNewBottomBarAllowedActions(UserRole.activeHost, from: "active host");
              updatedAllowedMoreOptions(UserRole.activeHost, from: "active host");
            } else {
              final originalRole = context.read<MeetingRoomProvider>().userRole;
              if (originalRole != UserRole.host || originalRole != UserRole.coHost) {}
              updateNewBottomBarAllowedActions(originalRole, from: "back to original from active host");
            }
          } else if (!activeHost) {
            // host made me co-host
            if (value) {
              updateNewBottomBarAllowedActions(UserRole.coHost, from: "cohost");
              updatedAllowedMoreOptions(UserRole.coHost, from: "cohost");
            } else {
              final originalRole = context.read<MeetingRoomProvider>().userRole;
              updateNewBottomBarAllowedActions(originalRole, from: "back to original from cohost");
            }
          }
        }
      } else if (command == 'addToPanel') {
        final mode = data['mode'];
        final userId = data['id'];
        // Host made me a speaker
        if (mode == 'guestList' && userId == meetingRoomProvider.userData.id) {
          updateAllowedActions(UserRole.speaker, from: "host made me speaker");
        }
        // Host made me a guest
        else if (mode == 'panelList' && userId == meetingRoomProvider.userData.id) {
          updateAllowedActions(UserRole.guest, from: 'host made me guest');
        }
      }
    });
  }

  Future<void> updateWhiteBoardPresentationCallBacks({bool makeNull = false}) async {
    ActivePage activePage = context.read<WebinarProvider>().activePage;
    if (activePage == ActivePage.whiteboard) {
      WhiteboardProvider whiteboardProvider = context.read<WhiteboardProvider>();
      if (whiteboardProvider.webViewController != null) {
        await whiteboardProvider.updateCallBacks(
          whiteboardProvider.webViewController!,
          makeNull: makeNull,
        );
      }
    } else if (activePage == ActivePage.presentation) {
      PresentationWhiteBoardProvider presentationWhiteBoardProvider = context.read<PresentationWhiteBoardProvider>();
      if (presentationWhiteBoardProvider.presentationWebViewController != null) {
        presentationWhiteBoardProvider.updateCallBacks(
          presentationWhiteBoardProvider.presentationWebViewController!,
          makeNull: makeNull,
        );
      }
    }
  }

  /// Returns the list of actions allowed for a role.
  /// Note: Order of if conditions is important
  List<WebinarButtonToolkitModel> _getAllowedActions(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
  }) {
    print("ROLE: $role");
    if (role == UserRole.unknown) return [];

    final context = navigationKey.currentContext!;
    final participantProvider = context.read<ParticipantsProvider>();
    final hostOrActiveHost = (role == UserRole.host || role == UserRole.activeHost);

    final bool shouldEnableAudioForSpeaker = !hostOrActiveHost && participantProvider.globalMicOn && allowAudio;
    final bool shouldEnableVideoForSpeaker = !hostOrActiveHost && participantProvider.globalVideoOn && allowVideo;
    final bool isGlobalEmojiEnabled = !hostOrActiveHost && participantProvider.globalEmojiOn;

    final chat = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.chat,
      buttonIcon: AppImages.chat,
      onTap: () {
        if (Provider.of<ParticipantsProvider>(context, listen: false).globalChatOn == true) {
          context.push(const ChatScreen(isFromQAndAScreen: false));
        } else {
          CustomToast.showErrorToast(msg: "Host disable chat");
        }
      },
    );
    final prompter = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.prompter,
      buttonIcon: AppImages.prompter,
      onTap: () => customShowDialog(
        context,
        const PrompterPopUp(),
      ),
    );
    final emoji = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.emoji,
      buttonIcon: AppImages.emoji,
      onTap: () => customShowDialog(context, const Emojis()),
    );
    final screenshot = WebinarButtonToolkitModel(
      buttonText: "Screen Capture",
      buttonIcon: AppImages.screencapture,
      onTap: () {
        context.read<WebinarProvider>()._screenShotService.captureScreenshot(screenshotController);
      },
    );

    if (role == UserRole.tempBlocked) {
      return [prompter, screenshot];
    }
    // print("roleeeeeeeeeeeeeeeeeeeeee  $role");
    // print("roleeeeeeeeeeeeeeeeeeeeee  ${UserRole.guest}");
    if (role == UserRole.guest) {
      return [chat, prompter, screenshot, if (isGlobalEmojiEnabled) emoji];
    }

    final meetingProvider = context.read<MeetingRoomProvider>();

    final mic = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.mic,
      buttonIcon: meetingProvider.isMyMicOn ? AppImages.mic_icon : AppImages.mic_off_icon,
      onTap: allowAudio ? () => meetingProvider.toggleAudio() : () => CustomToast.showInfoToast(msg: "Mic is disabled by host"),
    );
    final video = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.video,
      buttonIcon: meetingProvider.isMyVideoOn ? AppImages.cam_icon : AppImages.cam_off_icon,
      onTap: allowVideo ? () => meetingProvider.toggleVideo() : () => CustomToast.showInfoToast(msg: "Video is disabled by host"),
    );
    final virtualBg = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.virtualBG,
      buttonIcon: AppImages.background,
      onTap: () {
        CustomToast.showInfoToast(msg: "Coming soon");
        // customShowDialog(context, const VirtualBGPopUp(), height: MediaQuery.of(context).size.height * 0.7);
      },
    );
    final handRise = WebinarButtonToolkitModel(
      buttonText: ConstantsStrings.handRaise,
      buttonIcon: AppImages.handRaiseIcon,
      onTap: () {
        context.read<HandRaiseProvider>().handRaiseGlobalSetStatus();
      },
    );
    if (role == UserRole.guest) {
      return [chat, prompter, screenshot, if (isGlobalEmojiEnabled) emoji];
    }

    print("dfkjdfhkshfksdhfksfjsf $isGlobalEmojiEnabled");
    if (role == UserRole.speaker) {
      return [
        if (shouldEnableAudioForSpeaker) mic,
        if (shouldEnableVideoForSpeaker) video,
        chat,
        handRise,
        if (isGlobalEmojiEnabled) emoji,
        // virtualBg,
        prompter,
        screenshot,
      ];
    }
    if (role == UserRole.tempBlocked) {
      return [prompter, screenshot];
    }

    return List.of([
      mic,
      video,
      chat,
      if (role == UserRole.host)
        WebinarButtonToolkitModel(
          buttonText: ConstantsStrings.record,
          buttonIcon: AppImages.record,
          onTap: () {
            // context.read<RecordingProvider>().toggleRecording();
          },
        ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.invite,
        buttonIcon: AppImages.invite_new,
        onTap: () => customShowDialog(context, const InviteScreen()),
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.presentation,
        buttonIcon: AppImages.presentation,
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.presentation,
            onProceed: () {
              showPresentationPopUp(context);
            },
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.audioAndVideo,
        buttonIcon: AppImages.audio_video,
        onTap: () {
          // CustomToast.showInfoToast(msg: "Coming soon");
          handleOpenAction(
            current: activePage,
            target: ActivePage.videoPlayer,
            onProceed: () {
              customShowDialog(context, const VideoPlayerPopUpScreen());
            },
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.whiteboard,
        buttonIcon: AppImages.whiteboard,
        onTap: () {
          // CustomToast.showInfoToast(msg: "Coming soon");

          handleOpenAction(
            current: activePage,
            target: ActivePage.whiteboard,
            onProceed: () async {
              await context.read<WhiteboardProvider>().whiteBoardConnectionEstablish(context: context);
            },
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: !isScreenShare ? ConstantsStrings.stopScreenShare : ConstantsStrings.screenShare,
        buttonIcon: !isScreenShare ? AppImages.screenshare : AppImages.emoji,
        highlight: isScreenShare,
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.whiteboard,
            onProceed: () async {
              return context.read<MeetingRoomProvider>().toggleScreenShare();
            },
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.poll,
        buttonIcon: AppImages.poll,
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.poll,
            onProceed: () => customShowDialog(context, const PollScreen(), height: 0.7.screenHeight),
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.qAndA,
        buttonIcon: AppImages.question,
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.qna,
            onProceed: () => context.read<ChatProvider>().questionAndAnsMethod(context),
          );
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.callToAction,
        buttonIcon: AppImages.callToAction_icon,
        onTap: () {
          /* CustomToast.showInfoToast(msg: "Coming soon"); */
          if (activeTopActions.contains(MeetingAction.callToAction)) {
            CustomToast.showErrorToast(msg: 'Please close existing call to action');
          } else {
            customShowDialog(context, const CallToActionPopUp(), height: MediaQuery.of(context).size.height * 0.7);
          }
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: "Push Link",
        buttonIcon: AppImages.shareLink,
        onTap: () => customShowDialog(context, const PushLinkPopup()),
      ),
      virtualBg,
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.themes,
        buttonIcon: AppImages.themesIcon,
        onTap: () {
          customShowDialog(context, const ThemesPopUp(), height: ScreenConfig.height * 0.7);
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.bgm,
        buttonIcon: AppImages.bgm,
        onTap: () async {
          Provider.of<BgmProvider>(context, listen: false).getAllBGMs();
          customShowDialog(context, const BGMPopUp(), height: ScreenConfig.height * 0.71);
        },
      ),
      prompter,
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.timer,
        buttonIcon: AppImages.timer_Icon,
        onTap: () {
          if (activeTopActions.contains(MeetingAction.timer)) {
            CustomToast.showErrorToast(msg: 'You are already accessing timer');
          } else {
            customShowDialog(context, const TimerPopUp(), height: 0.5.screenHeight);
          }
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.calculator,
        buttonIcon: AppImages.calculator,
        onTap: () => context.read<CalculatorProvider>().setCalculatorIsOpen(),
      ),
      screenshot,
      emoji,
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.resound,
        buttonIcon: AppImages.resound,
        onTap: () async {
          context.read<ResoundProvider>().setResoundWindowIsOpen();
          Provider.of<CommonProvider>(context, listen: false).getResound();
          customShowDialog(context, const Resound(), height: 0.65.screenHeight);
        },
      ),
      WebinarButtonToolkitModel(
        buttonText: ConstantsStrings.ticker,
        buttonIcon: AppImages.ticker,
        onTap: () {
          customShowDialog(context, const TickerPopup());
        },
      ),
    ]);
  }

  List<WebinarTopViewItemsModel> _getWebinarTopViewItemActions(UserRole role) {
    final handRise = WebinarTopViewItemsModel(
        icon: AppImages.handraiseIcon,
        onTap: () {
          customShowDialog(context, const HandRisePopUp(), height: MediaQuery.of(context).size.height * 0.5);
        });
    final speakerRequest = WebinarTopViewItemsModel(icon: AppImages.speakerRequestIcon, onTap: () => customShowDialog(context, const SpeakerRequest(), height: ScreenConfig.height * 0.7));
    final breakTime = WebinarTopViewItemsModel(
        icon: AppImages.breakTimeIcon,
        onTap: () {
          customShowDialog(context, const BreakTimePopup(), height: MediaQuery.of(context).size.height * 0.3);
        });
    final settings = WebinarTopViewItemsModel(
        icon: AppImages.webinarSettingsIcon,
        onTap: () {
          CustomToast.showInfoToast(msg: "Coming soon...");
        }); // WebinarTopViewItemsModel(icon: AppImages.moreIcon, onTap: () {})
    if (role == UserRole.speaker || role == UserRole.guest) {
      return List.of([
        settings,
      ]);
    }

    return List.of([
      handRise,
      speakerRequest,
      breakTime,
      settings,
    ]);
  }

  List<WebinarDashBoardBottomBarImagesModel> _getNewAllowedActions(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
  }) {
    print("ROLE: $role");
    if (role == UserRole.unknown) return [];

    final context = navigationKey.currentContext!;
    final participantProvider = context.read<ParticipantsProvider>();
    final hostOrActiveHost = (role == UserRole.host || role == UserRole.activeHost);

    final bool shouldEnableAudioForSpeaker = !hostOrActiveHost && participantProvider.globalMicOn && allowAudio;
    final bool shouldEnableVideoForSpeaker = !hostOrActiveHost && participantProvider.globalVideoOn && allowVideo;

    final meetingProvider = context.read<MeetingRoomProvider>();

    final features = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.moreFeaturesIcon,
        iconTitle: "Features",
        onTap: () {
          showMoreFeature();
        });
    final members = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.membersIcon,
        iconTitle: "Members",
        onTap: () {
          Navigator.pushNamed(context, RoutesManager.allParticipantsPage);
        });
    var mic = WebinarDashBoardBottomBarImagesModel(
      icon: meetingProvider.isMyMicOn ? AppImages.webinarMicOnIcon : AppImages.webinarMicOffIcon,
      iconTitle: "Mic",
      onTap: allowAudio ? () => meetingProvider.toggleAudio() : () => CustomToast.showInfoToast(msg: "Mic is disabled by host"),
    );
    var cam = WebinarDashBoardBottomBarImagesModel(
      icon: meetingProvider.isMyVideoOn ? AppImages.webinarVideoOnIcon : AppImages.webinarVideoOffIcon,
      iconTitle: "Cam",
      onTap: allowVideo ? () => meetingProvider.toggleVideo() : () => CustomToast.showInfoToast(msg: "Video is disabled by host"),
    );
    var chat = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.chatIcon,
        iconTitle: "Chat",
        onTap: () {
          if (Provider.of<ParticipantsProvider>(context, listen: false).globalChatOn == true) {
            context.push(const ChatScreen(isFromQAndAScreen: false));
          } else {
            CustomToast.showErrorToast(msg: "Host disable chat");
          }
        });

    var handRise = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.handraiseIcon,
        iconTitle: "Hand Raise",
        onTap: () {
          context.read<HandRaiseProvider>().handRaiseGlobalSetStatus();
        });

    var more = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.moreIcon,
        iconTitle: "More",
        onTap: () {
          showWebinarMoreOptions();
        });
    final emojies = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.emojiIcon,
        iconTitle: "Reactions",
        onTap: () {
          customShowDialog(context, const Emojis());
        });
    final promter = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.promterIcon,
        iconTitle: "Prompter",
        onTap: () => customShowDialog(
              context,
              const PrompterPopUp(),
            ));
    final screenShot = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.screenShotIcon,
        iconTitle: "Capture",
        onTap: () {
          print("bajdahdakdhak   ${context.read<MeetingRoomProvider>().globalAccessStatus.data!.globalSpeakerAccess}");
          context.read<WebinarProvider>()._screenShotService.captureScreenshot(screenshotController);
        });
    final speakerRequest = WebinarDashBoardBottomBarImagesModel(icon: "assets/new_ui_icons/all_participants_icons/global_blockuser_off.svg", iconTitle: "Speaker Request", onTap: () => sendRequest());

    if (role == UserRole.tempBlocked) {
      return [promter, screenShot];
    }

    if (role == UserRole.speaker) {
      return [
        members,
        chat,
        if (shouldEnableAudioForSpeaker) mic,
        if (shouldEnableVideoForSpeaker) cam,

        handRise,
        // if (isGlobalEmojiEnabled) emoji,
        // // virtualBg,
        // prompter,
        // screenshot,
        more,
      ];
    }

    print("dslkgjsljglsjglsjlgj ${context.read<ParticipantsProvider>().isSpeakerRequest}");
    if (role == UserRole.guest) {
      return [if (context.read<ParticipantsProvider>().isSpeakerRequest) speakerRequest, promter, screenShot, emojies, members, chat];
    }

    return List.of([
      if (role != UserRole.speaker && role != UserRole.guest) features,
      members,
      mic,
      cam,
      chat,
      more,
    ]);
  }

  sendRequest() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: context.read<WebinarThemesProviders>().bgColor,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Speaker Request",
                  style: w400_14Poppins(color: Colors.white),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel, color: Colors.white)),
              ],
            ),
            height20,
            Divider(
              height: 2.w,
              color: context.read<WebinarThemesProviders>().hintTextColor,
            )
          ],
        ),
        content: Text(
          "Are you sure you want to be a Speaker",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40.h,
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.sp)), color: context.read<WebinarThemesProviders>().hintTextColor),
                margin: EdgeInsets.all(10.sp),
                child: Text(
                  "No",
                  style: w400_14Poppins(color: Colors.white),
                ),
              )),
          InkWell(
              onTap: () {
                context.read<ParticipantsProvider>().requestFromAttend(context).then((value) => Navigator.pop(context));
              },
              child: Container(
                alignment: Alignment.center,
                height: 40.h,
                width: 100.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.sp)), color: Colors.blue),
                margin: EdgeInsets.all(10.sp),
                child: Text(
                  "Yes",
                  style: w400_14Poppins(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

  List<WebinarDashBoardBottomBarImagesModel> _getAllowedMoreOptions(
    UserRole role,
  ) {
    final context = navigationKey.currentContext!;
    final participantProvider = context.read<ParticipantsProvider>();
    final hostOrActiveHost = (role == UserRole.host || role == UserRole.activeHost);
    final bool isGlobalEmojiEnabled = !hostOrActiveHost && participantProvider.globalEmojiOn;

    final screenShot = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.screenShotIcon,
        iconTitle: "Capture",
        onTap: () {
          context.read<WebinarProvider>()._screenShotService.captureScreenshot(screenshotController);
        });
    final emojies = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.emojiIcon,
        iconTitle: "Reactions",
        onTap: () {
          customShowDialog(context, const Emojis());
        });
    final screenShare = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.screenShareOnIcon,
        iconTitle: ConstantsStrings.screenShare,
        highLight: isScreenShare,
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.audioVideo,
            onProceed: () async {
              setIsScreenshareOn(!isScreenShare);
              context.read<WebinarProvider>().updateActiveFuture(WebinarTopFutures.screenShare);
              context.read<MeetingRoomProvider>().toggleScreenShare();
            },
          );
        });
    final record = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.recordOffIcon,
        iconTitle: "Record",
        onTap: () {
          context.read<RecordingProvider>().toggleRecording(true, context.read<WebinarProvider>().activeFuture);
        });

    final promter = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.promterIcon,
        iconTitle: "Prompter",
        onTap: () => customShowDialog(
              context,
              const PrompterPopUp(),
            ));
    final virtualBG = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.virtualBgIcon,
        iconTitle: "Virtual Image",
        onTap: () {
          CustomToast.showInfoToast(msg: "Coming soon");
        });

    if (role == UserRole.speaker) {
      return [screenShot, if (isGlobalEmojiEnabled) emojies, virtualBG, promter];
    }
    return List.of([screenShot, emojies, screenShare, if (role == UserRole.host) record]);
  }

  List<WebinarDashBoardBottomBarImagesModel> _getAllowedFeatures(
    UserRole role, {
    bool allowAudio = true,
    bool allowVideo = true,
  }) {
    final presentation = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.presentationIcon,
        iconTitle: "Presentation",
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.presentation,
            onProceed: () {
              showPresentationPopUp(context);
            },
          );
        });
    final videoShare = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.videoShareIcon,
        iconTitle: "Video",
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.videoPlayer,
            onProceed: () {
              customShowDialog(context, const VideoPlayerPopUpScreen());
            },
          );
        });
    final whiteBoard = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.whiteBoardIcon,
        iconTitle: "White Board",
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.whiteboard,
            onProceed: () async {
              await context.read<WhiteboardProvider>().whiteBoardConnectionEstablish(context: context);
            },
          );
        });
    final poll = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.pollIcon,
        iconTitle: "Poll",
        onTap: () {
          handleOpenAction(
            current: activePage,
            target: ActivePage.poll,
            onProceed: () => customShowDialog(context, const PollScreen(), height: 0.7.screenHeight),
          );
        });
    final qAndA = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.qAndAIcon,
        iconTitle: "Q&A",
        onTap: () => handleOpenAction(
              current: activePage,
              target: ActivePage.qna,
              onProceed: () => context.read<ChatProvider>().questionAndAnsMethod(context),
            ));
    final callToAction = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.ctaIcon,
        iconTitle: "Call to action",
        onTap: () {
          if (activeTopActions.contains(MeetingAction.callToAction)) {
            CustomToast.showErrorToast(msg: 'Please close existing call to action');
          } else {
            customShowDialog(context, const CallToActionPopUp(), height: MediaQuery.of(context).size.height * 0.7);
          }
        });
    final pushLink = WebinarDashBoardBottomBarImagesModel(
      icon: AppImages.pushLinkIcon,
      iconTitle: "Push Link",
      onTap: () => customShowDialog(context, const PushLinkPopup()),
    );
    final virtualBG = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.virtualBgIcon,
        iconTitle: "Virtual Image",
        onTap: () {
          CustomToast.showInfoToast(msg: "Coming soon");
        });
    final themes = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.themesIcon,
        iconTitle: "Themes",
        onTap: () {
          customShowDialog(context, const ThemesPopUp(), height: ScreenConfig.height * 0.7);
        });
    final bgm = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.bgmICon,
        iconTitle: "BG Music",
        onTap: () {
          Provider.of<BgmProvider>(context, listen: false).getAllBGMs();
          customShowDialog(context, const BGMPopUp(), height: ScreenConfig.height * 0.71);
        });
    final promter = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.promterIcon,
        iconTitle: "Prompter",
        onTap: () => customShowDialog(
              context,
              const PrompterPopUp(),
            ));
    final timer = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.timerNewIcon,
        iconTitle: "Timer",
        onTap: () {
          if (activeTopActions.contains(MeetingAction.timer)) {
            CustomToast.showErrorToast(msg: 'You are already accessing timer');
          } else {
            customShowDialog(context, const TimerPopUp(), height: 0.6.screenHeight);
          }
        });
    final calculator = WebinarDashBoardBottomBarImagesModel(
      icon: AppImages.calculatorNewIcon,
      iconTitle: "Calculator",
      onTap: () => context.read<CalculatorProvider>().setCalculatorIsOpen(),
    );
    final resound = WebinarDashBoardBottomBarImagesModel(
        icon: "assets/new_ui_icons/webinar_dashboard/Resound.svg",
        iconTitle: "Resound",
        onTap: () {
          context.read<ResoundProvider>().setResoundWindowIsOpen();
          Provider.of<CommonProvider>(context, listen: false).getResound();
          customShowDialog(context, const Resound(), height: 0.65.screenHeight);
        });
    final ticker = WebinarDashBoardBottomBarImagesModel(
        icon: AppImages.tickerIcon,
        iconTitle: "Ticker",
        onTap: () {
          customShowDialog(context, const TickerPopup());
        });
    final shareFiles = WebinarDashBoardBottomBarImagesModel(
        icon: "assets/new_ui_icons/webinar_dashboard/share.svg", iconTitle: "Share File", onTap: () => customShowDialog(context, const ShareFilesPopUp(), height: 0.5.screenHeight));
    return List.of([presentation, videoShare, whiteBoard, poll, qAndA, callToAction, pushLink, virtualBG, themes, bgm, promter, timer, calculator, resound, ticker, shareFiles]);
  }

  void showMoreFeature() {
    if (showWebinarMoreOptionsPopUp) {
      showWebinarMoreOptionsPopUp = false;
    }
    showMoreFeaturesPopUp = !showMoreFeaturesPopUp;
    notifyListeners();
  }

  void showWebinarMoreOptions() {
    if (showMoreFeaturesPopUp) {
      showMoreFeaturesPopUp = false;
    }
    showWebinarMoreOptionsPopUp = !showWebinarMoreOptionsPopUp;
    notifyListeners();
  }

  void toggleExpandedFullScreenVideoCall() {
    isExpandedWebinarScreen = !isExpandedWebinarScreen;
    notifyListeners();
  }

  callNotify() {
    notifyListeners();
  }

  void toggleVideoCallViews() {
    isGridView = !isGridView;
    notifyListeners();
  }

  void setIsRecording(bool value) {
    isStartedRecording = value;
    notifyListeners();
  }

  void setIsScreenshareOn(bool value) {
    isScreenShare = !isScreenShare;
    notifyListeners();
  }

  void setIsGridView(bool value) {
    isGridView = value;
    notifyListeners();
  }

  void resetState() {
    activeHeaderActions.clear();
    activeTopActions.clear();
    selectedVirtualImage = null;
    isGridView = false;
    isExpandedWebinarScreen = false;
    isScreenShare = false;
  }
}

class ThemesList {
  String? name;
  String? image;

  ThemesList({this.name, this.image});
}

///Audio&Video popup
class VideosList {
  String path;
  File thumbNail;
  String uploadedUrl;

  VideosList({required this.path, required this.thumbNail, this.uploadedUrl = ""});
}

class WebinarTopViewItemsModel {
  final String icon;
  final VoidCallback onTap;

  const WebinarTopViewItemsModel({required this.icon, required this.onTap});
}

class WebinarDashBoardBottomBarImagesModel {
  final String icon;
  final String iconTitle;
  final VoidCallback onTap;
  final bool highLight;

  const WebinarDashBoardBottomBarImagesModel({required this.icon, required this.iconTitle, required this.onTap, this.highLight = false});
}
