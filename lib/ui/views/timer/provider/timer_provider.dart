import 'dart:async';
import 'dart:convert';
import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/chat_screen/chat_repo/chat_repository.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_actions.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/timer.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/timer_toggle_buttons.dart';
import 'package:provider/provider.dart';

class TimerProvider extends BaseProvider with MeetingUtilsMixin {
  // HubSocket hubSocket = HubSocket.instance;
  late TextEditingController searchController;

  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  ChatApiRepository chatApiRepository = ChatApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.globalAccessSetUrl);

  String formatTotalTimeInSeconds = "02:00";
  AddTime? selectedTime;
  int totalTimeInSeconds = 120;
  List<HubUserData> participants = [];
  List<HubUserData> searchedParticipants = [];
  HubUserData? selectedParticipant;

  // bool showTimeView = false;
  String displayTimeValue = "02:00";
  Timer? _timer;
  String? selectedUser;

  Timer? get timer => _timer;
  String? _timerUserId;

  String? get timerUserId => _timerUserId;

  int minutes = 02;
  int seconds = 00;
  bool timerCountDownStart = false;

  late AnimationController animationController;
  late Animation<double> animation;

  void setInitialTimer(InitialTimer timer) {
    formatTotalTimeInSeconds = timer.time;
    showTimerAtDashBoard();
  }

  void clearTimeData() {
    formatTotalTimeInSeconds = "02:00";
    totalTimeInSeconds = 120;
    minutes = 02;
    seconds = 00;

    selectedParticipant = null;
  }

 void initAnimation(TickerProvider mixin) {
    animationController = AnimationController(
      vsync: mixin,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void startAnimation({bool stratAnimation = false}) {
    animationController.repeat(reverse: stratAnimation);
  }

  initParticipants(BuildContext context) {
    List<HubUserData> participantsList = context.read<ParticipantsProvider>().speakers;
    participants = participantsList.where((element) => !element.isHost).toList();
    searchedParticipants = [...participants];
  }

  updateTimeView(String searchText) {
    searchedParticipants.clear();
    selectedParticipant = null;

    if (searchText.isEmpty) {
      searchedParticipants = [...participants];
      notifyListeners();
      return;
    }
    searchedParticipants = participants.where((e) => e.displayName!.toString().toLowerCase().contains(searchText.toLowerCase())).toList();

    notifyListeners();
  }

  void addParticipants(int index) {
    selectedParticipant = searchedParticipants[index];
    // searchController.text = searchedParticipants[index].displayName.toString();
    notifyListeners();
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
    minutes = int.parse(minutesFormatted);
    seconds = int.parse(secondsFormatted);
    formatTotalTimeInSeconds = '$minutesFormatted:$secondsFormatted';

    notifyListeners();
  }

  void increaseDecreaseTime({required String type}) {
    /*  if (type == "increase") {
      totalTimeInSeconds += 60;
    } else if (type == "decrease") {
      if (totalTimeInSeconds > 0) {
        totalTimeInSeconds -= 60;
      }
    } */
    if (type == "increase") {
      if (minutes < 59 && seconds < 59) {
        seconds++;
      } else if (minutes < 59 && seconds == 59) {
        minutes++;
        seconds = 00;
      }
    } else if (type == "decrease") {
      if (minutes > 0 || seconds > 0) {
        if (seconds > 0) {
          seconds--;
        } else {
          minutes--;
          seconds = 59;
        }
      }
    }
    formatTotalTimeInSeconds = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  void showTimerAtDashBoard() {
    List<String> timeParts = formatTotalTimeInSeconds.toString().split(':');
    int minute = int.parse(timeParts[0]);
    int second = int.parse(timeParts[1]);
    final player = AudioPlayer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second > 0) {
        second--;

        if (minute == 0 && second <= 10) {
          startAnimation(stratAnimation: true);

          // player.setAsset("assets/audio/timer_beap.mp3");
          // player.play();
          timerCountDownStart = true;
        }
      } else {
        if (minute > 0) {
          minute--;
          second = 59;
        } else {
          timer.cancel();
          if (myHubInfo.isHost) {
            deleteTimerGlobalSet(context);
          }
          startAnimation(stratAnimation: false);
          timerCountDownStart = false;
        }
      }

      String minutesFormatted = minute.toString().padLeft(2, '0');
      String secondsFormatted = second.toString().padLeft(2, '0');

      displayTimeValue = '$minutesFormatted:$secondsFormatted';

      if (minute == 0 && second == 0) {
        timer.cancel();
        context.read<WebinarProvider>().activeFuture = WebinarTopFutures.initialAction;
        timerCountDownStart = false;
        if (myHubInfo.isHost || myHubInfo.isCohost || myHubInfo.isActiveHost) {
          deleteTimerGlobalSet(context);
        }
        print("the is host ${myHubInfo.isHost}");
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void setTimerListener() {
    hubSocket.socket?.on("panalResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final command = data['data']['command'];

      if (value == "timer" && command == "AccessRestriction") {
        final action = data["data"]["feature"]["action"];

        if (action == "removed") {
          removeTopAction(MeetingAction.timer);
          if (_timerUserId != myHubInfo.id.toString() && !myHubInfo.isHostOrActiveHost) {
            navigationKey.currentContext!.read<WebinarProvider>().updateAllowedActions(myRole, from: "timer");
          }
          selectedUser = null;
        }

        if (action == "opened") {
          if (_timerUserId != myHubInfo.id.toString() && !myHubInfo.isHostOrActiveHost) {
            addTopActionToDashboard(MeetingAction.timer);
            navigationKey.currentContext!.read<WebinarProvider>().updateAllowedActions(myRole, allowAudio: false, allowVideo: false, from: "timer");
          }
        }
      }
    });

    hubSocket.socket?.on("onCommand", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      /*   final value = data['data']['value'];
      final command = data['data']['command']; */
    });

    hubSocket.socket?.on("commandResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final command = data['data']['command'];
      debugPrint("the timer values $data &&  $value");
      if (command == "timer") {
        debugPrint("the timer values $data && $value && ${value["user"]}");
        formatTotalTimeInSeconds = value["time"];
        _timerUserId = value['userId'].toString();
        var timerIsForMe = myHubInfo.id.toString() == value["userId"].toString();
        debugPrint("the timer values $value && ${value["user"]}");
        selectedUser = value["user"];
        addTopActionToDashboard(MeetingAction.timer);
        navigationKey.currentContext!.read<WebinarProvider>().updateAllowedActions(myRole, allowAudio: timerIsForMe, allowVideo: timerIsForMe, from: "timer");
        showTimerAtDashBoard();
      }

      if (command == "closeTimer") {
        if (_timer != null) {
          _timer!.cancel();
        }
        selectedUser = "";
        _timerUserId = null;
        navigationKey.currentContext!.read<WebinarProvider>().updateAllowedActions(myRole, from: "timer");
        removeTopAction(MeetingAction.timer);
      }
    });
  }

  Future<void> setTimerGlobalSet(BuildContext context) async {
    try {
      final data = {"action": "open", "feature": "timer", "meetingId": meeting.id, "role": 1, "type": "others", "userId": userData.id};

      chatApiRepository.questionAndAnsSet(data).then((res) {
        if (res["status"]) {
          _setTimerGlobalSetStatus(context);
        }
      });
    } on DioException catch (e) {
      debugPrint("the Dio exception timer  ${e.response}");
    } catch (e, st) {
      debugPrint("the  exception timer ${e.toString()}  $st");
    }
  }

  Future<void> _setTimerGlobalSetStatus(BuildContext context) async {
    try {
      final data = {
        "roomId": meeting.id,
        "key": "timer",
        "value": {
          "userId": selectedParticipant?.id,
          "user": selectedParticipant?.displayName,
          "time": formatTotalTimeInSeconds,
          "timeMin": formatTotalTimeInSeconds.split(":").first,
          "timeSec": formatTotalTimeInSeconds.split(":").last,
          "remainingTimeLeft": _getAddedTime(),
          "oui": myHubInfo.id
        }
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        _emitSetTimerOnCommandEvent();
        _emitSetTimerOnPanalCommandEvent();
        selectedUser = selectedParticipant?.displayName.toString();
        addTopActionToDashboard(MeetingAction.timer);
        searchedParticipants.clear();
        selectedParticipant = null;
        // showTimeView = false;
        showTimerAtDashBoard();
      }
    } on DioException catch (e) {
      debugPrint("the Dio exception timer  ${e.response}");
    } catch (e, st) {
      debugPrint("the  exception timer ${e.toString()}  $st");
    }
  }

  String _getAddedTime() {
    DateTime now = DateTime.now()
        .add(Duration(minutes: int.parse(formatTotalTimeInSeconds.split(":").first), seconds: int.parse(formatTotalTimeInSeconds.split(":").last)))
        .toUtc(); // Get the current time in UTC
    String addedTime = now.toIso8601String();
    return addedTime;
  }

  _emitSetTimerOnCommandEvent() {
    final data = {
      "uid": "${searchedParticipants.first.id}",
      "data": {
        "command": "timer",
        "value": {
          "userId": selectedParticipant?.id,
          "user": myHubInfo.displayName,
          "time": formatTotalTimeInSeconds,
          "timeMin": formatTotalTimeInSeconds.split(":").first,
          "timeSec": formatTotalTimeInSeconds.split(":").last,
          "oui": myHubInfo.id
        }
      }
    };
    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("Timer onCommand event called ");
    });
  }

  _emitSetTimerOnPanalCommandEvent() {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {"message": "opened", "action": "opened"},
        "value": "timer",
        "ou": myHubInfo.id,
        "on": myHubInfo.displayName
      }
    };

    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("Timer onPanalCommand event called ");
    });
  }

  Future<void> deleteTimerGlobalSet(BuildContext context) async {
    try {
      final data = {"action": "close", "feature": "timer", "meetingId": meeting.id, "role": 1, "type": "others", "userId": myHubInfo.id};

      chatApiRepository.questionAndAnsSet(data).then((res) {
        if (res["status"]) {
          _deleteTimerGlobalSetStatus(context);
        }
      });
    } on DioException catch (e) {
      debugPrint("the Dio exception  delete timer  ${e.response}");
    } catch (e, st) {
      debugPrint("the  exception delte  timer ${e.toString()}  $st");
    }
  }

  Future<void> _deleteTimerGlobalSetStatus(BuildContext context) async {
    try {
      final data = {
        "roomId": meeting.id,
        "key": "remove",
        "value": ["timer"]
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        _emitDeleteTimerOnCommand();
        _emitDeleteTimerOnPanalCommand();
        removeTopAction(MeetingAction.timer);
      }
    } on DioException catch (e) {
      debugPrint("the Dio exception  delete timer  ${e.response}");
    } catch (e, st) {
      debugPrint("the  exception delete  timer ${e.toString()}  $st");
    }
  }

  void _emitDeleteTimerOnCommand() {
    final data = {
      "uid": selectedUser,
      "data": {
        "command": "closeTimer",
        "value": {"userId": selectedUser}
      }
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("delte onCommand event called");
    });
  }

  _emitDeleteTimerOnPanalCommand() {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {
          "action": "removed",
          "user": {"feature": "timer", "userId": "${myHubInfo.id}", "role": "Host", "isAccessing": true, "userName": myHubInfo.displayName}
        },
        "value": "timer",
        "ou": myHubInfo.id,
        "on": myHubInfo.email,
      }
    };
    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("delete onPanalCommand event called");
    });
  }
}
