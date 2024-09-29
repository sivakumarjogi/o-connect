import 'dart:convert';

CreatePollResponseModel createPollResponseModelFromJson(String str) => CreatePollResponseModel.fromJson(json.decode(str));

String createPollResponseModelToJson(CreatePollResponseModel data) => json.encode(data.toJson());

class CreatePollResponseModel {
  bool? status;
  CreatePollResponseModelData? data;

  CreatePollResponseModel({
    this.status,
    this.data,
  });

  factory CreatePollResponseModel.fromJson(Map<String, dynamic> json) => CreatePollResponseModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : json["data"].runtimeType == List
                ? CreatePollResponseModelData.fromJson(json["data"][0])
                : CreatePollResponseModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class CreatePollResponseModelData {
  int? fromUserId;
  String? meetingId;
  List<CreatePollResponseModelQuestion>? questions;
  String? surveyName;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? id;

  CreatePollResponseModelData({
    this.fromUserId,
    this.meetingId,
    this.questions,
    this.surveyName,
    this.createdOn,
    this.updatedOn,
    this.id,
  });

  factory CreatePollResponseModelData.fromJson(Map<String, dynamic> json) => CreatePollResponseModelData(
        fromUserId: json["from_user_id"],
        meetingId: json["meeting_id"],
        questions: json["questions"] == null ? [] : List<CreatePollResponseModelQuestion>.from(json["questions"]!.map((x) => CreatePollResponseModelQuestion.fromJson(x))),
        surveyName: json["survey_name"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "from_user_id": fromUserId,
        "meeting_id": meetingId,
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "survey_name": surveyName,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "_id": id,
      };
}

class CreatePollResponseModelQuestion {
  String? question;
  String? questionType;
  List<Option>? options;
  String? id;

  CreatePollResponseModelQuestion({
    this.question,
    this.questionType,
    this.options,
    this.id,
  });

  factory CreatePollResponseModelQuestion.fromJson(Map<String, dynamic> json) => CreatePollResponseModelQuestion(
        question: json["question"],
        questionType: json["question_type"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "question_type": questionType,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
        "_id": id,
      };
}

class Option {
  String? ansOption;
  String? id;

  Option({
    this.ansOption,
    this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        ansOption: json["ans_option"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "ans_option": ansOption,
        "_id": id,
      };
}
