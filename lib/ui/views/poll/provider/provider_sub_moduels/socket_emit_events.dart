import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:provider/provider.dart';
import '../../model/speakers_submitted_answers_model.dart';

class PollSpeakerSocketEmitEvents {
  final PollProvider _pollProvider;

  PollSpeakerSocketEmitEvents(this._pollProvider);

  List<SpeakersSubmittedAnswersModel> answers = [];
  bool submitAnswersLoading = false;

  void updateAnswers(int questionIndex, String value) {
    answers[questionIndex] = answers[questionIndex].copyWith(optionId: value);
    _pollProvider.update();
  }

  Future<void> speakerSubmitAnswersGlobalSetStatus() async {
    submitAnswersLoading = true;
    _pollProvider.update();
    try {
      final data = {
        "roomId": _pollProvider.meeting.id,
        "key": "surveyMIddle",
        "value": {
          "ou": _pollProvider.context.read<ParticipantsProvider>().hostInfo!.id,
          "page": "survey",
          "voting": true,
          "value": {
            "_id": _pollProvider.pollListeners.pollId,
            "from_user_id": _pollProvider.context.read<ParticipantsProvider>().hostInfo!.id,
            "meeting_id": _pollProvider.pollListeners.meetingId,
            "questions": _pollProvider.pollListeners.pollQuestions.map((e) => e.toJson()).toList(),
            "survey_name": _pollProvider.pollListeners.pollSurveyName,
            "created_on": _pollProvider.pollListeners.createdDate,
            "updated_on": _pollProvider.pollListeners.updatedDate,
            "shareResult": false,
            "voting": true,
            "isSurveyStarted": true,
            "userId": _pollProvider.context.read<ParticipantsProvider>().hostInfo!.id,
            "submittedList": [
              {
                "uid": _pollProvider.context.read<ParticipantsProvider>().hostInfo!.id,
                "data": {
                  "command": "SendSurveyOption",
                  "type": "submit",
                  "value": answers.where((e) {
                    return e.optionId != null && e.optionId != "";
                  }).toList(),
                  "uid": _pollProvider.myHubInfo.id
                }
              }
            ]
          }
        }
      };

      final res = await _pollProvider.meetingRepo.updateGlobalAccessStatus(data);
      if (res.data["status"]) {
        _emitOnCommandSubmitAnswers();
      }
    } on DioException catch (e) {
      debugPrint("speakerSubmitAnswersGlobalSetStatus dio exception ${e.error}");
    } catch (e, st) {
      debugPrint("speakerSubmitAnswersGlobalSetStatus dio exception ${e.toString()} && $st");
    }
    submitAnswersLoading = false;
    _pollProvider.update();
  }

  void _emitOnCommandSubmitAnswers() {
    final data = {
      "uid": _pollProvider.context.read<ParticipantsProvider>().hostInfo!.id,
      "data": {
        "command": "SendSurveyOption",
        "type": "submit",
        "value": answers.where((e) {
          return e.optionId != null && e.optionId != "";
        }).toList(),
        "uid": _pollProvider.myHubInfo.id
      }
    };
    _pollProvider.hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("submitAnswers onCommand called");
    });
    answers.clear();
    _pollProvider.update();
  }
}
