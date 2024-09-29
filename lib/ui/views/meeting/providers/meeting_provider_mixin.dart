// import 'package:flutter/material.dart';
// import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
// import 'package:o_connect/core/providers/app_global_state_provider.dart';
// import 'package:o_connect/core/service/api_helper/api_helper.dart';
// import 'package:o_connect/my_app.dart';
// import 'package:o_connect/ui/utils/base_urls.dart';
// import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
// import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
// import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';
// import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
// import 'package:o_connect/ui/views/meeting/model/new_attendee_response/data.dart';
// import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
// import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
// import 'package:o_connect/ui/views/meeting/signaling/room_socket.dart';
// import 'package:provider/provider.dart';
// import 'meeting_room_provider.dart';

// mixin MeetingUtilsMixin {
//   HubSocket hubSocket = HubSocket.instance;
//   MeetingRoomWebsocket roomSocket = MeetingRoomWebsocket.instance;

//   final MeetingRoomRepository globalStatusRepo = MeetingRoomRepository(
//     ApiHelper().oConnectDio,
//     baseUrl: BaseUrls.globalAccessStatusSetUrl,
//   );

//   final MeetingRoomRepository gloablSetRepo = MeetingRoomRepository(
//     ApiHelper().oConnectDio,
//     baseUrl: BaseUrls.globalAccessSetUrl,
//   );

//   final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
//     ApiHelper().oConnectDio,
//     baseUrl: BaseUrls.meetingBaseUrl,
//   );

//   BuildContext get context => navigationKey.currentContext!;

//   MeetingData get meeting => context.read<MeetingRoomProvider>().meeting;

//   AttendeeData get attendee => context.read<MeetingRoomProvider>().attendee;

//   GenerateTokenUser get userData => context.read<MeetingRoomProvider>().userData;

//   HubUserData get hubInfo => context.read<ParticipantsProvider>().myHubInfo;

//   String get meetingJoinKey => context.read<HomeScreenProvider>().initialLink.split("/")[10].toString();

//   bool get isInPipView => context.read<AppGlobalStateProvider>().isPIPEnabled;
// }
