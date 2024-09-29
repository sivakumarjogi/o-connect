import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:o_connect/ui/views/meeting/model/active_page.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/poll_intial_data_model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/poll/model/create_or_edit_poll_request_model.dart';
import 'package:o_connect/ui/views/poll/model/speakers_submitted_answers_model.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class PollListeners {
  final PollProvider _pollProvider;

  PollListeners(this._pollProvider);

  ///poll question from socket
  List<CreatePollRequestModelQuestion> _pollQuestions = [];
  String? _pollSurveyName;
  String? _createdDate;
  String? _updatedDate;
  String? _meetingId;
  String? _pollId;
  List<SpeakersSubmittedAnswersModel> _submittedAttendeesList = [];

  Map<String, dynamic> pollResults = {};

  List<CreatePollRequestModelQuestion> get pollQuestions => _pollQuestions;

  String? get pollSurveyName => _pollSurveyName;

  String? get createdDate => _createdDate;

  String? get updatedDate => _updatedDate;

  String? get meetingId => _meetingId;

  String? get pollId => _pollId;
  bool pollVotingEnded = false;
  bool resultsShared = false;

  ///set Initila data
  void setInitialPollData(PollInitialDataModel pollInitialDataModel, {bool fromInitState = true}) {
    try {
      print("Init poll called");
      _pollQuestions = pollInitialDataModel.questions!.map((e) => CreatePollRequestModelQuestion.fromJson(e.toJson())).toList();
      _pollId = pollInitialDataModel.id;
      _meetingId = pollInitialDataModel.meetingId;
      _createdDate = pollInitialDataModel.createdOn.toString();
      _updatedDate = pollInitialDataModel.updatedOn.toString();
      _pollSurveyName = pollInitialDataModel.surveyName;
      for (CreatePollRequestModelQuestion question in pollInitialDataModel.questions!) {
        _pollQuestions.add(question);
      }
 

      for (PollInitialDataModelSubmittedList element in pollInitialDataModel.submittedList!) {
        _submittedAttendeesList.addAll(element.data!.value!);
        _pollProvider.pollSpeakerSocketEmitEvents.answers.addAll(element.data!.value!);
      }
      print("the answers are the ${_pollProvider.pollSpeakerSocketEmitEvents.answers}");
      _pollProvider.buildPollResultsGraph(requiredInitialData: true, fromInitState: fromInitState);

      for (SpeakersSubmittedAnswersModel item in _submittedAttendeesList) {
        if (!pollResults.containsKey(item.questionId)) {
          pollResults[item.questionId.toString()] = {
            item.optionId: {"total": 1},
            "questionTotal": 1
          };
        } else {
          if (pollResults[item.questionId.toString()].containsKey(item.optionId.toString())) {
            var optionMap = pollResults[item.questionId.toString()][item.optionId.toString()];
            var total = optionMap["total"] as int;
            optionMap["total"] = total + 1;
          } else {
            pollResults[item.questionId.toString()][item.optionId.toString()] = {"total": 1};
          }
          pollResults[item.questionId.toString()]["questionTotal"] += 1;
        }
        // print("this && ${_pollProvider.context.read<MeetingRoomProvider>().hubSocketInput.uid} ${item.attendeeId}");
        // if (item.attendeeId != null && item.attendeeId.toString() == _pollProvider.context.read<MeetingRoomProvider>().hubSocketInput.uid) {
        //   print("this user submitted poll ");
        //   _pollProvider.pollSpeakerSocketEmitEvents.answers.clear();
        // }
      }
      _pollProvider.buildPollResultsGraph(fromInitState: fromInitState);

      resultsShared = pollInitialDataModel.shareResult ?? false;
      print("this user submitted poll $resultsShared && ${pollInitialDataModel.isPollEnded}");
      print("the final results map &&  $pollResults");
    } catch (e, st) {
      print("the stacktrace $st");
      print("the exception intial ${e.toString()}  && $st");
    }
  }

  void cleanMeetingPollData() {
    pollQuestions.clear();
    _pollProvider.pollSpeakerSocketEmitEvents.answers.clear();
    _submittedAttendeesList.clear();
  }

  ///Listeners
  void setUpPollListeners() {
    _pollProvider.hubSocket.socket?.on("onCommand", (data) {
      ///increase join speaker attendee count
      final parsed = jsonDecode(data);

      print(parsed);
    });

    _pollProvider.hubSocket.socket?.on("onPanalCommand", (data) {});

    _pollProvider.hubSocket.socket?.on("commandResponse", (res) async {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      final type = data['type'];

      if (command == "sendSurveySocket" && type == "survey") {
        ///pollQuestions will listen both for host and speaker
        _pollQuestions = (data["value"]["questions"] as List).map((e) => CreatePollRequestModelQuestion.fromJson(e)).toList();
        _pollSurveyName = data["value"]["survey_name"];
        _createdDate = data["value"]["created_on"].toString();
        _updatedDate = data["value"]["updated_on"].toString();
        _meetingId = data["value"]["meeting_id"];
        _pollId = data["value"]["_id"];
        for (CreatePollRequestModelQuestion item in _pollQuestions) {
          _pollProvider.pollSpeakerSocketEmitEvents.answers
              .add(SpeakersSubmittedAnswersModel(questionId: item.id, questionType: item.questionType, meetingId: _pollProvider.meeting.id, attendeeId: _pollProvider.myHubInfo.id, optionId: ""));
        }
        _pollProvider.update();
      }

      if (command == "SendSurveyOption" && type == "submit") {
        _submittedAttendeesList = (data["value"] as List).map((e) => SpeakersSubmittedAnswersModel.fromJson(e)).toList();
        _setDataToGraph(_submittedAttendeesList);
        _pollProvider.buildPollResultsGraph();
        _pollProvider.update();
        debugPrint("the final poll results Map is $pollResults");
      }

      if (command == "sendSurveySocket" && type == "close") {
        debugPrint("the poll was closed for speaker");
        pollQuestions.clear();
        pollResults = {};
        pollVotingEnded = false;
        resultsShared = false;
        _pollProvider.pollSpeakerSocketEmitEvents.answers.clear();
        _pollProvider.context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
      }

      if (command == "sendSurveySocket" && type == "endVoting") {
        pollVotingEnded = true;
        _pollProvider.pollSpeakerSocketEmitEvents.answers.clear();
        _pollProvider.update();
      }

      if (command == "sendSurveySocket" && type == "survey" && data["value"]["shareResult"]) {
        resultsShared = true;
        PollInitialDataModel? pollFinalData = await _pollProvider.getPollDataWhenCompleted();

        if (pollFinalData != null) {
          setInitialPollData(pollFinalData, fromInitState: true);
        }

        _pollProvider.update();
      }
    });

    _pollProvider.hubSocket.socket?.on("panalResponse", (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
    });
  }

  void _setDataToGraph(List<SpeakersSubmittedAnswersModel> submittedAnswersList) {
    for (SpeakersSubmittedAnswersModel item in submittedAnswersList) {
      if (!pollResults.containsKey(item.questionId)) {
        pollResults[item.questionId.toString()] = {
          item.optionId: {"total": 1},
          "questionTotal": 1
        };
      } else {
        if (pollResults[item.questionId].containsKey(item.optionId)) {
          Map<String, dynamic> optionMap = pollResults[item.questionId][item.optionId];
          var total = optionMap["total"] as int;
          optionMap["total"] = total + 1;
        } else {
          pollResults[item.questionId][item.optionId] = {"total": 1};
        }
        pollResults[item.questionId]["questionTotal"] += 1;
      }
    }
  }
}
