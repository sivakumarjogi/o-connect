import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:provider/provider.dart';

import '../../../utils/constant_strings.dart';
import '../../../utils/custom_toast_helper/custom_toast.dart';
import 'meeting_room_provider.dart';

class BreakTimeHelper {
  final MeetingRoomProvider _meetingRoomProvider;

  BreakTimeHelper(this._meetingRoomProvider);

  int _breakCount = 1;

  int get breakTimeCout => _breakCount;
  bool isBreakTimeOn = false;

  void incrementBreakTime() {
    if (_breakCount < 60) {
      _breakCount++;
      _meetingRoomProvider.update();
    }
  }

  void decrementBreakTime() {
    if (_breakCount > 1) {
      _breakCount--;
      _meetingRoomProvider.update();
    }
  }

  _emitBreakTimeOnCommand(int time) {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "BreakTime",
        "value": {"flag": true, "time": time}
      }
    };

    //{"from":"4456047","roomId":"657fd0800c67b700081e2230","data":{"command":"BreakTime","value":{"closeEvent":true}}}

    _meetingRoomProvider.hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("the delete CTA onCommand called ");
    });
  }

  resetBreaktimeCount() {
    _breakCount = 1;
    _meetingRoomProvider.update();
  }

  void setIsBreakTimeOn(bool isOn) {
    isBreakTimeOn = isOn;
  }

  Future<void> setBreakTime(BuildContext context, {required String setTimeStatus}) async {
    if (setTimeStatus == ConstantsStrings.setTime) {
      isBreakTimeOn = true;
      final response = await _setBreakTime({
        "roomId": _meetingRoomProvider.meeting.id,
        "key": "BreakTime",
        "value": {"time": breakTimeCout, "FirstModal": true, "secondModaltrue": true, "createdOn": DateTime.now().toString()}
      });
      print("---------$response");

      if (response != null) {
        HubSocket.instance.socket?.emitWithAck(
            'onCommand',
            jsonEncode({
              "uid": "ALL",
              "data": {
                "command": "BreakTime",
                "value": {"flag": true, "time": breakTimeCout}
              }
            }));

      } else {
        CustomToast.showErrorToast(msg: "Something went wrong");
      }
    } else if (setTimeStatus == ConstantsStrings.stopTime) {
      isBreakTimeOn = false;
      // {"key":"remove","roomId":"657fd0800c67b700081e2230","value":["BreakTime"]}
      final response = await _setBreakTime({
        "key": "remove",
        "roomId": _meetingRoomProvider.meeting.id,
        "value": ["BreakTime"]
      });
      print("---------$response");
      if (response != null) {
        HubSocket.instance.socket?.emitWithAck(
            'onCommand',
            jsonEncode({
              "uid": "ALL",
              "data": {
                "command": "BreakTime",
                "value": {"closeEvent": true}
              }
            }));
      } else {
        CustomToast.showErrorToast(msg: "Something went wrong");
      }
    }
  }

  Future<Response?> _setBreakTime(Map<String, dynamic> body) async {
    // context.showLoading();
    final breaktimeResponse = await _meetingRoomProvider.globalStatusRepo.updateGlobalAccessStatus(body);
    if (breaktimeResponse.statusCode == 200) {
      return breaktimeResponse;
    } else {
      return null;
    }
  }
}
