import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/chat_screen/chat_repo/chat_repository.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/active_page.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/poll_intial_data_model.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/poll/data/poll_repository.dart';
import 'package:o_connect/ui/views/poll/model/create_or_edit_poll_request_model.dart';
import 'package:o_connect/ui/views/poll/model/create_poll_response_model.dart';
import 'package:o_connect/ui/views/poll/model/fetch_poll_question_files.dart';
import 'package:o_connect/ui/views/poll/model/radio_button_models.dart';
import 'package:o_connect/ui/views/poll/provider/provider_sub_moduels/socket_emit_events.dart';
import 'package:o_connect/ui/views/poll/widgets/build_answer_feilds.dart';
import 'package:o_connect/ui/views/poll/widgets/multiple_questions_Widget.dart';
import 'package:o_connect/ui/views/poll/widgets/poll_results_bar_graph.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/base_urls.dart';
import 'provider_sub_moduels/poll_listeners.dart';

class PollProvider extends BaseProvider with MeetingUtilsMixin {
  late PollListeners _pollListeners;
  late PollSpeakerSocketEmitEvents _pollSpeakerSocketEmitEvents;

  PollListeners get pollListeners => _pollListeners;

  PollSpeakerSocketEmitEvents get pollSpeakerSocketEmitEvents => _pollSpeakerSocketEmitEvents;

  PollProvider() {
    _pollListeners = PollListeners(this);
    _pollSpeakerSocketEmitEvents = PollSpeakerSocketEmitEvents(this);
  }

  final PollRepository pollRepo = PollRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.pollBaseUrl,
  );

  final ChatApiRepository chatRepo = ChatApiRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessSetUrl,
  );

  @override
  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  ///poll initial data
  FetchPollQuestionFile? pollPreviousQuestionFiles;
  List<FetchPollQuestionFileData> searchedRecentPollsList = [];

  ///controllers List
  late TextEditingController surveyController;
  int surveyTime = 0;
  List<List<TextEditingController>> answerControllersList = [];
  List<TextEditingController> questionControllers = [];

  ///answer and question ids
  List<List<String>> answerIdsList = [];
  List<String> questionIdsList = [];
  String surveyId = "";

  ///widget List
  List<Widget> questionWidgets = [];
  List<List<Widget>> answerWidgetsList = [];

  ///radio buttons list
  List<RadioButtonValues> radioButtonValue = [];
  List<String> radioButtonGroupValues = [];

  ///create api response
  CreatePollResponseModel? pollData;

  ///count no of attendees submit answers

  bool createPollLoading = false;

  ///poll graphs data

  List<ChartSeries<PollResultsChartData, String>> pollresultsSeriesData = [];

  void pollTime(int time) {
    surveyTime = time;
    notifyListeners();
  }

  void clearData() {
    answerControllersList.clear();
    questionControllers.clear();
    surveyController.clear();
    surveyId = "";
    questionIdsList.clear();
    answerIdsList.clear();
    questionWidgets = [];
    answerWidgetsList = [];
    radioButtonValue = [];
    radioButtonGroupValues = [];
  }

  void searchRecentPolls(String searchText) {
    searchedRecentPollsList.clear();
    if (searchText.isEmpty) {
      searchedRecentPollsList = [...pollPreviousQuestionFiles?.data ?? []];
      notifyListeners();
      return;
    }
    searchedRecentPollsList = pollPreviousQuestionFiles!.data!.where((e) => e.surveyName!.toString().toLowerCase().contains(searchText)).toList();
    notifyListeners();
  }

  void addQuestionField() {
    surveyController = TextEditingController();
    TextEditingController newController = TextEditingController();
    questionControllers.add(newController);

    List<TextEditingController> answerControllers = [
      TextEditingController(),
      TextEditingController(),
    ];
    answerControllersList.add(answerControllers);

    List<Widget> answerWidgets = [
      BuildAnswerFields(questionIndex: questionControllers.length - 1, answerIndex: 0),
      BuildAnswerFields(questionIndex: questionControllers.length - 1, answerIndex: 1),
    ];
    answerWidgetsList.add(answerWidgets);

    questionWidgets.add(QuestionsField(questionIndex: questionControllers.length - 1));
    radioButtonGroupValues = ["multipleChoice0"];
    radioButtonValue = [RadioButtonValues(multiPleChoice: "multipleChoice0", open: "open0")];
  }

  void disposeControllers() {
    surveyController.dispose();
    for (var controller in questionControllers) {
      controller.dispose();
    }
    for (var answerControllers in answerControllersList) {
      for (var controller in answerControllers) {
        controller.dispose();
      }
    }
  }

  void addAnswerField(index) {
    answerControllersList[index].add(TextEditingController());
    answerWidgetsList[index].add(
      BuildAnswerFields(
        questionIndex: index,
        answerIndex: answerControllersList[index].length - 1,
      ),
    );
    notifyListeners();
  }

  void removeAnswersFields({
    required int answerIndex,
    required int questionIndex,
  }) {
    answerControllersList[questionIndex].removeAt(answerIndex);
    answerWidgetsList[questionIndex].removeAt(answerIndex);
    if (questionIdsList.length > questionIndex) {
      if (answerIdsList[questionIndex].length >= answerControllersList.length) {
        answerIdsList[questionIndex].removeAt(answerIndex);
      }
    }
    notifyListeners();
  }

  void addQuestions(int questionIndex, {FetchPollQuestionFileQuestion? questions, bool fromInitState = false}) {
    TextEditingController newController = TextEditingController();
    if (questionIdsList.length >= questionControllers.length && questions != null) {
      newController.text = questions.question.toString();
      questionIdsList.add(questions.id.toString());
    }
    questionControllers.add(newController);
    List<TextEditingController> answerControllers = [];
    List<Widget> answerWidgets = [];
    List<String> answersIds = [];
    if (questions != null) {
      List<TextEditingController> optionsControllers = [];
      List<Widget> optionsWidget = [];
      List<String> optionIds = [];

      for (var optionIndex = 0; optionIndex < questions.options!.length; optionIndex++) {
        optionsControllers.add(TextEditingController(text: questions.options![optionIndex].ansOption));
        optionIds.add(questions.options![optionIndex].id ?? "");
        optionsWidget.add(BuildAnswerFields(questionIndex: questionIndex, answerIndex: optionIndex));
      }
      answerControllers.addAll(optionsControllers);
      answerWidgets.addAll(optionsWidget);
      answersIds.addAll(optionIds);
    } else {
      answerControllers = [
        TextEditingController(),
        TextEditingController(),
      ];

      answerWidgets = [
        BuildAnswerFields(questionIndex: questionControllers.length - 1, answerIndex: 0),
        BuildAnswerFields(questionIndex: questionControllers.length - 1, answerIndex: 1),
      ];
    }
    answerControllersList.add(answerControllers);
    answerIdsList.add(answersIds);
    answerWidgetsList.add(answerWidgets);
    questionWidgets.add(QuestionsField(questionIndex: questionControllers.length - 1));

    if (questions != null) {
      radioButtonGroupValues.add(questions.questionType == "single" ? "multipleChoice$questionIndex" : "open$questionIndex");
    } else {
      radioButtonGroupValues.add("multipleChoice$questionIndex");
    }
    radioButtonValue.add(RadioButtonValues(multiPleChoice: "multipleChoice$questionIndex", open: "open$questionIndex"));
    if (!fromInitState) {
      notifyListeners();
    }
  }

  void removeQuestion(int index) {
    questionControllers.removeAt(index);
    answerControllersList.removeAt(index);
    answerWidgetsList.removeAt(index);
    questionWidgets.removeAt(index);
    radioButtonValue.removeAt(index);
    radioButtonGroupValues.removeAt(index);

    if (questionIdsList.length > index && pollPreviousQuestionFiles?.data?[index].questions != null) {
      questionIdsList.removeAt(index);
    }
    notifyListeners();
  }

  void toggleRadioButton(int questionIndex, String buttonValue) {
    radioButtonGroupValues[questionIndex] = buttonValue;
    if (buttonValue.contains("open")) {
      for (var controller in answerControllersList[questionIndex]) {
        controller.clear();
      }
    }
    notifyListeners();
  }

  void setInitialValuesForEditPoll(int index) {
    surveyController = TextEditingController(text: pollPreviousQuestionFiles?.data?[index].surveyName ?? "");
    surveyId = pollPreviousQuestionFiles?.data?[index].id ?? "";
    for (var questionIndex = 0; questionIndex < pollPreviousQuestionFiles!.data![index].questions!.length; questionIndex++) {
      addQuestions(questionIndex, questions: pollPreviousQuestionFiles!.data![index].questions![questionIndex], fromInitState: true);
    }
  }

  Future<void> fetchAllPreviousPollQuestionFiles() async {
    createPollLoading = true;
    try {
      final response = await pollRepo.fetchAllPreviousPollQuestionFiles(myHubInfo.id.toString());
      pollPreviousQuestionFiles = response;
      searchedRecentPollsList = [...pollPreviousQuestionFiles?.data ?? []];
    } on DioException catch (e) {
      debugPrint("the dio exception fetching poll questions ${e.response}");
    } catch (e, st) {
      debugPrint("the dio exception fetching poll questions ${e.toString()} $st");
    }
    print("it reached ");
    createPollLoading = false;
    notifyListeners();
  }

  Future<void> createOrEditPoll({bool isEdit = false}) async {
    createPollLoading = true;
    notifyListeners();
    try {
      List<CreatePollRequestModelQuestion> questionsList = [];
      for (int i = 0; i < questionControllers.length; i++) {
        debugPrint('Question ${i + 1}: ${questionControllers[i].text}');
        List<CreatePollRequestModelOption> optionsList = [];
        String questionId = "";
        if (questionIdsList.length > i) {
          questionId = questionIdsList[i];
        }
        print("the question  id is the $questionId");
        for (int j = 0; j < answerControllersList[i].length; j++) {
          debugPrint('Answer ${j + 1}: ${answerControllersList[i][j].text}');
          String answerId = "";

          if (isEdit == true && answerIdsList[i].length > j) {
            /* print("the question index $i and answer index is the $j   ${answerIdsList.length} ${answerIdsList[i].length > answerControllersList[i].length}");*/
            answerId = answerIdsList[i][j];
          }
          if (answerControllersList[i][j].text.isNotEmpty) {
            optionsList.add(CreatePollRequestModelOption(ansOption: answerControllersList[i][j].text, id: answerId));
          }
        }
        if (radioButtonGroupValues[i].contains("multipleChoice")) {
          questionsList.add(CreatePollRequestModelQuestion(options: optionsList, question: questionControllers[i].text, questionType: "single", id: questionId));
        } else if (radioButtonGroupValues[i].contains("open") && questionControllers[i].text.isNotEmpty) {
          questionsList.add(CreatePollRequestModelQuestion(options: [], question: questionControllers[i].text, questionType: "open"));
        }
      }

      final data =
          CreatePollRequestModel(meetingId: meeting.id, fromUserId: myHubInfo.id, surveyName: surveyController.text, questions: questionsList, id: surveyId, surveyTime: surveyTime.toString());
      print("the model data is the ${data.toJson()}");
      CreatePollResponseModel res;
      if (isEdit) {
        res = await pollRepo.editPoll(data.toJson());
      } else {
        res = await pollRepo.createPoll(data.toJson());
      }
      if (res.status ?? false) {
        pollData = res;
        print("the poll data is the ${pollData!.toJson()}");
        CustomToast.showSuccessToast(msg: "Poll ${isEdit ? "updated" : "created"} successfully").then((value) {
          clearData();
          fetchAllPreviousPollQuestionFiles();
          Navigator.pop(context);
        });
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 500) {
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      }
      debugPrint("the dio exception while create poll ${e.response} ");
    } catch (e, st) {
      debugPrint("the  exception while create poll  ${e.toString()} && $st");
    }
    createPollLoading = false;
    notifyListeners();
  }

  Future<void> deleteRecentPollRecode(String surveyId, int? fromUserId) async {
    Loading.indicator(context);
    print("surveyId    ${surveyId.toString()}");
    try {
      final data = {"surveyId": surveyId, "user_id": fromUserId};

      final res = await pollRepo.deletePoll(data);
      print("the response data ${res.data.toString()}");
      if (res.data["status"]) {
        print("the response data ${res.data.toString()}");
        fetchAllPreviousPollQuestionFiles().then((value) {
          CustomToast.showSuccessToast(msg: "Deleted survey successfully").then((value) {
            Navigator.pop(context);
          });
        });
      }
    } on DioException catch (e) {
      debugPrint("the dio exception while delete poll ${e.response} ");
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint("the  exception while delete poll  ${e.toString()} && $st");
      Navigator.pop(context);
    }
  }

  Future<void> createDuplicatePollSurveyQuestionFile(String surveyId) async {
    Loading.indicator(context);
    try {
      final data = {"surveyId": surveyId};
      final res = await pollRepo.createDuplicatePollSurveyQuestionFile(data);
      if (res.status ?? false) {
        debugPrint("the response data ${res.data.toString()}");
        fetchAllPreviousPollQuestionFiles().then((value) {
          CustomToast.showSuccessToast(msg: "Created duplicated survey successfully").then((value) {
            Navigator.pop(context);
          });
        });
      }
    } on DioException catch (e) {
      debugPrint("the dio exception while duplicate survey poll ${e.response}");
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint("the exception while duplicate survey poll  ${e.toString()} && $st");
      Navigator.pop(context);
    }
  }

  Future<void> startPollGlobalSet(FetchPollQuestionFileData pollValues) async {
    try {
      ///Host Roll :! for Co-host :2
      final data = {"action": "open", "feature": "poll", "meetingId": meeting.id, "role": myHubInfo.isHost ? 1 : 2, "type": "pvwpqs", "userId": myHubInfo.id};

      chatRepo.questionAndAnsSet(data).then((res) {
        if (res["status"]) {
          _startPollGlobalSetStatus1a(pollValues);
        }
      });
    } on DioException catch (e) {
      debugPrint("the dio exception while start set poll ${e.response}");
    } catch (e, st) {
      debugPrint("the exception while start set poll ${e.toString()} && $st");
    }
  }

  Future<void> _startPollGlobalSetStatus1a(FetchPollQuestionFileData pollValues) async {
    try {
      final data = {"roomId": meeting.id, "key": "activePage", "value": "survey"};

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        final data = {
          "roomId": meeting.id,
          "key": "surveyMIddle",
          "value": {
            "page": "survey",
            "ou": myHubInfo.id,
            "value": {
              "_id": pollValues.id,
              "from_user_id": myHubInfo.id,
              "meeting_id": pollValues.meetingId,
              "questions": pollValues.questions!.map((e) {
                return e.toJson();
              }).toList(),
              "survey_name": pollValues.surveyName,
              "created_on": pollValues.createdOn.toString(),
              "updated_on": pollValues.updatedOn.toString()
            },
            "voting": false
          }
        };

        final res = await meetingRepo.updateGlobalAccessStatus(data);

        if (res.data["status"]) {
          _startPollGlobalSetStatus1b(pollValues);
        }
      }
    } on DioException catch (e) {
      debugPrint("the dio exception while _startPollGlobalSetStatus1a poll ${e.response} ${e.error}");
    } catch (e, st) {
      debugPrint("the exception while _startPollGlobalSetStatus1a poll ${e.toString()} && $st");
    }
  }

  Future<void> _startPollGlobalSetStatus1b(FetchPollQuestionFileData pollValues) async {
    try {
      final data = {
        "roomId": meeting.id,
        "key": "surveyMIddle",
        "value": {
          "ou": myHubInfo.id,
          "page": "survey",
          "voting": true,
          "shareResult": false,
          "value": {
            "_id": pollValues.id,
            "from_user_id": myHubInfo.id,
            "meeting_id": pollValues.meetingId,
            "questions": pollValues.questions!.map((e) {
              return e.toJson();
            }).toList(),
            "survey_name": pollValues.surveyName,
            "created_on": pollValues.createdOn.toString(),
            "updated_on": pollValues.updatedOn.toString(),
            "shareResult": false,
            "voting": true
          }
        }
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        _emitOnPanalCommandToStartPoll();
        _emitOnCommandToStartPoll(pollValues);

        CustomToast.showSuccessToast(msg: "poll started successfully").then((value) {
          Navigator.pop(context);
        });

        fetchAllPreviousPollQuestionFiles();
      }
    } on DioException catch (e) {
      debugPrint("the dio  exception while _startPollGlobalSetStatus1b poll ${e.response} && ${e.error}");
    } catch (e, st) {
      debugPrint("the exception while _startPollGlobalSetStatus1b poll ${e.toString()} && $st");
    }
  }

  _emitOnPanalCommandToStartPoll() {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {"action": "opened"},
        "value": "poll",
        "ou": myHubInfo.id,
        "on": myHubInfo.displayName,
        "roleType": myHubInfo.role.toString()
      }
    };

    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data), ack: (_) {
      debugPrint("_emitOnPanalCommandToStartPoll:called");
    });
  }

  _emitOnCommandToStartPoll(FetchPollQuestionFileData pollValues) {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "sendSurveySocket",
        "type": "survey",
        "value": {
          "_id": pollValues.id,
          "from_user_id": pollValues.fromUserId,
          "meeting_id": pollValues.meetingId,
          "questions": pollValues.questions!.map((e) {
            return e.toJson();
          }).toList(),
          "survey_name": pollValues.surveyName,
          "created_on": pollValues.createdOn.toString(),
          "updated_on": pollValues.updatedOn.toString(),
          "shareResult": false,
          "poll_time": surveyTime,
          "pollEndTime": "${DateTime.now().add(const Duration(minutes: 5))}",
          "voting": true,
          "isSurveyStarted": true
        },
        "ui": myHubInfo.id
      }
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("_emitOnCommandToStartPoll:called");
    });

    context.read<WebinarProvider>().setActivePage(ActivePage.poll);
    // Provider.of<WebinarProvider>(context,listen:false).
    buildPollResultsGraph(requiredInitialData: true);
  }

  ///EndPoll Voting
  Future<void> endPollVotingStatusSet() async {
    try {
      final data = {
        "roomId": meeting.id,
        "key": "remove",
        "value": ["surveyMIddle", "survey", "activePage", "surveyClose", "surveyEnd"]
      };
      final res = await meetingRepo.updateGlobalAccessStatus(data);

      if (res.data["status"]) {
        _emitEndPollVotingOnCommand();
        CustomToast.showSuccessToast(msg: "Poll voting Ended successfully");
      }
    } on DioException {
      debugPrint("the dio exception while speaket end poll ");
    } catch (e, st) {
      debugPrint("the exception while speaket end poll ${e.toString()} && $st");
    }
  }

  _emitEndPollVotingOnCommand() {
    final data = {
      "uid": "ALL",
      "data": {"command": "sendSurveySocket", "type": "endVoting", "value": true, "ui": myHubInfo.id, "pollId": _pollListeners.pollId}
    };
    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      print("the end event called ");
    });
  }

  ///End poll completly
  Future<void> endPollGlobalSet() async {
    try {
      final data = {"action": "close", "feature": "poll", "meetingId": "6570385b93767f00082b67b4", "role": 1, "type": "pvwpqs", "userId": myHubInfo.id};

      final res = await chatRepo.questionAndAnsSet(data);

      if (res["status"]) {
        endPollGlobalSetStatus();
      }
    } on DioException {}
  }

  Future<void> endPollGlobalSetStatus() async {
    try {
      final data = {
        "roomId": meeting.id,
        "key": "remove",
        "value": ["surveyMIddle", "survey", "activePage", "surveyClose", "surveyEnd"]
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);
      if (res.data["status"]) {
        _emitEndPollOnCommand();
        _emitEndPollOnPanalCommand();
        context.read<WebinarProvider>().setActivePage(ActivePage.audioVideo);
        CustomToast.showSuccessToast(msg: "Poll Ended");
      }
    } on DioException catch (e) {
      print("the dio exception in end poll ${e.response}  && ${e.error}");
    } catch (e) {
      print("the exception in end poll  ${e.toString()}");
    }
  }

  _emitEndPollOnCommand() {
    final data = {
      "uid": "ALL",
      "data": {"command": "sendSurveySocket", "type": "close", "value": "av", "ui": myHubInfo.id, "pollId": _pollListeners.pollId}
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data));
  }

  _emitEndPollOnPanalCommand() {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "AccessRestriction",
        "feature": {"action": "close"},
        "value": "poll",
        "ou": myHubInfo.id,
        "on": myHubInfo.email,
        "roleType": "Host"
      }
    };
    hubSocket.socket?.emitWithAck("onPanalCommand", jsonEncode(data));
  }

  ///display graph
  void buildPollResultsGraph({bool requiredInitialData = false, bool fromInitState = false}) {
    final optionsLenList = _pollListeners.pollQuestions.map((e) => e.options.length).toList();

    optionsLenList.sort((a, b) => b.compareTo(a));
    int maxLen = 0;
    if (optionsLenList.isNotEmpty) {
      maxLen = optionsLenList.first;
    }

    if (requiredInitialData) {
      for (int i = 0; i < _pollListeners.pollQuestions.length; i++) {
        Map<String, dynamic> temp = {"questionTotal": 0};
        if (_pollListeners.pollQuestions[i].options.isNotEmpty) {
          for (int j = 0; j < _pollListeners.pollQuestions[i].options.length; j++) {
            temp.addEntries([
              MapEntry(_pollListeners.pollQuestions[i].options[j].id.toString(), {"total": 0})
            ]);
          }
        }
        _pollListeners.pollResults.addEntries([MapEntry(_pollListeners.pollQuestions[i].id.toString(), temp)]);
      }
    }

    final seriesList = <ChartSeries<PollResultsChartData, String>>[];
    for (var i = 0; i < maxLen; i++) {
      var list = _pollListeners.pollQuestions
          .toList()
          .map((question) {
            if (question.options.isNotEmpty && question.options.length > i) {
              if (pollListeners.pollResults.containsKey(question.id)) {
                final count = pollListeners.pollResults[question.id]!.containsKey(question.options[i].id) ? pollListeners.pollResults[question.id]![question.options[i].id]!['total'] as int : 0;
                return PollResultsChartData(question.question!.length > 6 ? question.question!.substring(0, 6) : question.question!, count, Colors.yellow);
              }
            } else if (question.options.isEmpty && i == 0) {
              final count = pollListeners.pollResults[question.id]!['questionTotal'] as int;
              return PollResultsChartData(question.question!.length > 6 ? question.question!.substring(0, 6) : question.question!, count, Colors.green);
            }
            return null;
          })
          .whereType<PollResultsChartData>()
          .toList();

      final series = ColumnSeries<PollResultsChartData, String>(
        dataSource: list,
        xValueMapper: (PollResultsChartData data, _) => data.x,
        yValueMapper: (PollResultsChartData data, _) => data.y,
        name: '$i',
        color: Color.fromRGBO(Random().nextInt(150), Random().nextInt(100), Random().nextInt(255), 1),
      );

      seriesList.add(series);
    }

    pollresultsSeriesData = seriesList;
    if (!fromInitState) {
      update();
    }
  }

  ///share results
  Future<void> shareResultsGlobalSetStatus() async {
    try {
      final shareResultsData = PollInitialDataModel(
        id: pollListeners.pollId,
        fromUserId: myHubInfo.id,
        meetingId: pollListeners.meetingId,
        questions: pollListeners.pollQuestions,
        createdOn: pollListeners.createdDate,
        updatedOn: pollListeners.updatedDate,
        surveyName: pollListeners.pollSurveyName,
        shareResult: true,
        voting: true,
        userId: myHubInfo.id,
        isPollEnded: true,
      );
      final data = {
        "roomId": meeting.id,
        "key": "surveyMIddle",
        "value": {"ou": myHubInfo.id, "page": "survey", "voting": true, "shareResult": true, "value": shareResultsData.toJson()}
      };

      final res = await meetingRepo.updateGlobalAccessStatus(data);
      if (res.data["status"]) {
        _emitShareResults();
      }
    } on DioException catch (e) {
      print("the dio exception in share results ${e.response} && ${e.error}");
    } catch (e, st) {
      print("the dio exception in share results ${e.toString()} && $st");
    }
  }

  _emitShareResults() {
    final shareResultsData = PollInitialDataModel(
      id: pollListeners.pollId,
      fromUserId: myHubInfo.id,
      meetingId: pollListeners.meetingId,
      questions: pollListeners.pollQuestions,
      createdOn: pollListeners.createdDate,
      updatedOn: pollListeners.updatedDate,
      surveyName: pollListeners.pollSurveyName,
      shareResult: true,
      voting: true,
      userId: myHubInfo.id,
      isPollEnded: true,
      isSurveyStarted: true,
    );

    final data = {
      "uid": "ALL",
      "data": {"command": "sendSurveySocket", "type": "survey", "value": shareResultsData.toJson(), "ui": myHubInfo.id}
    };

    hubSocket.socket?.emitWithAck("onCommand", jsonEncode(data), ack: (_) {
      debugPrint("emitted share results onCommand event");
    });
  }

  ///get poll data when is completed

  Future<PollInitialDataModel?> getPollDataWhenCompleted() async {
    try {
      final payload = {"roomId": meeting.id.toString()};
      final response = await meetingRepo.fetchMeetingGlobalAccessStatus(payload);
      final pollFinalData = response.data!.pollData;

      return pollFinalData;
    } on DioException catch (e) {
      debugPrint("Dio error while getting poll data when poll is ended ${e.error} && ${e.response}");
    } catch (e, st) {
      debugPrint("the catched error while getting poll data ${e.toString()} && $st");
    }
    return null;
  }
}
