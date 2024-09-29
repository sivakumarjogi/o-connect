import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/models/library_model/presentation_data_model.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/calculator_provider.dart';
import 'package:o_connect/core/providers/emoji_provider.dart';
import 'package:o_connect/core/providers/prompter_provider.dart';
import 'package:o_connect/core/providers/resound_provider.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/bgm/providers/bgm_provider.dart';
import 'package:o_connect/ui/views/call_to_action/providers/dashboard_call_to_action_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/home_screen.dart';
import 'package:o_connect/ui/views/invite/provider/invite_pop_up_provider.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/presentation.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/model/new_attendee_response/data.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/media_devices_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_provider_mixin.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_timer_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/recording_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:o_connect/ui/views/push_link/provider/push_link_provider.dart';
import 'package:o_connect/ui/views/share_files/provider/share_files_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart';
import 'package:o_connect/ui/views/timer/provider/timer_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/break_time/count_down_timer.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/screenshare_alert_popup.dart';
import 'package:provider/provider.dart' as provider;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../dummy_json/home_json.dart';
import '../../chat_screen/providers/chat_provider.dart';
import 'base_meeting_provider.dart';
import 'break_time_helper.dart';

/// Provider which holds the logic for handling meeting room actions.
class MeetingRoomProvider extends BaseMeetingProvider with MeetingUtilsMixin {
  late BreakTimeHelper _breakTimeHelper;

  BreakTimeHelper get breakTimeHelper => _breakTimeHelper;

  MeetingRoomProvider() {
    _breakTimeHelper = BreakTimeHelper(this);
  }

  final logTag = 'MeetingRoomProvider';

  @override
  BuildContext get context => navigationKey.currentContext!;

  /// Represents whether this provider is initialized with meeting information
  /// or not. This will be set once [initialize] has been completed.
  bool initialized = false;

  bool closed = false;

  bool isLoading = false;
  String? error;

  // START: Lobby screen state
  int attendeesWaitingToJoin = 0;
  bool videoOn = false;

  final Set<int> _speakersWaitingToJoin = {};

  void videoStatus() {
    videoOn = !videoOn;
    notifyListeners();
  }

  int get speakersWaitingToJoin => _speakersWaitingToJoin.length;

  // END: Lobby screen state

  /// Current peer id. Will be set in [initialize] method
  late String peerId;

  /// Meeting data that we got via /check-meeting-valid API.
  late GetProfileResponseModel userHeaderInfo;
  @override
  late GenerateTokenUser userData;
  late HubSocketInput hubSocketInput;
  late String userMeetingKey;
  late MeetingGlobalAccessStatusResponse globalAccessStatus;

  // Used to identify, where the requests are coming from
  String origin = 'https://oconnectqa-ui.onpassive.com';

  // Producers which can produce media, such as mic, webcam, screenshare etc..
  Producer? audio;
  Producer? video;
  Producer? screen;
  Producer? localVideoTest;
  RTCVideoRenderer videoRenderer = RTCVideoRenderer();
  RTCVideoRenderer localVideoRenderTest = RTCVideoRenderer();

  bool get isMyMicOn => audio != null && audio?.paused == false;

  bool get isMyVideoOn => video != null && video?.paused == false;

  bool get isMyLocalVideoOn => localVideoTest != null && localVideoTest?.paused == false;

  Peer get peer {
    final myHubInfo = context.read<ParticipantsProvider>().myHubInfo;
    return Peer(
      displayName: myHubInfo.displayName!,
      id: myHubInfo.peerId!,
      countryName: myHubInfo.country!,
      countryFlag: countries[myHubInfo.country!],
      role: myHubInfo.role!,
      audioOnly: false,
      picture: myHubInfo.profilePic ?? "",
      sessionId: currentMeetingSessionId ?? '',
      raisedHand: myHubInfo.handRaise!,
      renderer: videoRenderer,
    );
  }

  @override
  late MeetingData meeting;
  @override
  late AttendeeData attendee;
  String? currentMeetingSessionId;
  String? meetingInitializationError;
  DateTime? meetingStartTime;

  set setAttendee(AttendeeData data) {
    attendee = data;
  }

  Future<void> initialize({
    required String meetingId,
    required String autoGeneratedId,
    required GetProfileResponseModel headerInfo,
    required String userKey,
  }) async {
    try {
      closed = false;
      initialized = false;
      isLoading = true;
      notifyListeners();

      /// Show loading indicator
      context.showLoading();

      /// Load media devices
      await context.read<MediaDevicesProvider>().enumerateDevices();

      userMeetingKey = userKey;
      userHeaderInfo = headerInfo;
      userData = await getUserData();
      print("the user data is the ${userData.toJson()}");

      // Check meeting status and fetch meeting data
      final input = CheckMeetingIsValidInput(
        autoGeneratedId: autoGeneratedId,
        email: userData.userEmail!,
        meetingId: meetingId,
      );

      final res = await meetingRepo.checkMeetingIsValid(input);
      if (res.status == false) {
        _emitErrorAndExit('Unable to validate meeting');
        return;
      }
      print("meeting data for validation   ${res.data.toString()}");

      meeting = res.data!;

      if (meeting.isEventExpired == true) {
        _emitErrorAndExit('Event is expired');
        return;
      } else if (meeting.isMeetingLocked == true && userKey != meeting.hostKey) {
        _emitErrorAndExit("Meeting locked. You can't join");
        return;
      }

      NewAttendeeResponse attendeeRes = await addNewAttendee(userData, meeting, headerInfo.data!.countryName!, userKey);

      print("hellosssssssssssssssssss   ${attendeeRes.data.toString()}");
      if (attendeeRes.status == false) {
        _emitErrorAndExit(attendeeRes.error == "Invalid User" ? "Host permanently blocked you for this meeting, you can not attend the meeting." : "Unable to add attendee");
        return;
      }

      attendee = attendeeRes.data!;

      print("the initial attendee data is the ${attendee.toString()}");

      if (attendee.guestLimitReached == true && userKey == meeting.guestKey) {
        _emitErrorAndExit("Guest limit reached. You can't join");
        return;
      } else if (attendee.speakerLimitReached == true && (userKey == meeting.participantKey || userKey == meeting.hostKey)) {
        _emitErrorAndExit("Speaker limit reached. You can't join");
        return;
      } else if (attendee.limitReached == true) {
        _emitErrorAndExit("Meeting limit reached. You can't join");
        return;
      }
      debugPrint("the meeting id is the ${meeting.id}");
      // Fetch meeting global access state

      final meetingStatus = await fetchMeetingGlobalAccessStatus(meeting.id!);
      if (meetingStatus.data!.globalSpeakerAccess == true) {
        context.read<ParticipantsProvider>().isSpeakerRequest = true;
        notifyListeners();
      }
      globalAccessStatus = meetingStatus;

      final panelCount = await fetchPanelCount(meetingId);
      _speakersWaitingToJoin.addAll(panelCount);
      debugPrint("it reached here");
      // current peer id. randomly generated id.
      peerId = const Uuid().v4();

      // Connect to hub web socket
      _connectToHubSocket(userData, attendee, meetingStatus, headerInfo);

      /// Chat socket connect
      context.read<ChatProvider>().chatSocketConnect(userData, meetingId, meeting);
      context.read<WebinarThemesProviders>().setupDefaultColors();

      /// white board socket connect
      Navigator.of(context).pop();

      bool isMeetingStarted = meeting.isStarted == 1;
      if (isMeetingStarted) {
        meetingStartTime = meetingStatus.data?.eventStatus?.startTime!.toLocal();
      }
      initialized = true;
    } on DioException catch (e, st) {
      Navigator.of(context).pop(); // Hide loading indicator

      _log('exception: ', e, st);

      if (e.response?.data != null) {
        var error = e.response?.data['error'];
        if (error != null) {
          if (error is Map && error['Message'] != null) {
            CustomToast.showErrorToast(msg: error['Message'].toString());
          } else if (error == 'Invalid User') {
            CustomToast.showErrorToast(msg: ConstantsStrings.blockedUserError);
          } else {
            CustomToast.showErrorToast(msg: error.toString());
          }
        } else if (e.response?.data['Message'] != null) {
          CustomToast.showErrorToast(msg: e.response?.data['Message']);
        }
      }
      leaveMeeting();
    } catch (e, st) {
      Navigator.of(context).pop();
      // Hide loading indicator

      dev.log(e.toString(), error: e, stackTrace: st, name: logTag);
      CustomToast.showErrorToast(msg: 'Unable to join the meeting').then((value) {
        leaveMeeting();
      });
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  UserRole get userRole => attendee.roleType.isHost
      ? UserRole.host
      : userMeetingKey == meeting.participantKey
          ? UserRole.speaker
          : UserRole.guest;

  void _emitErrorAndExit(String error) {
    CustomToast.showErrorToast(msg: error).then((_) => Navigator.of(context).pop());
    isLoading = false;
  }

  Future<void> joinMeeting({required bool fromLobby}) async {
    context.showLoading();

    try {
      connectToRoomSocket(
        peerId: peerId,
        meetingId: meeting.id!,
        userData: userData,
        countryName: userHeaderInfo.data!.countryName ?? '',
        role: userRole.roleKey,
      );

      meetingStartTime ??= DateTime.now();

      if (attendee.roleType.isHost) {
        if (meeting.isStarted != 1 || globalAccessStatus.data?.eventStatus == null || globalAccessStatus.data?.eventStatus?.status == "endCall") {
          uploadGlobalAccessStatus(meeting.id!, meetingStartTime!);
          if (userRole == UserRole.host) _emitMeetingStartedEvent();
        } else {
          print("call not joined ");
        }
      }

      context.read<MeetingTimerProvider>().startTimer(meetingStartTime!);
      context.read<AppGlobalStateProvider>().setIsMeetingInProgress(true, meeting.id!);
      context.read<LibraryRevampProvider>().getLibraryFilesData(context: context, fromMeetingRoom: true);

      context.hideLoading();

      // It is pushReplacement because, we will go to webinarDashboard from lobby screen
      if (fromLobby) {
        Navigator.of(context).pushReplacementNamed(RoutesManager.webinarDashboard);
      } else {
        Navigator.pushNamed(context, RoutesManager.webinarDashboard);
      }

      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (attendee.isTempBlocked) {
            CustomToast.showErrorToast(msg: "Your are temporarily blocked by the host");
          }

          setUIForCurrentMeetingStatus(globalAccessStatus);
        },
      );
    } catch (e, st) {
      _log(e.toString(), e, st);
      context.hideLoading();
      cleanUpMeetingState().then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  void setUIForCurrentMeetingStatus(MeetingGlobalAccessStatusResponse meetingStatus) {
    try {
      final data = meetingStatus.data!;

      context.read<MeetingTickerProvider>().setupTicker(meetingStatus.data?.tickerMiddle);
      context.read<ParticipantsProvider>().setGlobalActionsStatus(data, userRole);

      if (data.calculatorMiddle != null && data.calculatorMiddle?.open == true) {
        context.read<CalculatorProvider>().openCalculatorDialog(closable: false);
      }

      if (data.record == true) {
        context.read<WebinarProvider>().addTopActionToDashboard(MeetingAction.recording);
        context.read<WebinarProvider>().setIsRecording(true);
        context.read<RecordingProvider>().setInitialState(true);
      }

      if (data.callToAction != null) {
        context.read<WebinarProvider>().addTopActionToDashboard(MeetingAction.callToAction);
        context.read<DashBoardCallToActionProvider>().setInitialCtaResponse(data.callToAction!);
      }
      if (data.pushLink != null) {
        context.read<PushLinkProvider>().setInitialPushLinkData(data.pushLink!);
        context.read<WebinarProvider>().addTopActionToDashboard(MeetingAction.pushLink);
      }
      if (data.timer != null) {
        context.read<TimerProvider>().setInitialTimer(data.timer!);
      }

      if (data.themes != null) {
        context.read<WebinarThemesProviders>().updateSelectedTheme(data.themes!);
      }

      if (data.record == true && userRole == UserRole.speaker) {
        context.read<RecordingProvider>().askForPermission();
      }

      ActivePage activePage = ActivePage.audioVideo;

      switch (meetingStatus.data!.activePage) {
        case 'LocalVideo':
        case 'youTubeVideo':
          if (data.videoShareData == null || data.videoShareState == null) break;
          activePage = ActivePage.videoPlayer;
          context.read<VideoShareProvider>().setInitialVideoState(
                meetingStatus.data!.videoShareData!,
                meetingStatus.data!.videoShareState!,
                meetingStatus.data!.activePage == 'LocalVideo',
              );
          break;
        case 'QA':
          activePage = ActivePage.qna;
          if (data.qaList != null) {
            context.read<ChatProvider>().setInitialQAList(data.qaList!);
          }
          break;
        case 'presentationView':
          // context.read<PresentationPopUpProvider>().(data.qaList!);
          if (meetingStatus.data != null && meetingStatus.data?.presentationData != null) {
            setPresentationFilesData(meetingStatus.data!.presentationData!);
          }

          activePage = ActivePage.presentation;
          // TODO: update main content ui for presentation
          break;
        case 'Whiteboard':
          activePage = ActivePage.whiteboard;
          // TODO: update main content ui
          break;
        case 'survey':
          activePage = ActivePage.poll;
          context.read<PollProvider>().pollListeners.setInitialPollData(meetingStatus.data!.pollData!);
          break;
        case 'screenShare':
          // context.read<WebinarProvider>().isScreenShare = true;
          break;
        default:
          activePage = ActivePage.audioVideo;
      }

      context.read<WebinarProvider>().setActivePage(activePage);
    } catch (e) {}
  }

  void setPresentationFilesData(InitialPresentationData presentationData) {
    List<ConvertedImage> images = (presentationData.convertedImages ?? []).isNotEmpty
        ? (presentationData.convertedImages ?? [])
        : [
            ConvertedImage(
              url: presentationData.presentationUrl ?? "",
              fileExt: presentationData.fileType ?? "",
            )
          ];
    context.read<PresentationPopUpProvider>().presentSelectedFiles(
          context: context,
          selectedLibraryItem: PresentationDataModel(
            presentationImages: images.map((ConvertedImage convertedImage) {
              return PresentationImage(
                fileExt: convertedImage.fileExt,
                fileId: "",
                fileName: convertedImage.url,
                fileSize: "0",
                id: 0,
                url: convertedImage.url,
              );
            }).toList(),
            fileName: presentationData.fileName ?? "",
            fileType: presentationData.fileType ?? "",
            height: images.isNotEmpty ? images.first.height.toDouble() : 1032.0,
            width: images.isNotEmpty ? images.first.width.toDouble() : 940,
            ou: userData.id ?? 1,
            pId: 0,
            presentationUrl: presentationData.presentationUrl ?? "",
          ),
        );
  }

  void _connectToHubSocket(
    GenerateTokenUser userData,
    AttendeeData attendee,
    MeetingGlobalAccessStatusResponse meetingGlobalAccess,
    GetProfileResponseModel headerInfo,
  ) {
    hubSocketInput = HubSocketInput(
      uid: userData.id!.toString(),
      roomId: meeting.id!,
      userData: HubUserData(
        id: userData.id,
        displayName: userData.userFirstName,
        role: attendee.roleType,
        meetingId: meeting.id,
        // meeting id
        co: headerInfo.data?.countryName,
        profilePic: "${BaseUrls.imageUrl}${headerInfo.data!.profilePic}",
        // pinned user
        pu: false,
        // is audio enabled
        isAudioEnabled: meetingGlobalAccess.data?.audio ?? false,
        // is video enabled,
        isVideoEnabled: meetingGlobalAccess.data?.video ?? false,
        // make presenter
        makePresenter: attendee.roleType.isPresenter,
        // make co-host
        makeCohost: attendee.roleType.isCohost,
        bc: attendee.roleType.isGuest,
        // random id
        roomId: '${DateTime.now().millisecondsSinceEpoch}${userData.id}',
        st: false,
        // hand raise
        handRaise: false,
        // whether the current is active host
        activeHost: attendee.activeHost == true,
        email: userData.userEmail,
        country: meeting.country,
        oAcId: headerInfo.data!.customerAccounts!.first.custAffId,
        peerId: peerId,
      ),
      panalist: userRole == UserRole.guest ? 0 : 1,
      origin: origin, // TODO(appal): make it dynamic
    );

    print("sdsffgsdufdsuyfgsuy  ${hubSocketInput.toMap()} kkkk ${meeting.token}");
    hubSocket.init(hubSocketInput, meeting.token!);

    // TODO(appal): what should happen if socket is closed/disconnected
    hubSocket.onClose = () => dev.log("INFO: hub socket is closed");
    hubSocket.onFailed = () => dev.log("INFO: hub socket connect is failed");

    // As soon as the socket connect, join the lobby room
    hubSocket.socket?.onConnect((
      data,
    ) {
      _log("joining the socket");
      hubSocket.socket?.emitWithAck('join', data);

      context.read<ParticipantsProvider>().addParticipant(hubSocketInput.userData);
    });

    // Called whenever a member exits from the lobby
    hubSocket.socket?.on('panalExit', (data) {
      final userId = jsonDecode(data)['from'];
      _speakersWaitingToJoin.remove(int.parse(userId.toString()));
      notifyListeners();
    });

    // Called whenever there is a new speaker joins the waiting/lobby room
    hubSocket.socket?.on('panalJoined', (data) {
      final role = jsonDecode(data)['data']['ro'].toString();
      final userId = jsonDecode(data)['data']['id'];
      print("the role in waiting screen is :$data");
      if (role.isAttendee) {
        _speakersWaitingToJoin.add(userId);
        print("the no of speaker are the $_speakersWaitingToJoin");
        notifyListeners();
      }
    });

    // Called whenever there is a new attendee joins the waiting/lobby room
    hubSocket.socket?.on('currentCount', (data) {
      attendeesWaitingToJoin = int.parse(data.toString());
      notifyListeners();
    });

    hubSocket.socket?.on('panalList', (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      if (decoded.containsKey('data') && decoded['roomId'] == meeting.id) {
        final data = decoded['data'] as List<dynamic>;
        for (var attendee in data) {
          if (attendee['id'] != userData.id) {
            final role = attendee['ro'].toString();
            if (role.isAttendee) {
              _speakersWaitingToJoin.add(attendee['id']);
              notifyListeners();
            }
          }
        }
      }
    });

    hubSocket.socket?.on('commandResponse', (res) async {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final type = data['data']['type'];
      final command = data['data']['command'];
      final cmdFrom = data['from'];

      String? oConnectToken = await serviceLocator<UserCacheService>().getOConnectToken();
      await FlutterSessionJwt.saveToken(oConnectToken.toString());
      DateTime tokenExpireDate = await FlutterSessionJwt.getExpirationDateTime();
      DateTime currentTime = DateTime.now().subtract(const Duration(minutes: 5));
      if (tokenExpireDate.isAfter(currentTime)) {}

      if (type == 'eventStatus') {
        final fromUserId = int.tryParse(data['from'].toString());

        // Host has started the meeting. so let's join
        // Note: this condition will not work if the host want to join from web and mobile
        // TODO(appal): fix it later
        if (value == 'EventStarted' && fromUserId != userData.id) {
          final startTime = data['data']['startTime'].toString();
          meetingStartTime = DateTime.parse(startTime).toLocal();
          joinMeeting(fromLobby: true);
        }

        // Host or activehost has ended the meeting.
        else if (value == 'endCall') {
          final myRole = context.read<ParticipantsProvider>().myRole;
          debugPrint("eventStatusssssssss   ${type.toString()}  $value $fromUserId   ${userData.id}");

          // If this event is emitted by us, then close the whole meeting
          if (fromUserId == userData.id) {
            closeMeetingForAll(myRole);
          }
          // else, let's close it for ourself
          else {
            if (isInPipView) {
              closeMeetingForMySelf(myRole).then((value) => _launchExitUrl());
            } else {
              closeMeetingForMySelf(myRole).then((value) {
                Navigator.of(context).popUntil((route) => route.settings.name == RoutesManager.webinarDashboard);
                Navigator.of(context).pop();
                _launchExitUrl();
              });
            }
          }
        }
      } else if (command == 'meetingLock') {
        final fromUserId = int.tryParse(data['from'].toString());

        if (fromUserId != userData.id) {
          if (value == true) {
            CustomToast.showSuccessToast(msg: "Host has locked the meeting");
            meeting = meeting.copyWith(isMeetingLocked: true);
          } else {
            CustomToast.showSuccessToast(msg: "Host unlocked the meeting");
            meeting = meeting.copyWith(isMeetingLocked: false);
          }
        }
      } else if (command == "BreakTime") {
        print('----------------------meeting room provider');

        print(data);
        if (context.mounted) {
          context.read<VideoShareProvider>().stopVideoShare();
        }

        if (value['closeEvent'] != null && value['closeEvent'] == true) {
          //received the host breaktime stopped event so we need to remove breaktime popup here
          if (cmdFrom != myHubInfo.id.toString()) {
            breakTimeHelper.setIsBreakTimeOn(false);
            Navigator.of(context).pop();
          }
        } else if (value['flag'] == true) {
          //received the host breaktime start event so we need to show breaktime popup
          print("clock trigger event with host $data");

          if (isMyVideoOn) toggleVideo();
          if (isMyMicOn) toggleAudio();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => WillPopScope(
              onWillPop: () async => false,
              child: provider.Consumer<WebinarThemesProviders>(builder: (_, theme, __) {
                return AlertDialog(
                  elevation: 0,
                  backgroundColor: theme.colors.bodyColor,
                  title: const Center(child: Text("BREAK TIME", style: TextStyle(color: Colors.green))),
                  content: Container(
                    decoration: BoxDecoration(
                      color: theme.colors.bodyColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Meeting will resume in'),
                        height5,
                        FlipCountdownClock(
                          duration: Duration(minutes: value['time']),
                          flipDirection: AxisDirection.down,
                          digitSize: 30.0,
                          width: 72.w,
                          height: 72.w,
                          digitColor: Colors.white,
                          backgroundColor: Colors.black,
                          separatorBackgroundColor: Colors.red,
                          separatorColor: Colors.black,
                          borderColor: theme.colors.buttonColor,
                          // hingeColor: Colors.red,
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          onDone: () {
                            debugPrint(" break time done ${breakTimeHelper.isBreakTimeOn}");
                            if (breakTimeHelper.isBreakTimeOn) {
                              if (myHubInfo.isHostOrActiveHost || myHubInfo.isCohost) {
                                Navigator.of(context).pop();
                                breakTimeHelper.setBreakTime(context, setTimeStatus: ConstantsStrings.stopTime);
                              }
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Mins",
                              style: w500_14Poppins(color: Colors.white),
                            ),
                            width30,
                            Text("sec", style: w500_14Poppins(color: Colors.white))
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Stretch, hydrate and be ready to dive back into our meeting with renewed energy',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    if (myHubInfo.isHostOrActiveHost || myHubInfo.isCohost) ...[
                      CustomButton(
                        buttonText: 'STOP',
                        buttonColor: theme.colors.buttonColor,
                        buttonTextStyle: const TextStyle(color: Colors.white, fontSize: 17),
                        onTap: () {
                          breakTimeHelper.setBreakTime(ctx, setTimeStatus: ConstantsStrings.stopTime);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ]
                  ],
                );
              }),
            ),
          );

          print("time from socket ${value['time']}");
        }
      } else if (command == 'globalAccess' && type == 'activePage') {
        var isGuest = context.read<ParticipantsProvider>().myRole == UserRole.guest;

        print("isGuest: $isGuest");
        if (isGuest) {
          switch (value) {
            case 'youTubeVideo':
            case 'LocalVideo':
              context.read<WebinarProvider>().setActivePage(ActivePage.videoPlayer);
              break;
            case 'youtubeClose':
              context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
              break;

            case 'Whiteboard':
              context.read<WebinarProvider>().setActivePage(ActivePage.whiteboard);
              break;
            case 'presentationView':
              context.read<WebinarProvider>().setActivePage(ActivePage.presentation);
              break;

            default:
          }
        }
      } else if (command == 'closeWhiteboard' || command == 'closePresentation') {
        context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
      }
    });

    hubSocket.socket?.on('panalResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];

      if (command == 'AccessRestriction') {
        final value = data['value'];
        final action = data['feature']['action'];

        switch (action) {
          case 'opened':
            ActivePage activePage = ActivePage.audioVideo;
            switch (value) {
              case 'presentationView':
                activePage = ActivePage.presentation;
                break;
              case 'qna':
                activePage = ActivePage.qna;
                break;
              case 'whiteboard':
                activePage = ActivePage.whiteboard;
                break;
              case 'video':
                activePage = ActivePage.videoPlayer;
                break;
              case 'poll':
                activePage = ActivePage.poll;
                break;
              case 'screenShare':
                context.read<WebinarProvider>().isScreenShare = true;
                break;
              default:
                activePage = ActivePage.audioVideo;
            }

            final matched = context.read<ParticipantsProvider>().speakers.where((element) => element.id == data['ou']);
            HubUserData? activePageBy;
            if (matched.isNotEmpty) {
              activePageBy = matched.first;
            }

            context.read<WebinarProvider>().setActivePage(activePage);
            context.read<WebinarProvider>().setActivePageBy(activePageBy);
            break;
          case 'remove':
          case 'removed':
            if (value == 'screenShare') {
              context.read<WebinarProvider>().isScreenShare = false;
            }
            context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
            context.read<WebinarProvider>().setActivePageBy(null);
            break;
          default:
        }
      }
    });

    context.read<ParticipantsProvider>().setupHubsocketListeners();
    context.read<MeetingTickerProvider>().setupListeners();
    context.read<ChatProvider>().setupHubSocketListeners(context);
    context.read<ResoundProvider>().setupListeners();
    context.read<BgmProvider>().setupListeners();
    context.read<MeetingEmojiProvider>().setupListeners();

    context.read<DashBoardCallToActionProvider>().callToActionSocketListeners();
    context.read<PushLinkProvider>().setUpPushLinkListeners();
    context.read<CalculatorProvider>().setupListeners();
    context.read<TimerProvider>().setTimerListener();
    context.read<PollProvider>().pollListeners.setUpPollListeners();
    context.read<HandRaiseProvider>().setHandRaiseListeners();
    context.read<VideoShareProvider>().setupHubsocketListeners();
    context.read<WebinarProvider>().setupHubsocketListeners(attendee.isTempBlocked ? UserRole.tempBlocked : userRole,context);
    context.read<PresentationWhiteBoardProvider>().addHubSocketListeners();
    context.read<ShareFilesProvider>().setShareFilesSocketListners();

    hubSocket.socket?.connect();
  }

  void connectToRoomSocket({
    required String peerId,
    required String meetingId,
    required GenerateTokenUser userData,
    required String role,
    required String countryName,
  }) {
    final input = {
      'peerId': peerId,
      'roomId': meetingId,
      'displayName': userData.userFirstName!,
      'userId': userData.id.toString(),
      'streamingMode': true,
      'role': role,
      'origin': origin,
      'countryName': countryName,
    };

    meetingSocket.initialize(input);
    meetingSocket.onDisconnected = () {
      _log("MEETING SOCKET IS DISCONNECTED");
    };
    meetingSocket.onConnectError = () async {
      _log("CONNECT ERROR");
    };
    meetingSocket.onConnected = () {
      _log("SOCKET CONNECTED");
    };
    meetingSocket.onNotification = (method, data) {
      switch (method) {
        case 'roomReady':
          setIceServers(data);
          currentMeetingSessionId = data['sessionId'];
          _setupMediasoupAndJoin();
          break;
        case 'consumerClosed':
          String consumerId = data['consumerId'];
          context.read<PeersProvider>().removeConsumer(consumerId);
          break;

        case 'consumerPaused':
          String consumerId = data['consumerId'];
          context.read<PeersProvider>().pauseConsumer(consumerId);
          break;

        case 'consumerResumed':
          String consumerId = data['consumerId'];
          context.read<PeersProvider>().resumeConsumer(consumerId);
          break;

        case 'newPeer':
          final Map<String, dynamic> newPeer = Map<String, dynamic>.from(data);

          context.read<PeersProvider>().addPeer(newPeer);
          break;

        case 'peerClosed':
          String peerId = data['peerId'];
          context.read<PeersProvider>().removePeer(peerId);
          break;

        case 'newConsumer':
          receiveTransport?.consume(
            id: data['id'],
            producerId: data['producerId'],
            kind: RTCRtpMediaTypeExtension.fromString(data['kind']),
            rtpParameters: RtpParameters.fromMap(data['rtpParameters']),
            appData: Map<String, dynamic>.from(data['appData']),
            peerId: data['peerId'],
            accept: (_) {},
          );
          break;

        case 'changeDisplayName':
          context.read<PeersProvider>().updatePeerName(data['peerId'], data['displayName']);
          break;

        case 'moderator:setAttendeeRole':
          context.read<ParticipantsProvider>().setUserRole(data['role'], data['id']);
          break;
      }
    };

    context.read<RecordingProvider>().setupRoomSocketListeners();
    print("Role for meeting Data $role");
   if(role !="Guest") meetingSocket.connect();
  }

  void _emitMeetingStartedEvent() {
    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'globalAccess',
        'type': 'eventStatus',
        'value': 'EventStarted',
        'meeting_id': meeting.id,
        'user_id': userData.id,
        'startTime': meetingStartTime!.toUtc().toIso8601String(),
      }
    });

    debugPrint(" dfsdkj  ${data.toString()}");
    hubSocket.socket?.emitWithAck('onCommand', data);

    // Set active page
    final activePageData = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'globalAccess',
        'type': 'activePage',
        'value': 'av',
        'ou': userData.id,
      }
    });

    debugPrint(" dfssasdaadkj  ${activePageData.toString()}");
    hubSocket.socket?.emitWithAck('onCommand', activePageData);
  }

  void _setupMediasoupAndJoin() {
    getRouterCapabilities(
      onSuccess: () {
        createTransport(
          producing: true,
          callback: _producerCallback,
          onSuccess: () {
            createTransport(
              producing: false,
              callback: _consumerCallback,
              onSuccess: () {
                final data = {
                  'displayName': userData.userFirstName,
                  'picture': userHeaderInfo.data!.profilePic ?? "",
                  'audioOnly': false,
                  'rtpCapabilities': localDevice.rtpCapabilities.toMap(),
                  "returning": false
                };
                meetingSocket.request('join', data, (data) {
                  try {
                    debugPrint("join data: $data");
                    final peers = data[1]['peers'] as List<dynamic>;
                    for (var peer in peers) {
                      context.read<PeersProvider>().addPeer(peer);
                    }

                    if (meeting.meetingType != "conference") {
                      final streamData = {"sessionId": "", "roomId": meeting.id.toString()};
                      meetingSocket.request('streamingon', data, (res) {
                        debugPrint("streaming data $res");
                      });
                    }
                  } catch (e, st) {
                    dev.log(
                      "unable to add existing peers",
                      error: e,
                      stackTrace: st,
                    );
                  }
                });
              },
            );
          },
        );
      },
    );
  }

  // Meeting room events
  Future<void> toggleVideo() async {
    try {
      if (Platform.isAndroid) {
        final allowed = await checkVideoPermission();
        if (!allowed) {
          CustomToast.showErrorToast(msg: 'Camera permission is denied');
          return;
        }
      }

      if (video != null) {
        await disableCamera();
        return;
      }

      final List<MediaDeviceInfo> devices = context.read<MediaDevicesProvider>().videoInput;
      if (devices.isEmpty) {
        CustomToast.showErrorToast(msg: 'No video input devices found');
        return;
      }
      final deviceId = context.read<MediaDevicesProvider>().selectedVideoDevice?.deviceId;
      if (deviceId != null) {
        final stream = await produceVideo(deviceId);

        videoRenderer = RTCVideoRenderer();
        await videoRenderer.initialize();
        videoRenderer.srcObject = stream;
        notifyListeners();
      }
    } catch (e, st) {
      _log('unable to toggle the video:', e, st);
      CustomToast.showErrorToast(msg: 'Something went wrong');
    }
  }

  ///toggle local video
  Future<void> toggleLocalVideoTest() async {
    try {
      if (Platform.isAndroid) {
        final allowed = await checkVideoPermission();
        if (!allowed) {
          CustomToast.showErrorToast(msg: 'Camera permission is denied');
          return;
        }
      }

      if (localVideoTest != null) {
        await disableLocalvideoTest();
        return;
      }

      final List<MediaDeviceInfo> devices = context.read<MediaDevicesProvider>().videoInput;
      if (devices.isEmpty) {
        CustomToast.showErrorToast(msg: 'No video input devices found');
        return;
      }
      final deviceId = context.read<MediaDevicesProvider>().selectedVideoDevice?.deviceId;

      if (deviceId != null) {
        final stream = await produceLocalVideoRenderTest(deviceId);

        localVideoRenderTest = RTCVideoRenderer();
        await localVideoRenderTest.initialize();
        localVideoRenderTest.srcObject = stream;
        notifyListeners();
      }
    } catch (e, st) {
      _log('unable to toggle the video:', e, st);
      CustomToast.showErrorToast(msg: 'Something went wrong');
    }
  }

  Future<void> toggleScreenShare() async {
    if (video != null) {
      try {
        await toggleVideo();
      } catch (e) {}
    }

    if (screen != null) {
      // Screen sharing was already happening have to stop the screen share
      if (Platform.isIOS) {
        await replayKitChannel.stopSharing(context);
      } else {
        await callStopScreenShareNetworkCalls();
      }
    } else {
      // start screen sharing
      if (!context.mounted) return;

      final bool? shouldStart = await customShowDialog(context, const ScreenShareAlertPopup());
      if (!(shouldStart ?? false)) return;

      if (Platform.isIOS) {
        startScreenSharingIos();
      } else {
        final isPresenting = await presentScreen();
        await callStartScreenShareNetworkCalls(isPresenting: isPresenting ?? false);
      }
    }
  }

  Future<void> callStopScreenShareNetworkCalls() async {
    final myInfo = myHubInfo;

    var res = await globalStatusRepo.updateGlobalAccessStatus({
      "roomId": meeting.id,
      "key": "remove",
      "value": ["activePage", "screenShareOU"]
    });

    if (res.statusCode == 200 && context.mounted) {
      context.read<WebinarProvider>().setIsScreenshareOn(context.read<WebinarProvider>().isScreenShare);
      context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
      context.read<WebinarProvider>().updatedAllowedMoreOptions(context.read<ParticipantsProvider>().myRole, from: "screenshare");

      await gloablSetRepo.setGlobalAccess(
        {
          "action": "close",
          "feature": "screenShare",
          "meetingId": meeting.id,
          "role": 1,
          "type": "pvwpqs",
          "userId": myInfo.id,
        },
      );

      _emitToggleScreenShareEvents(myInfo, false);
    }

    await disableScreenshare();
  }

  Future<void> callStartScreenShareNetworkCalls({
    bool isPresenting = false,
  }) async {
    if ((isPresenting) && context.mounted) {
      context.read<WebinarProvider>().setIsScreenshareOn(context.read<WebinarProvider>().isScreenShare);
      context.read<WebinarProvider>().updatedAllowedMoreOptions(context.read<ParticipantsProvider>().myRole, from: "screenshare");

      final myInfo = myHubInfo;

      var res = await gloablSetRepo.setGlobalAccess({
        "action": "open",
        "feature": "screenShare",
        "meetingId": meeting.id,
        "role": 1,
        "type": "pvwpqs",
        "userId": myInfo.id,
      });

      if (res.status == true) {
        final res2 = await globalStatusRepo.updateGlobalAccessStatus({
          "roomId": meeting.id,
          "key": "activePage",
          "value": "screenShare",
        });
        if (res2.statusCode == 200) {
          await globalStatusRepo.updateGlobalAccessStatus({
            "roomId": meeting.id,
            "key": "screenShareOU",
            "value": myInfo.id,
          });

          _emitToggleScreenShareEvents(myInfo, true);
        }
      }
    }
  }

  void _emitToggleScreenShareEvents(HubUserData myInfo, bool isEnabled) {
    hubSocket.socket?.emitWithAck(
      'onPanalCommand',
      jsonEncode(
        isEnabled
            ? {
                "uid": "ALL",
                "data": {
                  "command": "AccessRestriction",
                  "feature": {"action": "opened"},
                  "value": "screenShare",
                  "roleType": myInfo.role,
                  "ou": myInfo.id.toString(),
                  "on": myInfo.displayName,
                  "peerId": myInfo.peerId,
                }
              }
            : {
                "uid": "ALL",
                "data": {
                  "command": "AccessRestriction",
                  "feature": {
                    "action": "removed",
                    "user": {
                      "feature": "screenShare",
                      "userId": myInfo.id.toString(),
                      "role": myInfo.role,
                      "isAccessing": true,
                      "userName": myInfo.email,
                    }
                  },
                  "roleType": myInfo.role,
                  "value": "screenShare",
                  "ou": myInfo.id.toString(),
                  "on": myInfo.email,
                }
              },
      ),
    );

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode(
        isEnabled
            ? {
                "uid": "ALL",
                "data": {
                  "command": "globalAccess",
                  "type": "activePage",
                  "value": "screenShare",
                  "data": {
                    "ou": myHubInfo.id,
                    "isPvwqa": true,
                    "roleType": myHubInfo.role,
                    "peerId": myHubInfo.peerId,
                    "on": myHubInfo.email,
                    "currentOpenedType": "screenShare",
                  }
                }
              }
            : {
                "uid": "ALL",
                "data": {"command": "globalAccess", "type": "activePage", "value": "av", "ou": myInfo.id.toString()}
              },
      ),
    );
  }

  Future<void> disableScreenshare() async {
    final webcamId = screen?.id;
    try {
      meetingSocket.request('closeProducer', {
        'producerId': webcamId,
      }, () {
        screen?.close();
        screen = null;
        notifyListeners();
      });
      await FlutterForegroundTask.stopService();
    } catch (e, st) {
      dev.log("error while closing producer: $e", error: e, stackTrace: st);
    }
  }

  Future<void> toggleAudio() async {
    if (Platform.isAndroid) {
      final allowed = await checkAudioPermission();
      if (!allowed) {
        _log("MIC PERMISSION DENIED");
        return;
      }
    }

    if (audio != null) {
      if (audio?.paused == true) {
        unmuteMic();
      } else {
        muteMic();
      }
    } else {
      final List<MediaDeviceInfo> devices = context.read<MediaDevicesProvider>().audioInput;
      if (devices.isEmpty) {
        _log("NO DEVICES FOUND TO ENABLE AUDIO");
        return;
      }

      final deviceId = context.read<MediaDevicesProvider>().selectedAudioDevice?.deviceId;

      if (deviceId != null) {
        await produceAudio(deviceId);
      }
    }
  }

  void _producerCallback(Producer producer) async {
    if (producer.source == 'mic') {
      audio = producer;
      meetingSocket.request('resumeProducer', {'producerId': audio?.id}, () {});
      notifyListeners();
      updateAllowedActionsUi();
    } else if (producer.source == 'webcam') {
      video = producer;
      //videoRenderer.srcObject = producer.stream;
      notifyListeners();
      updateAllowedActionsUi();
    } else if (producer.source == 'screen') {
      screen = producer;
      notifyListeners();
    }

    producer.on('trackended', () {
      disableMic().catchError((data) {});
    });

    producer.observer.on('close', () {});
  }

  void _consumerCallback(Consumer consumer, [Function? accept]) async {
    accept?.call({});

    if (consumer.peerId != null) {
      meetingSocket.request('resumeConsumer', {'consumerId': consumer.id}, () {
        context.read<PeersProvider>().addConsumer(consumer, consumer.peerId!);
      });
    }
  }

  Future<void> disableScreenShare() async {
    if (screen == null) return;
    final screenId = screen?.id;

    try {
      meetingSocket.request('closeProducer', {
        'producerId': screenId,
      }, () {
        screen?.close();
        screen = null;
        notifyListeners();
        updateAllowedActionsUi();
      });
    } catch (error) {}
  }

  Future<void> disableMic({bool updateUI = true}) async {
    if (audio == null) return;
    final micId = audio?.id;

    try {
      meetingSocket.request('closeProducer', {
        'producerId': micId,
      }, () {
        audio?.close();
        audio = null;
        notifyListeners();
        if (updateUI) updateAllowedActionsUi();
      });
    } catch (error) {}
  }

  Future<void> disableCamera({bool updateUI = true}) async {
    if (video == null) return;
    final webcamId = video?.id;
    try {
      meetingSocket.request('closeProducer', {
        'producerId': webcamId,
      }, () {
        video?.close();
        videoRenderer.srcObject = null;
        video = null;
        notifyListeners();
        if (updateUI) updateAllowedActionsUi();
        // videoRenderer.dispose();
      });
    } catch (e, st) {
      dev.log("error while closing producer: $e", error: e, stackTrace: st);
    }
  }

  Future<void> disableLocalvideoTest({bool updateUI = true}) async {
    if (localVideoTest == null) return;

    try {
      localVideoTest?.close();
      localVideoRenderTest.srcObject = null;
      localVideoTest = null;

      notifyListeners();
      // if (updateUI) {

      // }
    } catch (e, st) {
      dev.log("error while closing local producer: $e", error: e, stackTrace: st);
    }
  }

  void muteMic() async {
    try {
      meetingSocket.request(
        'pauseProducer',
        {
          'producerId': audio?.id,
        },
        () {
          audio = audio?.pauseCopy();
          notifyListeners();
          updateAllowedActionsUi();
        },
      );
    } catch (error, st) {
      _log("muteMic", error, st);
    }
  }

  void unmuteMic() {
    try {
      meetingSocket.request(
        'resumeProducer',
        {
          'producerId': audio?.id,
        },
        () {
          audio = audio?.resumeCopy();
          notifyListeners();
          updateAllowedActionsUi();
        },
      );
    } catch (error, st) {
      _log("unmuteMic", error, st);
    }
  }

  void toggleMeetingLockStatus() async {
    // Holds true/false. If true, meeting will be locked else unlocked
    final isMeetingLocked = !meeting.isMeetingLocked!;

    // Change the status immediately so that user will see updated UI.
    meeting = meeting.copyWith(isMeetingLocked: isMeetingLocked);
    notifyListeners();

    try {
      final requestBody = {
        'purpose': 'MeetingLock',
        'meeting_id': meeting.id,
        'is_meeting_locked': isMeetingLocked,
      };
      final res = await meetingRepo.updateMeetingDetails(requestBody);
      if (res.status == true) {
        final socketEventData = jsonEncode({
          "uid": "ALL",
          "data": {
            "command": "meetingLock",
            "value": res.data!.isMeetingLocked,
          }
        });
        hubSocket.socket?.emitWithAck('onCommand', socketEventData);
        CustomToast.showSuccessToast(msg: 'You ${isMeetingLocked ? 'locked' : 'unlocked'} this meeting successfully');

        meeting = MeetingData.fromJson(res.data!.toJson());
        notifyListeners();
      } else {
        meeting = meeting.copyWith(isMeetingLocked: false);
        notifyListeners();
      }
    } on DioException {
      meeting = meeting.copyWith(isMeetingLocked: false);
      notifyListeners();
    } catch (e) {
      meeting = meeting.copyWith(isMeetingLocked: false);
      notifyListeners();
    }
  }

  void updateAllowedActionsUi() {
    var myRole = context.read<ParticipantsProvider>().myRole;
    myRole = myRole == UserRole.unknown
        ? attendee.isTempBlocked
            ? UserRole.tempBlocked
            : userRole
        : myRole;

    // context.read<WebinarProvider>().updateAllowedActions(myRole, from: "updateAllowedActionsUi"); old Actions

    context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "updateAllowedActionsUi");

    ///New Actions
  }

  // Leave from current meeting
  Future<void> leaveMeeting() async {
    final myRole = context.read<ParticipantsProvider>().myRole;

    // If host or active host is
    if (myRole == UserRole.host || myRole == UserRole.activeHost) {
      // We will emit the endCall event first, on response to that event
      // we will close the meeting
      _emitEndCallEvent(isActiveHost: myRole == UserRole.activeHost);
    } else {
      await closeMeetingForMySelf(myRole);
    }
  }

  /// Emit endCall event, so that other peers in the meeting will get
  /// notified and close themselves
  void _emitEndCallEvent({required bool isActiveHost}) {
    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'globalAccess',
        'type': 'eventStatus',
        'value': 'endCall',
        'meeting_id': meeting.id,
        'user_id': userData.id,
        'activeHost': isActiveHost,
      }
    });
    hubSocket.socket?.emitWithAck('onCommand', data);
  }

  Future<void> cleanUpMeetingState() async {
    try {
      final activePage = context.read<WebinarProvider>().activePage;
      final bool isScreenShareOn = context.read<WebinarProvider>().isScreenShare;
      // final myHubInfo = context.read<ParticipantsProvider>().myHubInfo;

      // if (myHubInfo.isHostOrActiveHost) {
      if (activePage == ActivePage.whiteboard) context.read<WhiteboardProvider>().closeWhiteBoard();
      if (isScreenShareOn) await toggleScreenShare();
      // }

      context.read<AppGlobalStateProvider>().leaveMeetingMiniView();
      // Close all peers. This will close our copy all peers audio/video streams
      await context.read<PeersProvider>().close();
      context.read<ParticipantsProvider>().resetParticipantsState();
      context.read<RecordingProvider>().resetState();
      context.read<MediaDevicesProvider>().resetState();
      context.read<InvitePopupProvider>().clearData();
      context.read<MeetingTimerProvider>().resetState();
      context.read<VideoShareProvider>().resetState();
      context.read<WebinarProvider>().resetState();
      context.read<DashBoardCallToActionProvider>().clearData();
      context.read<PushLinkProvider>().resetState();
      context.read<MeetingTickerProvider>().resetState();
      context.read<WebinarThemesProviders>().resetData();
      await context.read<BgmProvider>().resetState();
      context.read<PrompterProvider>().resetState();
      context.read<MeetingTimerProvider>().resetState();
      context.read<CalculatorProvider>().resetState();
      context.read<ResoundProvider>().resetState();
      context.read<MeetingTickerProvider>().resetState();
      context.read<AppGlobalStateProvider>().setIsMeetingInProgress(false);
      context.read<PollProvider>().pollListeners.cleanMeetingPollData();

      try {
        context.read<ChatProvider>().chatData.close();
      } catch (e) {}

      // Stop any foreground service
      await FlutterForegroundTask.stopService();

      WakelockPlus.disable();
    } catch (e, st) {
      print("the clean up meeting state exception ${e.toString()} && $st");
    } finally {
      // START: Clean up for this provider
      await closeAllResources();
      _speakersWaitingToJoin.clear();
      attendeesWaitingToJoin = 0;
      meetingStartTime = null;
      meetingInitializationError = null;
      // END: Clean up for this provider
    }
  }

  /// Just for the sake of readability
  void exitFromLobby() {
    cleanUpMeetingState();
  }

  /// Closes the meeting only for current user
  Future<void> closeMeetingForMySelf(UserRole myRole) async {
    context.showLoading();
    await cleanUpMeetingState();
    Navigator.of(context).pop();
  }

  /// Called whenever endCall event is fired through hub-socket.
  ///
  /// This will completely close the meeting.
  Future<void> closeMeetingForAll(UserRole myRole) async {
    try {
      context.showLoading();

      hubSocket.socket?.emitWithAck('moderator:closeMeeting', '');
      await cleanUpMeetingState();

      await meetingRepo.updateMeetingStatus({
        "meeting_id": meeting.id,
        "is_started": 2,
      });

      globalStatusRepo
          .updateGlobalAccessStatus({
            'key': 'eventStatus',
            'roomId': meeting.id,
            'value': {'status': 'endCall', 'startTime': DateTime.now().toUtc().toIso8601String()},
          })
          .then((value) {})
          .onError((error, stackTrace) {
            // Can log
          });

      await templateRepo.exportAttendeeList({"meeting_id": meeting.id.toString()});

      globalStatusRepo.deleteMeetingStatus(meeting.id.toString()).then((value) {}).onError((error, stackTrace) {
        // Can log
      });
    } finally {
      context.hideLoading();
      _exitMeetingScreen(myRole);
    }
  }

  Future<void> closeAllResources() async {
    if (isMyVideoOn) await toggleVideo();
    if (isMyMicOn) await toggleAudio();
    if (context.read<WebinarProvider>().isScreenShare) await toggleScreenShare();

    video = null;
    audio = null;
    screen = null;

    // Close Hub socket
    hubSocket.close();
    // Close Meeting room socket
    meetingSocket.close();
    // Close send transport. This will internally close any audio/video producers
    sendTransport?.close();
    // Close receive transport. So that we will stop receiving peers video/audio
    receiveTransport?.close();
    // Dispose our video renderer
    videoRenderer.dispose();

    videoRenderer = RTCVideoRenderer();
  }

  void _exitMeetingScreen(UserRole role) {
    print("rolerolerolerolerolerole $role");
    Future.delayed(const Duration(milliseconds: 300));
    if (role == UserRole.host || role == UserRole.activeHost) {
      CustomToast.showSuccessToast(msg: ConstantsStrings.meetingEnded);
    }
  }

  void _launchExitUrl() {
    if (meeting.exitUrl?.isNotEmpty == true) {
      launchUrl(Uri.parse(meeting.exitUrl!), mode: LaunchMode.externalApplication);
    }
  }

  void _log(dynamic message, [dynamic ex, dynamic st]) {
    dev.log(message, name: logTag, error: ex, stackTrace: st);
  }
}
