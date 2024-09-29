import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/data.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/model/new_attendee_response/data.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/room_socket.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/participants/widgets/presenter_antendee_popup.dart';
import 'package:o_connect/ui/views/themes/models/webinar_themes_model.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

import '../../home_screen/home_screen_provider/home_screen_provider.dart';

class ParticipantsProvider extends ChangeNotifier {
  HubSocket hubSocket = HubSocket.instance;

  final MeetingRoomRepository qwkRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );

  callNotify() {
    notifyListeners();
  }

  final MeetingRoomRepository panelCountRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.panelCountUrl,
  );

  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  final MeetingRoomRepository oesRepo = MeetingRoomRepository(
    ApiHelper().oesDio,
    baseUrl: BaseUrls.baseUrl,
  );

  BuildContext get context => navigationKey.currentContext!;

  bool globalMicOn = true;
  bool globalVideoOn = true;
  bool globalChatOn = true;
  bool globalEmojiOn = true;
  List<HubUserData> speakers = [];
  List<HubUserData> tempBlockedUsers = [];
  List<HubUserData> guests = [];

  int get allUsersCount {
    return speakers.length + tempBlockedUsers.length + guests.length;
  }

  final TextEditingController participantSearchController = TextEditingController();

  List<HubUserData> get filteredSpeakers {
    final start = DateTime.now();

    String searchQuery = participantSearchController.text.toLowerCase();

    var filtered = searchQuery.isEmpty ? speakers : speakers.where((e) => e.displayName!.toLowerCase().contains(searchQuery)).toList();

    Map<String, List<HubUserData>> data = {};

    void updateData(String key, HubUserData hubInfo) {
      if (data.containsKey(key)) {
        data.update(key, (value) => [...value, hubInfo]);
      } else {
        data.putIfAbsent(key, () => [hubInfo]);
      }
    }

    for (var i = 0; i < filtered.length; i++) {
      final e = filtered[i];

      if (e.isHost) {
        updateData('h', e);
      } else if (e.isActiveHost) {
        updateData('ah', e);
      } else if (!e.isActiveHost && !e.isHost && e.pu == true && e.isCohost) {
        updateData('pc', e);
      } else if (!e.isActiveHost && !e.isHost && e.pu == true && !e.isCohost) {
        updateData('ps', e);
      } else if (!e.isActiveHost && !e.isHost && e.pu == false && e.isCohost) {
        updateData('nc', e);
      } else if (!e.isActiveHost && !e.isHost && e.pu == false && !e.isCohost) {
        updateData('s', e);
      }
    }

    ///pc-pinned-Co-Host  ps-pinned-speaker  nc- normat-Co-Host
    final result = [...?data['h'], ...?data['ah'], ...?data['pc'], ...?data['nc'], ...?data['ps'], ...?data['s']];

    // final result = [
    //   ...filtered.where((e) => e.isHost), // Host
    //   ...filtered.where((e) => e.isActiveHost), // Active Hosts
    //   ...filtered.where((e) => !e.isActiveHost && !e.isHost && e.pu == true && e.isCohost), // Pinned Cohosts
    //   ...filtered.where((e) => !e.isActiveHost && !e.isHost && e.pu == true && !e.isCohost), // Pinned Speakers
    //   ...filtered.where((e) => !e.isActiveHost && !e.isHost && e.pu == false && e.isCohost), // Normal Cohosts
    //   ...filtered.where((e) => !e.isActiveHost && !e.isHost && e.pu == false && !e.isCohost), // Speakers
    // ];

    final end = DateTime.now();

    print("TIME: ${end.difference(start).inMilliseconds}");

    return result;
  }

  List<HubUserData> get filteredGuests {
    String searchQuery = participantSearchController.text.toLowerCase();
    if (searchQuery.isEmpty) return guests;
    return guests.where((e) => e.displayName!.toLowerCase().contains(searchQuery)).toList();
  }

  bool get isHostPresent => speakers.any((s) => s.isHost);
  bool get isActiveHostPresent => speakers.any((s) => s.isActiveHost);
  bool get isCoHostPresent => speakers.any((s) => s.isCohost);

  List<HubUserData> get activeHosts => speakers.where((s) => s.isActiveHost).toList();

  /// This will be called when we are opening the hub socket in
  /// [MeetingRoomProvider] provider.
  void setupHubsocketListeners() {
    hubSocket.socket?.on('panalList', (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      if (decoded.containsKey('data') && decoded['roomId'] == meeting.id) {
        final data = decoded['data'] as List<dynamic>;
        for (var attendee in data) {
          speakers.removeWhere((p) => p.id == attendee['id']);
          guests.removeWhere((p) => p.id == attendee['id']);
          print("the attendee data is the $attendee");
          var user = HubUserData.fromJson(attendee);

          print("the user role is the $user");
          if (user.role.isGuest) {
            guests.add(user);
          } else {
            speakers.add(user);
          }
        }
        notifyListeners();
        print("panalList ${myRole.toString()}");
        _fetchTempBlockedUsers();
      }
    });

    hubSocket.socket?.on('panalJoined', (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      final data = decoded['data'];

      speakers.removeWhere((p) => p.id == data['id']);
      guests.removeWhere((p) => p.id == data['id']);

      final user = HubUserData.fromJson(data);
      speakers.add(user);
      notifyListeners();

      print("panalJoined ${myRole.toString()} user  $user");
      print("SPEAKER: $user");
      print(myRole);
      context.read<WebinarProvider>().updateAllowedActions(myRole, from: "panal joined");
      _fetchTempBlockedUsers();
    });

    hubSocket.socket?.on('currentCount', (data) {
      panelCountRepo.fetchAttendeeUsers(meeting.id!).then((value) {
        if (value.status == true) {
          guests = [...value.data!];
          notifyListeners();
        }
      });
    });

    hubSocket.socket?.on('panalExit', (data) {
      final userId = int.tryParse(jsonDecode(data)['from']);
      speakers.removeWhere((u) => u.id != null && u.id == userId);
      tempBlockedUsers.removeWhere((u) => u.id == userId);
      guests.removeWhere((u) => u.id == userId);
      notifyListeners();
    });

    hubSocket.socket?.on('panalResponse', (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      final data = decoded['data'];
      final command = data['command'];

      if (command == 'globalAccess') {
        final type = data['type'];
        print("f i am not a host/active-host then disable the mic and hide the $type:${data['value']}");
        if (type == 'audio') {
          print(" siva globalAccess   ${data['value']}");
          globalMicOn = data['value'];

          /// If i am not a host/active-host then disable the mic and hide the
          /// audio option
          if (!myHubInfo.isHostOrActiveHost) {
            if (globalMicOn == false) {
              context.read<MeetingRoomProvider>().disableMic();
              context.read<WebinarProvider>().updateAllowedActions(myRole, from: "global mic off");
              context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "global mic off");
            } else {
              context.read<WebinarProvider>().updateAllowedActions(myRole, from: "global mic on");
              context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "global mic on");
            }
          }
        } else if (type == 'video') {
          globalVideoOn = data['value'];

          /// If i am not a host/active-host then disable the mic and hide the
          /// video option
          if (!myHubInfo.isHostOrActiveHost) {
            if (globalVideoOn == false) {
              context.read<MeetingRoomProvider>().disableCamera();
              context.read<WebinarProvider>().updateAllowedActions(myRole, from: "global video off");
              context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "global video off");
            } else {
              context.read<WebinarProvider>().updateAllowedActions(myRole, from: "global video on");
              context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "global video on");
            }
          }
        }
        notifyListeners();
      } else if (command == 'singleAccess') {
        final userId = data['id'];
        final idx = speakers.indexWhere((p) => p.id == userId);
        if (idx >= 0) {
          final updatedParticipant = HubUserData.fromJson(data['userData']);
          speakers[idx] = updatedParticipant;
        }

        notifyListeners();

        if (userId == userData.id) {
          if (speakers[idx].isAudioEnabled == false) {
            context.read<MeetingRoomProvider>().disableMic(updateUI: false);
          }
          if (speakers[idx].isVideoEnabled == false) {
            context.read<MeetingRoomProvider>().disableCamera(updateUI: false);
          }

          context.read<WebinarProvider>().updateNewBottomBarAllowedActions(
                myRole,
                allowAudio: speakers[idx].isAudioEnabled!,
                allowVideo: speakers[idx].isVideoEnabled!,
                from: "singleAccess",
              );
        }
      }
      notifyListeners();
    });

    hubSocket.socket?.on('commandResponse', (res) async {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      final data = decoded['data'];
      final command = data['command'];
      print("command Response globalAccess ${command} ----${data.toString()}");
      if (command == 'globalAccess') {
        final type = data['type'];


        if (type == 'chat') {
          globalChatOn = data['value'];
          notifyListeners();
          context.read<WebinarProvider>().updateAllowedActions(myRole, from: "global chat");
        } else if(type == "globalSpeakerAccess"){
          print("command Response globalAccess ${type} --- ${myRole}");
          context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "global Speaker Access");
        }

        else if (type == 'emoji') {
          globalEmojiOn = data['value'];
          notifyListeners();
          context.read<WebinarProvider>().updatedAllowedMoreOptions(myRole, from: "global emoji");
        } else if (type == 'themes') {
          if (data['ou'].toString() != myHubInfo.id.toString()) {
            final themeData = WebinarThemesListModel.fromJson(data['value']);
            context.read<WebinarThemesProviders>().updateSelectedTheme(themeData);
          }
        }
      }
      else if (command == 'singleAccess') {
        final type = data['type'];
        final value = data['value'];
        final activeHost = data['activeHost'];


        /// Host made somebody co-host
        if (['mch'].contains(type)) {
          final userId = data['id'];
          final idx = speakers.indexWhere((p) => p.id == userId);
          if (idx >= 0) {
            final updatedParticipant = HubUserData.fromJson(data['userData']).copyWith(ro: value == true ? 'Co-host' : 'Attendee');

            speakers[idx] = updatedParticipant;
            print("use data after change role ${speakers[idx].makeCohost}");
            notifyListeners();
            if (speakers[idx].id != userData.id) return;


            context.read<MeetingRoomProvider>().setAttendee = attendee.copyWith(roleType: value == true ? 'Co-host' : 'Attendee');
            if (updatedParticipant.id == userData.id) {
              if (activeHost == 'Active-Host') {
                CustomToast.showSuccessToast(msg: value ? "Host made you as a Active Host" : "You are now on Speaker");
              } else if (!activeHost) {
                CustomToast.showSuccessToast(msg: value ? "Host made you Co-host" : "Co-Host role removed By Host");
              }
            }
          }
        }
      } else if (command == 'Block') {
        if (data['value'] == 'temporary') {
          final userId = data['id'];
          final idx = speakers.indexWhere((p) => p.id == userId);
          if (idx >= 0) {
            final tempBlocked = speakers.removeAt(idx);

            tempBlocked.copyWith(userRole: UserRole.tempBlocked);
            tempBlockedUsers.add(tempBlocked);

            notifyListeners();
            // I am temporarily blocked by active host :(
            debugPrint("Attendee data while  ${tempBlockedUsers.length}");
            debugPrint("Attendee data while  ${speakers.length}");
            if (userId ==  userData.id) {
              _handleOnTemporaryBlock();
            }
          }
        }
        else if (data['value'] == 'unBlock') {
          final userId = data['id'];
          final idx = tempBlockedUsers.indexWhere((p) => p.id == userId);
          if (idx >= 0) {
            final tempBlocked = tempBlockedUsers.removeAt(idx);
            tempBlocked.copyWith(userRole: myRole);
            speakers.add(tempBlocked);
            // context.read<HomeScreenProvider>().getMeetingKey = tempBlocked.role;
            notifyListeners();

            // I am unblocked by active host :)

            if (userId == userData.id) {
              _handleUnblock();
            }
          }
        } else if (data['value'] == 'permanent') {
          final userId = data['id'];
          speakers.removeWhere((p) => p.id == userId);

          // Host blocked me :(
          if (userId == userData.id) {
            context.read<AppGlobalStateProvider>().setIsMeetingInProgress(false);
            _handlePermanentBlock();
          }
        }
      } else if (command == 'addToPanel') {
        final mode = data['mode'];
        if (data['id'] == userData.id) {
          // Active host made me a speaker or guest(attendee)
          if (mode == 'guestList' || mode == 'panelList') {
            if (mode == 'panelList') {
              final idx = speakers.indexWhere((p) => p.id == data['id']);
              if (idx >= 0) {
                // guestUsers.add(GuestUser.fromHubUser(participants[idx]));
                // participants.removeAt(idx);
              }
            } else if (mode == 'guestList') {
              // guestUsers.removeAt(index);
            }

            print("data['redirectUrl']    ${data['redirectUrl'].toString()}");
            _handleOnMadeGuestOrSpeaker(data['redirectUrl']);
          }
        } else {
          // Change the other user role
        }
      } else if (command == 'leave') {
        // Host, co-host or active host remove us from meeting :(

        if (data['fromwww'] == meeting.userId || speakers.any((u) => u.id == data['fromwww'] && (u.isActiveHost || u.isCohost))) {
          _handleOnRemovedFromMeeting();
        }
      }
      notifyListeners();
    });

    meetingRoomSocket.socket?.on('notification', (data) {
      final method = data['method'];

      if (method == 'activeSpeaker') {
        context.read<PeersProvider>().makeActiveSpeaker(data['peerId']);
      }
    });
  }

  void _fetchTempBlockedUsers() {
    qwkRepo.fetchTempBlockedAttendeeList(meeting.id!).then((value) {
      debugPrint("_fetching blocked users data  ${value.data.toString()}");
      if (value.statusCode == 200) {
        final tempBlockedIds = value.data['data'] as List<dynamic>;
        try {
          for (var userId in tempBlockedIds) {
            var index = speakers.indexWhere((s) => s.id.toString() == userId.toString());
            if (index >= 0) {
              final speaker = speakers.removeAt(index);
              tempBlockedUsers.add(speaker);
            }
          }
          notifyListeners();
          context.read<WebinarProvider>().updateAllowedActions(myRole, from: "from temp blocked check");
        } catch (e) {
          log("error while fetching temp blocked users: $e");
        }
      }
    });
  }

  void _handleOnRemovedFromMeeting() {
    final isPipEnabled = context.read<AppGlobalStateProvider>().isPIPEnabled;

    if (isPipEnabled) {
      context.read<MeetingRoomProvider>().leaveMeeting();
    } else {
      context.read<MeetingRoomProvider>().leaveMeeting().then((_) {
        Navigator.of(context).popUntil((route) => route.settings.name == RoutesManager.webinarDashboard);
        CustomToast.showErrorToast(msg: "Host removed you from the meeting").then((_) => Navigator.of(context).pop());
      });
    }
  }

  /// Called when the current user was made guest/speaker by host or active host
  void _handleOnMadeGuestOrSpeaker(String redirectUrl) async {
    // Exit the current meeting
    await context.read<MeetingRoomProvider>().leaveMeeting();
    // Add any other clean up code here

    final urlParts = redirectUrl.split("/");
    final meetingId = urlParts[0];
    final autoGeneratedId = urlParts[1];
    context.read<HomeScreenProvider>().getMeetingKey = urlParts[2].toString();
    notifyListeners();

    // Join the meeting again as guest/speaker
    await context.read<MeetingRoomProvider>().initialize(
          meetingId: meetingId,
          autoGeneratedId: autoGeneratedId,
          headerInfo: context.read<MeetingRoomProvider>().userHeaderInfo,
          userKey: urlParts[2].toString(),
        );

    final provider = context.read<MeetingRoomProvider>();

    context.read<MeetingRoomProvider>().connectToRoomSocket(
          peerId: provider.peerId,
          meetingId: meetingId,
          userData: userData,
          role: provider.userRole.roleKey,
          countryName: provider.userHeaderInfo.data!.countryName ?? '',
        );
    context.read<MeetingRoomProvider>().setUIForCurrentMeetingStatus(provider.globalAccessStatus);
  }

  /// Called when the current user is permanently blocked
  void _handlePermanentBlock() async {
    await context.read<MeetingRoomProvider>().leaveMeeting();
    CustomToast.showErrorToast(msg: "You are permanently blocked by the active host").then((_) => Navigator.of(context).pop());
  }

  /// Called when the current user is temporarily blocked
  /// by the active host or co-host.
  void _handleOnTemporaryBlock() async {
    CustomToast.showErrorToast(msg: "You are temporarily blocked by Host");

    try {
      await context.read<MeetingRoomProvider>().disableCamera();
      await context.read<MeetingRoomProvider>().disableMic();
      await context.read<MeetingRoomProvider>().disableScreenShare();
    } finally {
      context.read<WebinarProvider>().updateNewBottomBarAllowedActions(UserRole.tempBlocked, from: "ontemp blocked");
    }

    // Add other cleanup code here (if applicable)
  }

  /// Called when the current user is unblocked
  /// by the active host or co-host.
  void _handleUnblock() {
    CustomToast.showSuccessToast(msg: "You are unblocked");
    context.read<WebinarProvider>().updateNewBottomBarAllowedActions(myRole, from: "from unblock");
  }

  MeetingData get meeting => context.read<MeetingRoomProvider>().meeting;

  AttendeeData get attendee => context.read<MeetingRoomProvider>().attendee;

  GenerateTokenUser get userData => context.read<MeetingRoomProvider>().userData;

  HubSocketInput get hubSocketInput => context.read<MeetingRoomProvider>().hubSocketInput;

  MeetingRoomWebsocket get meetingRoomSocket => context.read<MeetingRoomProvider>().meetingSocket;

  /// Represents whether the current user can perform actions on participants
  /// such as mute/unmute, audio on/off, make attendee etc..
  bool get canHandleParticipants {
    final myUserId = attendee.roleType;
    print("attendee attendee ${attendee.roleType}");
    return speakers.any((p) => p.role == myUserId && (p.isHost || p.isCohost || p.isActiveHost));
  }

  /// Represents whether the current user can edit global actions status
  /// such as global mic on/off, global chat on/off
  bool get canEditGlobalAccess {
    final myUserId = attendee.userId;
    return speakers.any((p) => p.id == myUserId && (p.isHost || p.isActiveHost));
  }

  bool get canSeeBlockedUsers {
    return [UserRole.host, UserRole.activeHost, UserRole.coHost].contains(myRole);
  }

  bool get canEndMeeting {
    return [UserRole.host, UserRole.activeHost].contains(myRole);
  }

  bool get hasActiveHost => speakers.any((p) => p.isActiveHost);

  bool get hasReachedMaxCohostLimit => speakers.where((p) => p.isCohost).length == 10;

  /// Meeting host info. Can be nullable, because host can leave the meeting
  /// in middle by making somebody else active-host
  HubUserData? get hostInfo {
    final hostUsers = speakers.where((p) => p.isHost);
    return hostUsers.isNotEmpty ? hostUsers.first : null;
  }

  /// Represents the current user role during a meeting.
  /// Can change during the meeting.
  /// Note: Order of if conditions is important
  ///   UserRole get myRole

  UserRole get myRole {
    String? meetingJoinKey = context.read<HomeScreenProvider>().getMeetingKey;
    print("guestKey ${meeting.guestKey} ");
    print("hostKey ${meeting.hostKey} ");
    print("participantKey ${meeting.participantKey} ");
    print("meetingJoinKey ${meetingJoinKey.toString()} ");

    // if (guests.any((p) => p.role == attendee.roleType)) {

    if (meeting.guestKey.toString() == meetingJoinKey.toString()) {
      return UserRole.guest;
    }
    debugPrint("the matched data type is the ${tempBlockedUsers.length}");
    if (tempBlockedUsers.any((p) => p.role == attendee.roleType)) {
      return UserRole.tempBlocked;
    }
    // for (var speak in speakers) {
    //   debugPrint("speaker data ${speak.role} && ${attendee.roleType}");
    // }
    debugPrint("the matched data type is the ${speakers.length}");

    for (int i = 0; i < speakers.length; i++) {
      debugPrint("the speakers data is the index $i && ${speakers[i].toJson()["ro"]} && ${attendee.roleType} ${speakers[i].id.toString()} && ${attendee.userId.toString()}");
    }
    final matched = speakers.where((p) => p.role == attendee.roleType);
    // debugPrint("the matched data type is the ${matched.length}");
    if (matched.isEmpty) return UserRole.unknown;

    HubUserData userData = matched.first;
    if (userData.isHost) return UserRole.host;
    if (userData.isCohost) return UserRole.coHost;
    if (userData.isActiveHost) return UserRole.activeHost;
    if (userData.role.isAttendee) return UserRole.speaker;
    return UserRole.guest;
  }

  int get handRiseCount {
    return speakers.where((element) => element.handRaise == true).length;
  }

  HubUserData get myHubInfo {
    var matched = speakers.where((p) {
      print("matchedddddddddddd  ${p.toString()} --- ${attendee.roleType}");

      return p.role == attendee.roleType;
    });
    print("matchedddddddddddd  ${matched.first.role.toString()} --- ${attendee.roleType}");
    if (matched.isNotEmpty) return matched.first;
    matched = guests.where((p) => p.role == attendee.roleType);
    if (matched.isNotEmpty) return matched.first;
    matched = tempBlockedUsers.where((p) => p.role == attendee.roleType);

    return matched.first;
  }

  void addParticipant(HubUserData userData) {
    if (userData.role.isGuest) {
      guests.removeWhere((u) => u.id == userData.id);
      guests.add(userData);
    } else {
      speakers.removeWhere((p) => p.id == userData.id);
      speakers.add(userData);
    }
    notifyListeners();
    print("addParticipant ${myRole.toString()}");
  }

  void toggleGlobalAudio() {
    _emitGlobalAccessCommand(command: 'onPanalCommand', type: 'audio', value: !globalMicOn);
  }

  bool isSpeakerRequest = false;

  /// host access speaker request
  Future speakerRequest(bool isSpeakerRequest) async {
    // isSpeakerRequest = true;

    var body = {"key": "globalSpeakerAccess", "roomId": meeting.id, "value": isSpeakerRequest};
    print("global access emit success for $body");

    var res = await meetingRepo.updateGlobalAccessStatus(body);
    print("global access emit success for ${res.data.toString()}");
    if (res.data['status'] == true) {
      print("global access emit success for ");
      final data = jsonEncode({
        'uid': 'ALL',
        'data': {
          'command': 'globalAccess',
          'type': "globalSpeakerAccess",
          'value': isSpeakerRequest,
          'activeHost': false, // TODO(appal): make it dynamic
          'user_id': userData.id,
          'meeting_id': meeting.id,
        }
      });
      print("global access emit success for $data");
      hubSocket.socket?.emitWithAck("onCommand", data, ack: (_) {
        log("global access emit success for speaker request");
      });

      notifyListeners();
    }
  }

  ///host cancel speaker request
  Future hostCancelSpeakerRequest(
    String id,
    bool isCancel,
  ) async {
    final data = jsonEncode({
      'uid': int.parse(id),
      'data': {
        "command": "speakerAccess",
        "value": {"type": "declined", "id": int.parse(id)}
      }
    });
    hubSocket.socket?.emitWithAck("onCommand", data, ack: (_) {});
    context.read<VideoShareProvider>().updateRequestData(
          id,
        );
    if (isCancel) {
      Navigator.of(context).pop();
      context.read<ParticipantsProvider>().makeSpeaker(int.parse(id));
    }

    notifyListeners();
  }

  /// Attendee speaker request
  Future requestFromAttend(BuildContext context) async {
    print("speaker access emit success for ");

    final data = jsonEncode({
      "uid": meeting.userId,
      "data": {
        "command": "speakerAccess",
        "value": {"name": userData.userName, "id": userData.id, "email": userData.userEmail, "profilePic": null}
      }
    });
    print("speaker access emit success for $data");
    hubSocket.socket?.emitWithAck("onCommand", data, ack: (_) {
      log("speaker access emit success for speaker request");
      // Navigator.pop(context);
    });
    notifyListeners();
    var body = {
      "key": "speakerAccess",
      "roomId": meeting.id,
    };
    print("speaker access emit success for $body");
  }

  void toggleGlobalVideo() {
    _emitGlobalAccessCommand(command: 'onPanalCommand', type: 'video', value: !globalVideoOn);
  }

  void toggleGlobalChat() {
    _emitGlobalAccessCommand(command: 'onCommand', type: 'chat', value: !globalChatOn);
  }

  void toggleGlobalEmoji() {
    _emitGlobalAccessCommand(command: 'onCommand', type: 'emoji', value: !globalEmojiOn);
  }

  void toggleHandleRaise(bool raised, userID) {
    final updatedSpeakers = speakers.map((e) => e.id == userID ? e.copyWith(hr: raised) : e).toList();
    speakers = updatedSpeakers;
    notifyListeners();
  }

  void togglePinnedStatus(HubUserData data) {
    _emitSingleAccessCommand(
      command: 'onPanalCommand',
      type: 'pu',
      value: !data.pu!,
      userData: data.copyWith(pu: !data.pu!),
    );
  }

  void toggleAudio(HubUserData data) {
    _emitSingleAccessCommand(
      command: 'onPanalCommand',
      type: 'iae',
      value: !data.isAudioEnabled!,
      userData: data.copyWith(iae: !data.isAudioEnabled!),
    );
  }

  void toggleVideo(HubUserData data) {
    _emitSingleAccessCommand(
      command: 'onPanalCommand',
      type: 'ive',
      value: !data.isVideoEnabled!,
      userData: data.copyWith(ive: !data.isVideoEnabled!),
    );
  }

  void toggleHostStatus(HubUserData data) {
    _emitSingleAccessCommand(
      command: 'onCommand',
      type: 'mch',
      value: !data.activeHost!,
      userData: data.copyWith(mch: !data.activeHost!, activeHost: !data.activeHost!),
      other: {
        'activeHost': 'Active-Host',
      },
    );
  }

  void toggleCoHostStatus(HubUserData data, AllParticipantsModel action) async {
    print("from user data ${data.id}");
    print("from user data ${action.name}");
    print("from user data ${meeting.userId}");
    print("from user data ${data.makeCohost}");

    await qwkRepo.updateRole(
      {
        "user_id": data.id,
        'meeting_id': meeting.id,
        'from_user_id':meeting.userId,
        'role_type': data.makeCohost == true ? 'Attendee' : 'Co-host',
      },
    );

    _emitSingleAccessCommand(
      command: 'onCommand',
      type: 'mch',
      value: !data.makeCohost!,
      userData: data.copyWith(mch: !data.makeCohost!),
      other: {
        'activeHost': false,
      },
    );
  }

  void makeSpeaker(int uid) {
    final data = jsonEncode({
      'uid': uid,
      'data': {'command': 'addToPanel', 'id': uid, 'mode': 'guestList', 'redirectUrl': '${meeting.id}/${meeting.autoGeneratedId}/${meeting.participantKey}'}
    });
    hubSocket.socket?.emitWithAck('onCommand', data, ack: (_) {});
    guests.removeWhere((u) => u.id == uid);

    notifyListeners();
  }

  void makeAttendee(HubUserData user) async {
    final data = jsonEncode({
      'uid': user.id,
      'data': {'command': 'addToPanel', 'id': user.id, 'mode': 'panelList', 'redirectUrl': '${meeting.id}/${meeting.autoGeneratedId}/${meeting.guestKey}'}
    });
    hubSocket.socket?.emitWithAck('onCommand', data, ack: (_) {
      log("makeAttendee success for ${user.id}");
    });

    final response = await oesRepo.fetchOesUserDetails(user.oAcId.toString());
    if (response.statusCode == 200) {
      // final oesUser = GuestUser.fromJson(response.data['data'], user.id!);
      guests.add(user.copyWith(ro: 'Guest'));
      notifyListeners();
    }
  }

  void toggleTempBlockStatus({
    required int id,
    String? ri,
    String? peerId,
  }) async {
    final isBlocked = tempBlockedUsers.any((p) => p.id == id);

    await qwkRepo.blockAttendee(
      {
        "from_user_id": myHubInfo.id,
        'is_blocked': isBlocked ?0 : 2,
        'user_id': id,
        'meeting_id': meeting.id,
      },
    );

  //   {
  //     "is_blocked": 1,
  //   "meeting_id": "662b69cd1e0f8b000837a4c6",
  //   "user_id": 4473569,
  //   "from_user_id": 4476940
  // }
    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'Block',
        'value': isBlocked ? 'unBlock' : 'temporary',
        'id': id,
        'ri': ri,
        'user_id': userData.id, // host user id
        'meeting_id': meeting.id,
        'from': userData.id,
        'roleType': attendee.roleType,
        'peerId': peerId,
        'sessionId': context.read<MeetingRoomProvider>().currentMeetingSessionId,
      }
    });

    hubSocket.socket?.emitWithAck('onCommand', data, ack: (_) {
      log("blockTemporarily success for $id");
    });
  }

  void blockUser({
    required int id,
    required bool activeHost,
    String? ri,
  }) async {
    await qwkRepo.blockAttendee(
      {
        "from_user_id": myHubInfo.id,
        'is_blocked':1,
        'user_id': id,
        'meeting_id': meeting.id,
      },
    );

    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'Block',
        'value': 'permanent',
        'id': id,
        'ri': ri,
        'user_id': userData.id, // host user id
        'meeting_id': meeting.id,
        'from': userData.id,
        'activeHost': activeHost, // TODO(appal): confirm this later
      }
    });
    hubSocket.socket?.emitWithAck('onCommand', data, ack: (_) {
      log("blockTemporarily success for $id");
    });
  }

  void removeParticipant(int id, [String? ri]) {
    final data = jsonEncode({
      'uid': id,
      'data': {
        'command': 'leave',
        'id': id,
        'closeAttendeeAction': true,
        'type': attendee.roleType,
        'ri': ri,
        'user_id': userData.id, // host user id
        'meeting_id': meeting.id,
        'fromwww': userData.id,
        'roleType': attendee.roleType,
      }
    });

    hubSocket.socket?.emitWithAck('onCommand', data, ack: (_) {
      log("removeSpeaker success for $id");
    });
  }

  void _emitGlobalAccessCommand({
    required String command,
    required String type,
    required bool value,
  }) {
    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'globalAccess',
        'type': type,
        'value': value,
        'activeHost': false, // TODO(appal): make it dynamic
        'user_id': userData.id,
        'meeting_id': meeting.id,
      }
    });
    print("global access emit success for $type:$value");
    hubSocket.socket?.emitWithAck(command, data, ack: (_) {
      log("global access emit success for $type:$value");
    });
  }

  void _emitSingleAccessCommand({
    required String command,
    required String type,
    required bool value,
    required HubUserData userData,
    Map<String, dynamic>? other,
  }) {
    final data = jsonEncode({
      'uid': 'ALL',
      'data': {
        'command': 'singleAccess',
        'type': type,
        'value': value,
        'id': userData.id, // TODO(appal): whose id do we have to send
        'ri': userData.roomId,
        'uid': userData.id,
        ...?other,
        'roleType': hubSocketInput.userData.role,
        'userData': userData.toJson(),
      },
    });

    hubSocket.socket?.emitWithAck(command, data, ack: (_) {
      log("global access emit success for $type:$value");
    });
  }

  void resetParticipantsState() {
    speakers = [];
    tempBlockedUsers = [];
    guests = [];
  }

  void setGlobalActionsStatus(Data data, UserRole userRole) {
    context.read<WebinarProvider>().updateAllowedActions(userRole, from: "global actions status");
  }

  void setUserRole(String role, String peerId) {
    speakers = speakers.map((p) => p.peerId == peerId ? p.copyWith(ro: role) : p).toList();
    notifyListeners();
  }

  void lowerHandForAll() {
    speakers = speakers.map((p) => p.copyWith(hr: false)).toList();
    notifyListeners();
  }
}
