// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_poll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePollModel _$CreatePollModelFromJson(Map<String, dynamic> json) =>
    CreatePollModel(
      status: json['status'] as bool,
      data: CreatePollModelDatum.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePollModelToJson(CreatePollModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

CreatePollModelDatum _$CreatePollModelDatumFromJson(
        Map<String, dynamic> json) =>
    CreatePollModelDatum(
      fromUserId: json['fromUserId'] as int,
      meetingId: json['meetingId'] as String,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      surveyName: json['surveyName'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      updatedOn: DateTime.parse(json['updatedOn'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$CreatePollModelDatumToJson(
        CreatePollModelDatum instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'meetingId': instance.meetingId,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'surveyName': instance.surveyName,
      'createdOn': instance.createdOn.toIso8601String(),
      'updatedOn': instance.updatedOn.toIso8601String(),
      'id': instance.id,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      question: json['question'] as String,
      questionType: json['questionType'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'question': instance.question,
      'questionType': instance.questionType,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      ansOption: json['ansOption'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'ansOption': instance.ansOption,
      'id': instance.id,
    };
