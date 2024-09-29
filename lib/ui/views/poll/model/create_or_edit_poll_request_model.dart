// To parse this JSON data, do
//
//     final editPollRequestModel = editPollRequestModelFromJson(jsonString);

import 'dart:convert';

CreatePollRequestModel editPollRequestModelFromJson(String str) => CreatePollRequestModel.fromJson(json.decode(str));

String editPollRequestModelToJson(CreatePollRequestModel data) => json.encode(data.toJson());

class CreatePollRequestModel {
  int? fromUserId;
  String? meetingId;
  String? surveyTime;
  List<CreatePollRequestModelQuestion>? questions;
  String? surveyName;
  String? id;

  CreatePollRequestModel({
    this.fromUserId,
    this.meetingId,
    this.questions,
    this.surveyName,
    this.surveyTime,
    this.id,
  });

  factory CreatePollRequestModel.fromJson(Map<String, dynamic> json) => CreatePollRequestModel(
        fromUserId: json["from_user_id"],
        meetingId: json["meeting_id"],
        questions: json["questions"] == null ? [] : List<CreatePollRequestModelQuestion>.from(json["questions"]!.map((x) => CreatePollRequestModelQuestion.fromJson(x))),
        surveyName: json["survey_name"],
        surveyTime: json["poll_time"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "from_user_id": fromUserId,
        "meeting_id": meetingId,
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "survey_name": surveyName,
        "poll_time": surveyTime,
        if (id != null && id!.isNotEmpty) "_id": id,
      };
}

class CreatePollRequestModelQuestion {
  String? question;
  String? questionType;
  List<CreatePollRequestModelOption> options;
  String? id;

  CreatePollRequestModelQuestion({
    this.question,
    this.questionType,
    required this.options,
    this.id,
  });

  factory CreatePollRequestModelQuestion.fromJson(Map<String, dynamic> json) => CreatePollRequestModelQuestion(
        question: json["question"],
        questionType: json["question_type"],
        options: json["options"] == null ? [] : List<CreatePollRequestModelOption>.from(json["options"]!.map((x) => CreatePollRequestModelOption.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "question_type": questionType,
        "options": options == null ? [] : List<dynamic>.from(options.map((x) => x.toJson())),
        if (id != null && id!.isNotEmpty) "_id": id,
      };
}

class CreatePollRequestModelOption {
  String? ansOption;
  String? id;
  int? votes;

  CreatePollRequestModelOption({this.ansOption, this.id, this.votes});

  factory CreatePollRequestModelOption.fromJson(Map<String, dynamic> json) => CreatePollRequestModelOption(ansOption: json["ans_option"], id: json["_id"], votes: json["votes"]);

  Map<String, dynamic> toJson() => {
        "ans_option": ansOption,
        if (id != null && id!.isNotEmpty) "_id": id,
        if (votes != null && votes!.isNaN) "votes": votes,
      };
}
