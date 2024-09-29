// To parse this JSON data, do
//
//     final fetchPollQuestionFile = fetchPollQuestionFileFromJson(jsonString);

import 'dart:convert';

FetchPollQuestionFile fetchPollQuestionFileFromJson(String str) => FetchPollQuestionFile.fromJson(json.decode(str));

String fetchPollQuestionFileToJson(FetchPollQuestionFile data) => json.encode(data.toJson());

class FetchPollQuestionFile {
  bool? status;
  List<FetchPollQuestionFileData>? data;

  FetchPollQuestionFile({
    this.status,
    this.data,
  });

  factory FetchPollQuestionFile.fromJson(Map<String, dynamic> json) => FetchPollQuestionFile(
        status: json["status"],
        data: json["data"] == null ? [] : List<FetchPollQuestionFileData>.from(json["data"]!.map((x) => FetchPollQuestionFileData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FetchPollQuestionFileData {
  String? id;
  int? fromUserId;
  String? meetingId;
  List<FetchPollQuestionFileQuestion>? questions;
  String? surveyName;
  DateTime? createdOn;
  DateTime? updatedOn;

  FetchPollQuestionFileData({
    this.id,
    this.fromUserId,
    this.meetingId,
    this.questions,
    this.surveyName,
    this.createdOn,
    this.updatedOn,
  });

  factory FetchPollQuestionFileData.fromJson(Map<String, dynamic> json) => FetchPollQuestionFileData(
        id: json["_id"],
        fromUserId: json["from_user_id"],
        meetingId: json["meeting_id"],
        questions: json["questions"] == null ? [] : List<FetchPollQuestionFileQuestion>.from(json["questions"]!.map((x) => FetchPollQuestionFileQuestion.fromJson(x))),
        surveyName: json["survey_name"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from_user_id": fromUserId,
        "meeting_id": meetingId,
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "survey_name": surveyName,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
      };
}

class FetchPollQuestionFileQuestion {
  String? question;
  String? questionType;
  List<FetchPollQuestionFileOption>? options;
  String? id;

  FetchPollQuestionFileQuestion({
    this.question,
    this.questionType,
    this.options,
    this.id,
  });

  factory FetchPollQuestionFileQuestion.fromJson(Map<String, dynamic> json) => FetchPollQuestionFileQuestion(
        question: json["question"],
        questionType: json["question_type"],
        options: json["options"] == null ? [] : List<FetchPollQuestionFileOption>.from(json["options"]!.map((x) => FetchPollQuestionFileOption.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "question_type": questionType,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
        "_id": id,
      };
}

class FetchPollQuestionFileOption {
  String? ansOption;
  String? id;

  FetchPollQuestionFileOption({
    this.ansOption,
    this.id,
  });

  factory FetchPollQuestionFileOption.fromJson(Map<String, dynamic> json) => FetchPollQuestionFileOption(
        ansOption: json["ans_option"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "ans_option": ansOption,
        "_id": id,
      };
}
