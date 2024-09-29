import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';

class HandRaiseProvider extends BaseProvider with MeetingUtilsMixin {
  bool handRaise = true;
  List handRiseUserName = [];

  setHandRaiseListeners() {
    hubSocket.socket?.on("panalResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;

      final command = data['data']['command'];
      if (command == 'HandRaise') {
        final raised = data['data']['status'];

        if (data['data']['lowerHand'] == 'All') {
          if (data['from'] != myHubInfo.id.toString())
            CustomToast.showSuccessToast(msg: "Host lowered your hand");
          context.read<PeersProvider>().lowerHandForAll();
          context.read<ParticipantsProvider>().lowerHandForAll();
          handRaise = true; // true because initial value is true
        } else {
          if (!raised) {
            handRiseUserName
                .removeWhere((element) => element == data['data']['name']);
          } else {
            handRiseUserName.add(data['data']['name']);
          }
          final userID = data['data']['id'];
          if (userID.toString() == myHubInfo.id.toString()) {
            if (handRaise) {
              CustomToast.showSuccessToast(msg: "Hand Raised");
            } else {
              CustomToast.showSuccessToast(
                  msg: data['data']['isHost'] == true
                      ? "Host lowered your hand"
                      : "Hand Lowered");
            }
          }

          final peerID = context
              .read<ParticipantsProvider>()
              .speakers
              .where((element) => element.id.toString() == userID.toString())
              .first
              .peerId
              .toString();
          context.read<PeersProvider>().toggleRaiseHand(peerID, raised);
          context
              .read<ParticipantsProvider>()
              .toggleHandleRaise(raised, userID);
          handRaise = !raised;
        }

        notifyListeners();
      }
    });
  }

  void lowerHand(String peerId) {
    final matched = context
        .read<ParticipantsProvider>()
        .speakers
        .where((p) => p.peerId == peerId);
    if (matched.isEmpty) return;

    final data = {
      "uid": "ALL",
      "data": {
        "command": "HandRaise",
        "id": matched.first.id,
        "status": false,
        "roleType": myHubInfo.role,
        "isHost": myHubInfo.isHost
      }
    };
    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("hand Raise onPanalCommand called ");
    });
  }

  Future<void> handRaiseGlobalSetStatus() async {
    try {
      final data = {
        "key": "handRaiseList",
        "roomId": meeting.id,
        "value": handRaise
            ? [
                {"id": myHubInfo.id, "name": myHubInfo.displayName}
              ]
            : []
      };
      final res = await globalStatusRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        _emitHandRaiseOnPanalCommand();
      }

      // if (res.data["status"]) {}
    } on DioException catch (e) {
      debugPrint("dio exception hand raise ${e.response}");
    } catch (e, st) {
      debugPrint("dio exception hand raise ${e.toString()} && $st");
    }
  }

  void lowerHandForIndividual({required int id, required String name}) async {
    final res = await globalStatusRepo.updateGlobalAccessStatus({
      "roomId": meeting.id,
      "key": "handRaiseList",
      "value": [
        {
          "id": id,
          "name": name,
        }
      ]
    });
    if (res.statusCode == 200) {
      hubSocket.socket?.emitWithAck(
        'onPanalCommand',
        jsonEncode(
          {
            "uid": "ALL",
            "data": {
              "command": "HandRaise",
              "id": id,
              "isHost": myHubInfo.isHost,
              "status": false,
              // "user_id": myHubInfo.id,
              "roleType": myHubInfo.role
            }
          },
        ),
      );
    }
  }

  Future<void> lowerHandForAll() async {
    final res = await globalStatusRepo.updateGlobalAccessStatus({
      "roomId": meeting.id,
      "key": "remove",
      "value": ["handRaiseList"]
    });
    if (res.statusCode == 200) {
      hubSocket.socket?.emitWithAck(
        'onPanalCommand',
        jsonEncode(
          {
            "uid": "ALL",
            "data": {
              "command": "HandRaise",
              "lowerHand": "All",
              "isHost": myHubInfo.isHost,
              "user_id": myHubInfo.id,
              "roleType": myHubInfo.role
            }
          },
        ),
      );
    }
  }

  _emitHandRaiseOnPanalCommand() {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "HandRaise",
        "id": myHubInfo.id,
        "name": myHubInfo.displayName,
        "status": handRaise,
        "actionByUser": true,
        "roleType": myHubInfo.role
      }
    };
    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("hand Raise onPanalCommand called ");
    });
  }
}
