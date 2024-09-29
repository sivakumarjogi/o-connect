import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_actions.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/push_link.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/user_cache_service.dart';

class PushLinkProvider extends BaseProvider with MeetingUtilsMixin {
  late TextEditingController pushLinkUrlController;
  late TextEditingController pushLinkTextController;

  @override
  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl:BaseUrls.globalAccessStatusSetUrl,
  );

  String? title;
  String? url;
  bool pushLinkVisible = false;
  bool showSetAsDefault = false;
  bool setAsDefaultStatus = false;

  void toggleShowAsDefault({bool status = false}) {
    showSetAsDefault = status;
    notifyListeners();
  }

  void toggleShowAsDefaultStatus({
    bool status = false,
  }) {
    setAsDefaultStatus = status;
    navigationKey.currentContext!.read<DefaultUserDataProvider>().updatePushLink(
          buttonText: pushLinkTextController.text.trim(),
          buttonUrl: pushLinkUrlController.text.trim(),
        );
    notifyListeners();
  }

  initControllers({
    String title = "",
    String url = "",
  }) {
    pushLinkUrlController = TextEditingController(text: url);
    pushLinkTextController = TextEditingController(text: title);
  }

  disposeControllers() {
    pushLinkUrlController.dispose();
    pushLinkTextController.dispose();
  }

  void setUpPushLinkListeners() {
    hubSocket.socket?.on("commandResponse", (res) {
      print("go the response push link");
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final type = data['data']['type'];
      final command = data['data']['command'];
      print("the socket data $type $command $value");
      if (type == "ShareLink") {
        title = value["textMessage"];
        url = value["buttonUrl"];
        print("the socket data $title $url");
        pushLinkVisible = true;
        notifyListeners();
        addTopActionToDashboard(MeetingAction.pushLink);
      }

      if (command == "removeShareLink") {
        title = null;
        url = null;
        pushLinkVisible = false;
        notifyListeners();
        removeTopAction(MeetingAction.pushLink);
      }
    });
  }

  Future<void> setPushLink(BuildContext context, String linkText, String linkUrl) async {
    String meetingId = context.read<MeetingRoomProvider>().meeting.id.toString();
    final userData = context.read<ParticipantsProvider>().myHubInfo;

    try {
      debugPrint("the role is the ${myHubInfo.role}");

      final data = {
        "key": "Link",
        "roomId": meetingId,
        "value": {
          "dataforSocket": {"textMessage": linkText, "buttonUrl": linkUrl, "roleType": myHubInfo.role.toString(), "userId": userData.id},
          "pushLinkReduxState": {"isLink": true, "value": "pushLink", "ou": userData.id, "on": userData.email, "roleType": myHubInfo.role}
        }
      };
      String? oConnectTkn = await serviceLocator<UserCacheService>().getOConnectToken();
      print("the data is the ${data.toString()}");
      print("the data is the ${oConnectTkn.toString()}");
      // Dio dio = Dio();
      // Response response =
      //     await dio.post(options: Options(headers: {
      //       'Accept': 'application/json',
      //       "Authorization": oConnectTkn}), "https://06ws9o0ac7.execute-api.ap-south-1.amazonaws.com/PPMulti/global-access/status/set", data: data);
      //
      // print("the ffffffffffffffffff response ${response.toString()}");

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        addTopActionToDashboard(MeetingAction.pushLink);
        _emitSetPushEvent(linkText, linkUrl, userData.id ?? 0, myHubInfo.role.toString());
        Navigator.of(context).pop();
        CustomToast.showSuccessToast(msg: res.data["data"]);
      }
    } on DioException catch (e, st) {
      debugPrint("the Dio exception set Push Link $st");
      debugPrint("the Dio exception set Push Link ${e.response}");
      CustomToast.showErrorToast(msg: "Error while set push link");
    } catch (e, st) {
      debugPrint("the Dio exception set Push Link ${e.toString()}  $st");
    }

    notifyListeners();
  }

  _emitSetPushEvent(String title, String url, int userId, String roleType) {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "globalAccess",
        "type": "ShareLink",
        "value": {"textMessage": title, "buttonUrl": url, "roleType": roleType, "userId": userId}
      }
    };
    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      print("the socket set push link called");
    });
  }

  Future<void> removePushLink(BuildContext context) async {
    context.read<WebinarProvider>().disableActiveFuture();
    try {
      final data = {
        "key": "remove",
        "roomId": meeting.id,
        "value": ["Link"]
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        removeTopAction(MeetingAction.pushLink);
        _emitDeletePushLinkEvent();
        // CustomToast.showSuccessToast(msg: res.data["data"]);
      }
    } on DioException catch (e) {
      debugPrint("the Dio exception delete Push Link ${e.response}");
    } catch (e, st) {
      debugPrint("the Dio exception delete Push Link ${e.toString()}  $st");
    }

    notifyListeners();
  }

  _emitDeletePushLinkEvent() {
    final data = {
      "uid": "ALL",
      "data": {"command": "removeShareLink", "value": false}
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      print("the socket delete push link called");
    });
  }

  void setInitialPushLinkData(InitialPushLink initialPushLink) {
    url = initialPushLink.data.btnUrl;
    title = initialPushLink.data.message;
    notifyListeners();
  }

  void resetState() {
    title = null;
    url = null;
    pushLinkVisible = false;
  }

/*void clearData() {
    title = null;
    url = null;
    notifyListeners();
  }*/
}
