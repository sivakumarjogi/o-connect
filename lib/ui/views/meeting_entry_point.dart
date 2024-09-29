import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/meeting_data_response.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:provider/provider.dart';

/// Entry point for joining the meeting. This will validate if we are in a proper
/// state to join the meeting
Future<void> tryJoinMeeting(BuildContext context, {bool isHostJoing = false, String? meetingId, String? meetingUrl, bool fromUrl = false}) async {
  print("You are already in an another meeting.");

  bool isInMeeting = context.read<AppGlobalStateProvider>().isMeetingInProgress;
  if (isInMeeting) {
    CustomToast.showErrorToast(msg: "You are already in an another meeting.");
    return;
  }
  context.showLoading();
  try {
    String mId;
    late String userKey;
    bool isHost = isHostJoing;
    MeetingDataResponse? res;
    print("hello ishostttttttttttttttttt $isHostJoing......$meetingUrl............ $meetingId");
    // if (meetingUrl != null) {
    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    if (meetingUrl != null && fromUrl == true) {
      mId = meetingUrl.split("/")[8];
    } else {
      mId = meetingId!;
    }
    final meetingRoomProvider = context.read<MeetingRoomProvider>();
    res = await meetingRoomProvider.fetchMeetingDetailsById(mId.toString());

    if (userData.id.toString() == res.data!.userId.toString()) {
      isHost = true;
    }
    // }

    if (isHost) {
      assert(meetingId != null && meetingId.isNotEmpty, ' meeting id is required');
      mId = meetingId!;
    } else if (meetingUrl != null && fromUrl) {
      assert(meetingUrl != null && meetingUrl.isNotEmpty, 'dynamic url is required');
      mId = meetingUrl.split("/")[8];
      userKey = meetingUrl.split("/")[10];
      print("hello ishostttttttttttttttttt $mId......$userKey............ $meetingId");
    }

    //  mId = '65e95d731d9754000805078a';
    //   userKey = '9xQNDOjeBl';
    //   isHost = false;

    /// set joined user role
    if (isHost) {
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.hostKey;
    } else if (meetingId != null && fromUrl == false && res.data!.meetingType == "conference") {
      print("joined user conference ${context.read<HomeScreenProvider>().getMeetingKey}");
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.participantKey;
    } else if (meetingId != null && fromUrl == false && res.data!.meetingType == "webinar") {
      print("joined user webinar ${context.read<HomeScreenProvider>().getMeetingKey}");
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.guestKey;
    } else if (meetingId == null && fromUrl && userKey == res.data!.participantKey) {
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.participantKey; // need to update
    } else if (meetingId == null && fromUrl && userKey == res.data!.guestKey) {
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.guestKey; // need to update
    }else {
      context.read<HomeScreenProvider>().getMeetingKey = res.data!.guestKey;
    }

    print("joined user type ${context.read<HomeScreenProvider>().getMeetingKey}");
    if (res.status == true && context.mounted) {
      final now = DateTime.now().toLocal();
      final meetingDate = res.data!.meetingDate!.toLocal();
      final meetingTimeDifInMins = now.difference(meetingDate).inMinutes.abs();
      final isMeetingForLater = now.isBefore(meetingDate);

      if (isMeetingForLater && meetingTimeDifInMins > 15) {
        context.hideLoading();
        DateTime currentDateWithoutTime = DateTime(now.year, now.month, now.day);

        // Get meetingDate without the time
        DateTime meetingDateWithoutTime = DateTime(meetingDate.year, meetingDate.month, meetingDate.day);
        CustomToast.showErrorToast(
          msg: meetingDateWithoutTime.isAfter(currentDateWithoutTime) ? "Please try to start the event as scheduled date" : "Meeting can start before 15 minutes of the scheduled time",
        );
      } else {
        context.hideLoading();

        final headerInfo = context.read<AuthApiProvider>().profileData;
        await context.read<MeetingRoomProvider>().initialize(
              meetingId: res.data!.id!,
              autoGeneratedId: res.data!.autoGeneratedId!,
              headerInfo: headerInfo!,
              userKey: context.read<HomeScreenProvider>().getMeetingKey.toString()
              // userKey: isHost
              //     ? res.data!.hostKey!
              //     : !fromUrl
              //         ? res.data!.hostKey!
              //         : userKey,
            );

        final meetingRoomProvider = context.read<MeetingRoomProvider>();

        if (meetingRoomProvider.initialized) {
          // If meeting already started before then directly join
          if (res.data!.isStarted == 1 && meetingRoomProvider.globalAccessStatus.data?.eventStatus?.status == 'EventStarted') {
            meetingRoomProvider.joinMeeting(fromLobby: false);
          }
          // Go to lobby and wait for host to start the meeting
          else {
            if (isHost) {
              Navigator.of(context).pushNamed(RoutesManager.lobbyScreen, arguments: meetingId!);
            } else {
              Navigator.of(context).pushNamed(RoutesManager.lobbyScreenWaiting, arguments: meetingUrl);
            }
          }
        }
      }
    }
  } on DioException catch (e, st) {
    log("Error while joining meeting  $e", error: e, stackTrace: st);
    context.hideLoading();

    print(e.requestOptions);

    if (e.response != null && e.response?.data != null) {
      if (e.response?.data['message'] != null) {
        context.showErrorAndPop(e.response?.data['message'].toString() ?? "Something went wrong");
      } else if (e.response?.data['error'] != null && e.response?.data['error']['message'] != null) {
        CustomToast.showErrorToast(msg: e.response?.data['error']['message'].toString());
      }
    } else {
      CustomToast.showErrorToast(msg: "Something went wrong");
    }
  } catch (e, st) {
    log("init meeting error", error: e, stackTrace: st);
    context.hideLoading();
    CustomToast.showErrorToast(msg: "Something went wrong");
  }
}
