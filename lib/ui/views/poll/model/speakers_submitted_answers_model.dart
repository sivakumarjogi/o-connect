// To parse this JSON data, do
//
//     final speakersSubmittedAnswersModel = speakersSubmittedAnswersModelFromJson(jsonString);

import 'dart:convert';

SpeakersSubmittedAnswersModel speakersSubmittedAnswersModelFromJson(String str) => SpeakersSubmittedAnswersModel.fromJson(json.decode(str));

String speakersSubmittedAnswersModelToJson(SpeakersSubmittedAnswersModel data) => json.encode(data.toJson());

class SpeakersSubmittedAnswersModel {
  String? questionId;
  String? meetingId;
  String? questionType;
  int? attendeeId;
  String? optionId;

  SpeakersSubmittedAnswersModel({
    this.questionId,
    this.meetingId,
    this.questionType,
    this.attendeeId,
    this.optionId,
  });

  SpeakersSubmittedAnswersModel copyWith({
    String? questionId,
    String? meetingId,
    String? questionType,
    int? attendeeId,
    String? optionId,
  }) =>
      SpeakersSubmittedAnswersModel(
        questionId: questionId ?? this.questionId,
        meetingId: meetingId ?? this.meetingId,
        questionType: questionType ?? this.questionType,
        attendeeId: attendeeId ?? this.attendeeId,
        optionId: optionId ?? this.optionId,
      );

  factory SpeakersSubmittedAnswersModel.fromJson(Map<String, dynamic> json) => SpeakersSubmittedAnswersModel(
        questionId: json["questionId"],
        meetingId: json["meetingId"],
        questionType: json["questionType"],
        attendeeId: json["attendeeId"],
        optionId: json["optionId"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "meetingId": meetingId,
        "questionType": questionType,
        "attendeeId": attendeeId,
        "optionId": optionId,
      };
}
