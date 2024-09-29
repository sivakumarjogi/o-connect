import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_provider_mixin.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';

class MeetingTimerProvider extends ChangeNotifier with MeetingUtilsMixin {
  Timer? _timer;
  int _timerSeconds = 0;
  String timerText = '00:00:00';

  /// 30 mins.
  int extendMeetingThresholdInSec = 1800;

  /// 120 mins. We will extend the meeting by 120 minutes
  int extendTimeInMins = 120;

  bool _extendInProgress = false;

  void startTimer(DateTime eventStartTime) {
    if (_timer != null && _timer?.isActive == true) stopTimer();
    _timerSeconds = DateTime.now().difference(eventStartTime).inSeconds;
    _updateTimerText();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerSeconds++;
      _updateTimerText();

      final remaining = meeting.endDate!.toLocal().difference(DateTime.now()).inSeconds;

      if (remaining <= 0) {
        final provider = context.read<ParticipantsProvider>();
        final myHubInfo = provider.myHubInfo;
        if ((provider.isHostPresent && myHubInfo.isHost) || (!provider.isHostPresent && myHubInfo.isActiveHost)) {
          _timer?.cancel();

          context.read<MeetingRoomProvider>().leaveMeeting().then((_) {
            final isPipEnabled = context.read<AppGlobalStateProvider>().isPIPEnabled;
            if (!isPipEnabled) Navigator.of(context).pop();
          });
        }
      } else if (remaining < extendMeetingThresholdInSec && myHubInfo.isHostOrActiveHost) {
        if (['Paid', 'Admin'].contains(meeting.userPlan) && !_extendInProgress) {
          handleExtendMeeting();
        }
      }
    });
  }

  void _updateTimerText() {
    final duration = Duration(seconds: _timerSeconds);
    final seconds = duration.inSeconds.remainder(60).pad0();
    final minutes = duration.inMinutes.remainder(60).pad0();
    final hours = duration.inHours.remainder(24).pad0();
    timerText = '$hours:$minutes:$seconds';
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetState() {
    stopTimer();
    _timerSeconds = 0;
    _extendInProgress = false;
    notifyListeners();
  }

  void handleExtendMeeting() {
    _extendInProgress = true;
    notifyListeners();

    final reqBody = {
      'auto_generated_id': meeting.autoGeneratedId,
      'duration': extendTimeInMins,
      'meeting_id': meeting.id,
      'user_id': myHubInfo.id,
    };

    meetingRepo.extendMeetingTime(reqBody).then((res) {
      if (res.statusCode == 200) {
        context.read<MeetingRoomProvider>().meeting = context.read<MeetingRoomProvider>().meeting.copyWith(
              endDate: DateTime.parse(res.data['data']['end_date']),
            );
        context.read<MeetingRoomProvider>().update();

        // notify active hosts
        final activeHosts = context.read<ParticipantsProvider>().activeHosts;
        for (var ah in activeHosts) {
          hubSocket.socket?.emitWithAck(
            'onPanalCommand',
            jsonEncode({
              'uid': ah.id,
              'data': {
                'command': 'ExtendedTime',
                'status': true,
              }
            }),
          );
        }

        // Set global status
        final body = {'key': 'TimeExtended', 'roomId': meeting.id, 'value': true};
        globalStatusRepo.updateGlobalAccessStatus(body).catchError((e) {
          log('error while updating extend time: $e');
        });

        CustomToast.showSuccessToast(msg: 'Meeting extended by $extendTimeInMins mins');
      }
    }).catchError((e) {
      _extendInProgress = false;
      notifyListeners();
    });
  }
}

extension IntX on int {
  String pad0() {
    return toString().length >= 2 ? toString() : '0$this';
  }
}
