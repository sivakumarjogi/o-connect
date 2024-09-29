import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/global_set_models/global_set_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/call_to_action/data/call_to_action_repository.dart';
import 'package:o_connect/ui/views/call_to_action/model/call_to_action_request_model.dart';
import 'package:o_connect/ui/views/call_to_action/model/call_to_action_response_model.dart';
import 'package:o_connect/ui/views/call_to_action/model/call_to_action_set_status_request_model.dart';
import 'package:o_connect/ui/views/call_to_action/model/cta_response_data_model.dart';
import 'package:o_connect/ui/views/chat_screen/chat_repo/chat_repository.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_actions.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/timer_toggle_buttons.dart';
import 'package:provider/provider.dart';

class DashBoardCallToActionProvider extends BaseProvider with MeetingUtilsMixin {
  final CallToActionRepository callToActionRepo = CallToActionRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );

  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  ChatApiRepository chatApiRepository = ChatApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.globalAccessSetUrl);

  Color titleTextBGColor = const Color(0xff9DEE90);
  Color titleTextColor = const Color(0xff443a49);
  Color buttonUrlBGColor = const Color(0xff1D9BF0);
  Color buttonUrlTextColor = const Color(0xff443a49);

  String? titleText, buttonUrlText, buttonText;

  Color currentBackGroundTitleColor = const Color(0xff9DEE90);
  Color currentTextTitleColor = const Color(0xff1D9BF0);

  Color currentBackGroundButtonColor = const Color(0xff9DEE90);
  Color currentTextButtonColor = const Color(0xff1D9BF0);

  String setTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";

  List<Widget> linksData = [];
  int totalTimeInSeconds = 120;
  String? formatTotalTimeInSeconds = "02:00";
  String displayTimeValue = "02:00";
  Timer? _timer;

  AddTime? selectedTime;
  bool callToActionLoading = false;

  bool speakerTappedCTA = false;

  int ctaTapCount = 0;
  int minutes = 02;
  int seconds = 00;

  CallToActionResponseModelData? callToActionResponseModelData;
  CtaResponseDataModel? ctaResponseDataModel;
  bool showSetAsDefault = false;
  bool setAsDefaultStatus = false;

  void setInitialCtaResponse(CtaResponseDataModel model) {
    ctaResponseDataModel = model;
    notifyListeners();
  }

  set toggleShowSetAsDefault(bool status) {
    showSetAsDefault = status;
    notifyListeners();
  }

  void changeSetAsDefaultStatus({
    bool status = false,
    String buttonTxt = "",
    String buttonUrl = "",
    String title = "",
    bool callApi = false,
  }) {
    setAsDefaultStatus = status;
    notifyListeners();
    // if (!status) {
    //   clearData();
    // }
    if (!callApi) {
      return;
    }
    navigationKey.currentContext!.read<DefaultUserDataProvider>().updateCallToAction(
          buttonTxt: status ? buttonTxt : "",
          buttonUrl: status ? buttonUrl : "",
          // todo: as per the request from web
          displayTime: 2,
          title: status ? title : "",
          titleBgClr: titleTextBGColor.toHex(),
          titleClr: titleTextColor.toHex(),
          btnBgClr: buttonUrlBGColor.toHex(),
          btnClr: buttonUrlTextColor.toHex(),
        );

    notifyListeners();
  }

  void updateValues({required String title, required String url, required String buttonTextValue}) {
    titleText = title;
    buttonUrlText = url;
    buttonText = buttonTextValue;
  }

  void clearData({bool fromInitState = false, bool callUserDefaultApi = false}) {
    titleTextBGColor = const Color(0xff9DEE90);
    titleTextColor = const Color(0xff443a49);
    buttonUrlBGColor = const Color(0xff1D9BF0);
    buttonUrlTextColor = const Color(0xff443a49);
    formatTotalTimeInSeconds = "02:00";
    displayTimeValue = "02:00";
    totalTimeInSeconds = 120;
    selectedTime = null;
    titleText = null;
    buttonUrlText = null;
    buttonText = null;
    ctaTapCount = 0;
    setAsDefaultStatus = false;
    if (callUserDefaultApi) {
      navigationKey.currentContext!.read<DefaultUserDataProvider>().updateCallToAction(
            buttonTxt: "",
            buttonUrl: "",
            // todo: as per the request from web
            displayTime: 2,
            title: "",
            titleBgClr: "#a9b0b2",
            titleClr: "#ffffff",
            btnBgClr: "#1D9BF0",
            btnClr: "#ffffff",
          );
    }
    if (fromInitState) {
      toggleSetAsDefault(false);
    }
    notifyListeners();
  }

  void toggleSetAsDefault(bool status) {
    print(status);

    showSetAsDefault = status;
    notifyListeners();
  }

  void updateDefaultColors({
    required String titleBgClr,
    required String titleClr,
    required String btnBgClr,
    required String btnClr,
  }) {
    titleTextBGColor = titleBgClr.hexToColor;
    titleTextColor = titleClr.hexToColor;
    buttonUrlBGColor = btnBgClr.hexToColor;
    buttonUrlTextColor = btnClr.hexToColor;
    notifyListeners();
  }

  set updateTitleTextBgColor(Color color) {
    titleTextBGColor = color;
    notifyListeners();
  }

  set updateTitleTextColor(Color color) {
    titleTextColor = color;
    notifyListeners();
  }

  set updateButtonUrlBGColor(Color color) {
    buttonUrlBGColor = color;
    notifyListeners();
  }

  set updateButtonUrlTextColor(Color color) {
    buttonUrlTextColor = color;
    notifyListeners();
  }

  updatedColorForCallToActions({required BuildContext context, required Color updateColor, required Color pickedColor, required int index}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 0,
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickedColor,
                  onColorChanged: (Color color) {
                    updateColor = color;
                    notifyListeners();
                  },
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (index == 1) {
                        titleTextBGColor = updateColor;
                      } else if (index == 2) {
                        titleTextColor = updateColor;
                      } else if (index == 3) {
                        buttonUrlBGColor = updateColor;
                      } else if (index == 4) {
                        buttonUrlTextColor = updateColor;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                    },
                    child: const Text(ConstantsStrings.save))
              ],
            )).then((value) {
      FocusScope.of(context).unfocus();
    });
  }

  String getAddedTime() {
    DateTime now = DateTime.now()
        .add(Duration(minutes: int.parse(formatTotalTimeInSeconds!.split(":").first), seconds: int.parse(formatTotalTimeInSeconds!.split(":").last)))
        .toUtc(); // Get the current time in UTC
    String addedTime = now.toIso8601String();
    return addedTime;
  }

  void updateTotalTime(AddTime time) {
    selectedTime = time;
    switch (time) {
      case AddTime.two:
        totalTimeInSeconds = 2 * 60;
        break;
      case AddTime.five:
        totalTimeInSeconds = 5 * 60;
        break;
      case AddTime.ten:
        totalTimeInSeconds = 10 * 60;
        break;
      case AddTime.fifteen:
        totalTimeInSeconds = 15 * 60;
        break;
    }

    String secondsFormatted = (totalTimeInSeconds % 60).toString().padLeft(2, '0');
    String minutesFormatted = (totalTimeInSeconds ~/ 60).toString().padLeft(2, '0');
    minutes = (totalTimeInSeconds ~/ 60);
    seconds = (totalTimeInSeconds % 60);

    formatTotalTimeInSeconds = '$minutesFormatted:$secondsFormatted';

    notifyListeners();
  }

  void increaseDecreaseTime({required String type}) {
    if (type == "increase") {
      // if (minutes < 59 && seconds < 59) {
      //   seconds++;
      // } else if (minutes < 59 && seconds == 59) {
      minutes++;
      seconds = 00;
      // }
    } else if (type == "decrease") {
      if (minutes > 0 || seconds > 0) {
        //   if (seconds > 0) {
        //     seconds--;
        //   } else {
        minutes--;
        seconds = 00;
        //   }
      }
    }

    String secondsFormatted = (totalTimeInSeconds % 60).toString().padLeft(2, '0');
    String minutesFormatted = (totalTimeInSeconds ~/ 60).toString().padLeft(2, '0');
    formatTotalTimeInSeconds = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  void callToActionSocketListeners() {
    hubSocket.socket?.on("commandResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final command = data['data']['command'];
      final type = data['data']['type'];
      if (type == "callToAction") {
        print("call to action    ${value.toString()}");
        ctaResponseDataModel = CtaResponseDataModel.fromJson(value);
        formatTotalTimeInSeconds = "${ctaResponseDataModel!.displayTime!.minutes}:${ctaResponseDataModel!.displayTime!.seconds}";
        if (data['from'].toString() != myHubInfo.id.toString()) showTimerAtDashBoard();
        notifyListeners();
      }
      if (type == "popupCalltoActions") {
        ctaTapCount = value["clickedCount"];
        print("the count is the ${value["clickedCount"]}");
        notifyListeners();
        debugPrint("the no of taps $ctaTapCount");
      }

      if (command == "removecalltoAction") {
        ctaTapCount = 0;
        speakerTappedCTA = false;
        notifyListeners();
      }
    });

    hubSocket.socket?.on("panalResponse", (res) {
      final decoded = jsonDecode(res) as Map<String, dynamic>;
      final data = decoded['data'];
      final value = data['value'];

      if (value == "callToAction") {
        print("call to action panalResponse listening");
        if (data['command'] == 'AccessRestriction') {
          var action = data['feature']['action'];
          if (action == 'opened') {
            addTopActionToDashboard(MeetingAction.callToAction);
          } else if (action == 'removed') {
            removeTopAction(MeetingAction.callToAction);
            speakerTappedCTA = false;
          }
        }
      }
    });
  }

  Future<void> createCallToAction() async {
    callToActionLoading = true;
    notifyListeners();
    try {
      DateTime dateTime = DateTime.parse(meeting.meetingDate.toString());
      DateTime utcTime = dateTime.toUtc();

      String formattedUtcTime = utcTime.toIso8601String();
      final data = CallToActionRequestModel(
        userId: context.read<MeetingRoomProvider>().userData.id,
        meetingId: meeting.id,
        meetingName: meeting.meetingName.toString(),
        meetingDate: formattedUtcTime,
        title: titleText,
        buttonUrl: buttonUrlText,
        buttonTxt: buttonText,
        displayTime: DisplayTime(minutes: formatTotalTimeInSeconds!.split(":").first, seconds: formatTotalTimeInSeconds!.split(":").last),
      );
      debugPrint("the CTA Payload is the ${data.toJson()}");
      CallToActionResponseModel response = await callToActionRepo.createCallToAction(data.toJson());
      if (response.status ?? false) {
        callToActionResponseModelData = response.data;
        _globalAccessSet();
      }
    } on DioException catch (e, st) {
      debugPrint("the CTA error is the ${e.error} && ${e.response} && $st");
      if (e.response!.statusCode == 500) {
        CustomToast.showErrorToast(msg: "Something went wrong");
      }
    } catch (e, st) {
      print("the cached error $e $st");
    }
    callToActionLoading = false;
    notifyListeners();
  }

  Future<void> _globalAccessSet() async {
    try {
      final data = GlobalSetRequestModel(meetingId: meeting.id, action: "open", feature: "callToAction", userId: context.read<MeetingRoomProvider>().userData.id, type: "others", role: 1);

      var res = await chatApiRepository.questionAndAnsSet(data.toJson());

      print("the response set Status ${res.toString()}   ${res["status"]}");
      if (res["status"]) {
        addTopActionToDashboard(MeetingAction.callToAction);
        _globalStatusSet();
      }
    } on DioException catch (e) {
      print("the dio exception set ${e.response}");
      if (e.response!.statusCode == 500) {
        CustomToast.showInfoToast(msg: "Something went wrong");
      }
    } catch (e, st) {
      debugPrint("Call to action exception $e  $st");
    }
  }

  CallToActionSetStatusRequestModelValue _requestValueData(BuildContext context) {
    final userId = context.read<MeetingRoomProvider>().userData.id;
    final userOMail = context.read<MeetingRoomProvider>().userData.userEmail;

    DateTime dateTime = DateTime.parse(meeting.meetingDate.toString());
    DateTime utcTime = dateTime.toUtc();

    String formattedUtcTime = utcTime.toIso8601String();
    final data = CallToActionSetStatusRequestModelValue(
      userId: userId,
      meetingId: meeting.id,
      meetingName: meeting.meetingName,
      meetingDate: formattedUtcTime,
      title: callToActionResponseModelData!.title.toString() ?? "",
      buttonUrl: callToActionResponseModelData!.buttonUrl.toString() ?? "",
      buttonText: callToActionResponseModelData!.buttonText.toString() ?? "",
      displayTime: CallToActionSetStatusRequestModelDisplayTime(minutes: callToActionResponseModelData!.displayTime!.minutes, seconds: callToActionResponseModelData!.displayTime!.seconds),
      isActive: 1,
      createdOn: callToActionResponseModelData!.createdOn.toString(),
      updatedOn: callToActionResponseModelData!.updatedOn.toString(),
      id: callToActionResponseModelData!.id.toString(),
      headerBgColor: titleTextBGColor.toHex(),
      headerTextColor: titleTextColor.toHex(),
      buttonBgColor: buttonUrlBGColor.toHex(),
      buttonTextColor: buttonUrlTextColor.toHex(),
      ou: userId,
      on: userOMail,
      addedTime: getAddedTime(),
    );

    return data;
  }

  Future<void> _globalStatusSet() async {
    try {
      final data = CallToActionSetStatusRequestModel(key: "callToAction", roomId: meeting.id, value: _requestValueData(context));

      final res = await meetingRepo.updateGlobalAccessStatus(data.toJson());

      if (res.data["status"]) {
        showTimerAtDashBoard();
        _emitCommandResponse(context);
        _emitOnPanalCommand(context);
      }
    } on DioException catch (e) {
      print("the dio exception set status ${e.response}");
    } catch (e, st) {
      debugPrint("Call to action exception $e  $st");
    }
  }

  void showTimerAtDashBoard() {
    List<String> timeParts = formatTotalTimeInSeconds.toString().split(':');
    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("timer: ${timer.tick}");
      if (seconds > 0) {
        seconds--;
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
        } else {
          _timer?.cancel();
          debugPrint("the dkabv ${myHubInfo.isHostOrActiveHost}");
          if (myHubInfo.isHostOrActiveHost) {
            deleteCTAGlobalSet();
          }
        }
      }

      String minutesFormatted = minutes.toString().padLeft(2, '0');
      String secondsFormatted = seconds.toString().padLeft(2, '0');

      displayTimeValue = '$minutesFormatted:$secondsFormatted';

      if (minutes == 0 && seconds == 0) {
        _timer?.cancel();
        if (myHubInfo.isHostOrActiveHost) {
          deleteCTAGlobalSet();
        }
        print("the is host ${myHubInfo.isHost}");
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void _emitCommandResponse(BuildContext context) {
    /* final data = {"uid": "ALL", "data": requestValueData(context).toJson()};*/

    final hubInformation = context.read<ParticipantsProvider>().myHubInfo;
    final data = {
      "uid": "ALL",
      "data": {"command": "globalAccess", "value": _requestValueData(context).toJson(), "type": "callToAction", "ou": meeting.id, "on": hubInformation.email}
    };

//     {
//   "uid": "ALL",
//   "data": {
//     "command": "globalAccess",
//     "value": {
//       "user_id": 4474724,
//       "meeting_id": "6629e7f1a0ab640008879a0a",
//       "meeting_name": "cdhsh",
//       "meeting_date": "2024-04-25T05:29:00.000Z",
//       "title": "esttntsr",
//       "button_url": "https://grawv.com",
//       "button_text": "hreaer",
//       "display_time": {
//         "minutes": "02",
//         "seconds": "00"
//       },
//       "is_active": 1,
//       "created_on": "2024-04-25T05:55:22.999Z",
//       "updated_on": "2024-04-25T05:55:22.999Z",
//       "_id": "6629f04bc8af8800083d9349",
//       "headerBgColor": "#a9b0b2",
//       "headerTextColor": "#ffffff",
//       "buttonBgColor": "#1D9BF0",
//       "buttonTextColor": "#ffffff",
//       "ou": 4474724,
//       "on": "pk05@qa.o-mailnow.net",
//       "addedTime": "2024-04-25T05:57:23.024Z"
//     },
//     "type": "callToAction",
//     "ou": 4474724,
//     "on": "pk05@qa.o-mailnow.net"
//   }
// }

    debugPrint("the emit oncommand Payload $data");

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      print("call to action onCommand called");
    });
  }

  void _emitOnPanalCommand(BuildContext context) {
    final userData = context.read<ParticipantsProvider>().myHubInfo;
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {"action": "opened"},
        "value": "callToAction",
        "ou": meeting.id,
        "on": userData.displayName
      }
    };
    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      print("call to action onPanalCommand called");
    });
  }

  Future<void> deleteCTAGlobalSet() async {
    removeTopAction(MeetingAction.callToAction);
    context.read<WebinarProvider>().disableActiveFuture();

    final userData = context.read<ParticipantsProvider>().myHubInfo;
    try {
      final data = GlobalSetRequestModel(
        userId: userData.id,
        role: 1,
        type: "others",
        feature: "callToAction",
        action: "close",
      );

      debugPrint("deleteCTAGlobalSet request json data ${data.toJson().toString()}");

      chatApiRepository.questionAndAnsSet(data.toJson()).then((res) {
        if (res["status"]) {
          _deleteCTA(context);
        }
      });
    } on DioException catch (e) {
      debugPrint("the deleteCTAGlobalSet CTA delete dio exception ${e.response} ");
    } catch (e, st) {
      debugPrint("the deleteCTAGlobalSet CTA delete  exception ${e.toString()}  && $st");
    }
  }

  Future<void> _deleteCTA(BuildContext context) async {
    final userId = context.read<MeetingRoomProvider>().userData.id;
    try {
      final data = {"id": userId};
      final res = await callToActionRepo.deleteCTA(data);
      print("the delete CTA ${res.data.toString()}");
      if (res.data["status"]) {
        _deleteCTAGlobalSetStatus(context);
      }
    } on DioException catch (e) {
      debugPrint("the CTA delete dio exception ${e.response} ");
      /* CustomToast.showErrorToast(msg: e.response!.data["error"]);*/
    } catch (e) {
      debugPrint("the CTA delete  exception ${e.toString()}");
    }
  }

  Future<void> _deleteCTAGlobalSetStatus(BuildContext context) async {
    String meetingId = context.read<MeetingRoomProvider>().meeting.id.toString();
    try {
      final data = {
        "key": "remove",
        "roomId": meetingId,
        "value": ["callToAction", "popupCalltoActions"]
      };
      meetingRepo.updateGlobalAccessStatus(data).then((res) {
        print("the set delete CTA ${res.data.toString()}");
        if (res.data["status"]) {
          removeTopAction(MeetingAction.callToAction);
          _emitDeleteCTAOnCommand();
          _emitDeleteCTAOnPanalCommand(context);
          debugPrint("CTA Deleted");
        }
      });
    } on DioException catch (e) {
      debugPrint("CTA Deleted dio exception ${e.response}");
    } catch (e, st) {
      debugPrint("CTA Deleted  exception ${e.toString()}  $st");
    }
  }

  _emitDeleteCTAOnCommand() {
    final data = {
      "uid": "ALL",
      "data": {"command": "removecalltoAction", "value": false}
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("the delete CTA onCommand called ");
    });
  }

  _emitDeleteCTAOnPanalCommand(BuildContext context) {
    final userData = context.read<ParticipantsProvider>().myHubInfo;
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {"action": "removed"},
        "value": "callToAction",
        "ou": userData.id,
        "on": userData.email
      }
    };

    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("the delete CTA onPanalCommand called ");
    });
  }

  Future<void> getCTANoOfTapsCount(BuildContext context) async {
    final userData = context.read<ParticipantsProvider>().myHubInfo;
    try {
      final data = {
        "cta_id": userData.isHostOrActiveHost ? callToActionResponseModelData?.id.toString() : ctaResponseDataModel?.id.toString(),
        "participant_name": userData.email,
        "user_id": userData.id,
        "role": userData.role
      };
      if (speakerTappedCTA) return;
      callToActionRepo.ctaGetNoOfTaps(data).then((value) {
        if (value.data["status"]) {
          speakerTappedCTA = true;
          ctaTapCount = value.data["count"];
          notifyListeners();
          if (speakerTappedCTA) {
            _setGlobalGetCTANoOfTapsCount(context, value.data['count'] as int);
          }
        }
      });
    } on DioException catch (e) {
      debugPrint("the Dio exception getCTANoOfTapsCount ${e.response} ");
    } catch (e, st) {
      debugPrint("the Dio exception getCTANoOfTapsCount ${e.toString()} && $st");
    }
  }

  Future<void> _setGlobalGetCTANoOfTapsCount(BuildContext context, int clickedCount) async {
    String meetingId = context.read<MeetingRoomProvider>().meeting.id.toString();
    try {
      final data = {
        "key": "popupCalltoActions",
        "roomId": meetingId,
        "value": {"clickedCount": clickedCount}
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        var jsonEncode2 = jsonEncode({
          "uid": ctaResponseDataModel?.userId ?? callToActionResponseModelData?.userId,
          "data": {
            "command": "globalAccess",
            "type": "popupCalltoActions",
            "value": {"clickedCount": clickedCount}
          }
        });
        hubSocket.socket?.emitWithAck(
          'onCommand',
          jsonEncode2,
        );
      }
    } on DioException catch (e) {
      debugPrint("the Dio exception cta setGlobalGetCTANoOfTapsCount ${e.response} ");
    } catch (e, st) {
      debugPrint("the Dio exception cta setGlobalGetCTANoOfTapsCount ${e.toString()}  $st");
    }
  }

  void resetState() {
    ctaTapCount = 0;
    speakerTappedCTA = false;
  }
}
