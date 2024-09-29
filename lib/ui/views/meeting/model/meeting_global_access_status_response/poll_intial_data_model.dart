import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:o_connect/ui/views/poll/model/create_or_edit_poll_request_model.dart';
import 'package:o_connect/ui/views/poll/model/speakers_submitted_answers_model.dart';

PollInitialDataModel pollInitialDataModelFromJson(String str) => PollInitialDataModel.fromJson(json.decode(str));

String pollInitialDataModelToJson(PollInitialDataModel data) => json.encode(data.toJson());

class PollInitialDataModel extends Equatable {
  final String? id;
  final dynamic fromUserId;
  final String? meetingId;
  final List<CreatePollRequestModelQuestion>? questions;
  final String? surveyName;
  final dynamic createdOn;
  final dynamic updatedOn;
  final bool? shareResult;
  final bool? voting;
  final bool? isSurveyStarted;
  final dynamic userId;
  final List<PollInitialDataModelSubmittedList>? submittedList;
  final List<int>? submittedUsers;
  final bool? isPollEnded;

  const PollInitialDataModel(
      {this.id,
      this.fromUserId,
      this.meetingId,
      this.questions,
      this.surveyName,
      this.createdOn,
      this.updatedOn,
      this.shareResult,
      this.voting,
      this.isSurveyStarted,
      this.userId,
      this.submittedList,
      this.submittedUsers,
      this.isPollEnded});

  factory PollInitialDataModel.fromJson(Map<String, dynamic> json) => PollInitialDataModel(
        id: json["_id"],
        fromUserId: json["from_user_id"],
        meetingId: json["meeting_id"],
        questions: json["questions"] == null ? [] : List<CreatePollRequestModelQuestion>.from(json["questions"]!.map((x) => CreatePollRequestModelQuestion.fromJson(x))),
        surveyName: json["survey_name"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        shareResult: json["shareResult"],
        voting: json["voting"],
        isSurveyStarted: json["isSurveyStarted"],
        userId: json["userId"],
        submittedList: json["submittedList"] == null ? [] : List<PollInitialDataModelSubmittedList>.from(json["submittedList"]!.map((x) => PollInitialDataModelSubmittedList.fromJson(x))),
        submittedUsers: json["submittedUsers"] == null ? [] : List<int>.from(json["submittedUsers"]!.map((x) => x)),
        isPollEnded: json["isPollEnded"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from_user_id": fromUserId,
        "meeting_id": meetingId,
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
        "survey_name": surveyName,
        "created_on": createdOn.runtimeType == DateTime ? createdOn?.toIso8601String() : createdOn,
        "updated_on": updatedOn.runtimeType == DateTime ? updatedOn?.toIso8601String() : updatedOn,
        "shareResult": shareResult,
        "voting": voting,
        "isSurveyStarted": isSurveyStarted,
        "userId": userId,
        "submittedList": submittedList == null ? [] : List<dynamic>.from(submittedList!.map((x) => x.toJson())),
        "submittedUsers": submittedUsers == null ? [] : List<dynamic>.from(submittedUsers!.map((x) => x)),
        if (isPollEnded != null || isPollEnded == false) "isPollEnded": isPollEnded
      };

  @override
  List<Object?> get props {
    return [
      id,
      fromUserId,
      meetingId,
      questions,
      surveyName,
      createdOn,
      updatedOn,
      shareResult,
      voting,
      isSurveyStarted,
      userId,
      submittedList,
      submittedUsers,
    ];
  }
}

// class CreatePollRequestModelQuestion extends Equatable {
//   final String? question;
//   final String? questionType;
//   final List<PollInitialDataModelOption>? options;
//   final String? id;

//   const CreatePollRequestModelQuestion({
//     this.question,
//     this.questionType,
//     this.options,
//     this.id,
//   });

//   factory CreatePollRequestModelQuestion.fromJson(Map<String, dynamic> json) => CreatePollRequestModelQuestion(
//         question: json["question"],
//         questionType: json["question_type"],
//         options: json["options"] == null ? [] : List<PollInitialDataModelOption>.from(json["options"]!.map((x) => PollInitialDataModelOption.fromJson(x))),
//         id: json["_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "question": question,
//         "question_type": questionType,
//         "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
//         "_id": id,
//       };

//   @override
//   List<Object?> get props {
//     return [
//       question,
//       questionType,
//       options,
//       id,
//     ];
//   }
// }

// class PollInitialDataModelOption extends Equatable {
//   final String? ansOption;
//   final String? id;
//   final int? votes;

//   const PollInitialDataModelOption({
//     this.ansOption,
//     this.id,
//     this.votes,
//   });

//   factory PollInitialDataModelOption.fromJson(Map<String, dynamic> json) => PollInitialDataModelOption(
//         ansOption: json["ans_option"],
//         id: json["_id"],
//         votes: json["votes"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ans_option": ansOption,
//         "_id": id,
//         "votes": votes,
//       };

//   @override
//   List<Object?> get props {
//     return [
//       ansOption,
//       id,
//       votes,
//     ];
//   }
// }

class PollInitialDataModelSubmittedList extends Equatable {
  final int? uid;
  final PollInitialDataModelData? data;

  const PollInitialDataModelSubmittedList({
    this.uid,
    this.data,
  });

  factory PollInitialDataModelSubmittedList.fromJson(Map<String, dynamic> json) => PollInitialDataModelSubmittedList(
        uid: json["uid"],
        data: json["data"] == null ? null : PollInitialDataModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "data": data?.toJson(),
      };

  @override
  List<Object?> get props {
    return [uid, data];
  }
}

class PollInitialDataModelData extends Equatable {
  final String? command;
  final String? type;
  final List<SpeakersSubmittedAnswersModel>? value;
  final int? uid;

  const PollInitialDataModelData({
    this.command,
    this.type,
    this.value,
    this.uid,
  });

  factory PollInitialDataModelData.fromJson(Map<String, dynamic> json) => PollInitialDataModelData(
        command: json["command"],
        type: json["type"],
        value: json["value"] == null ? [] : List<SpeakersSubmittedAnswersModel>.from(json["value"]!.map((x) => SpeakersSubmittedAnswersModel.fromJson(x))),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "command": command,
        "type": type,
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x.toJson())),
        "uid": uid,
      };

  @override
  List<Object?> get props {
    return [
      command,
      type,
      value,
      uid,
    ];
  }
}
