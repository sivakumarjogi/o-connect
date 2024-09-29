import 'package:json_annotation/json_annotation.dart';

part 'create_poll_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CreatePollModel {
  bool status;
  CreatePollModelDatum data;

  CreatePollModel({
    required this.status,
    required this.data,
  });

  factory CreatePollModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePollModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePollModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreatePollModelDatum {
  int fromUserId;
  String meetingId;
  List<Question> questions;
  String surveyName;
  DateTime createdOn;
  DateTime updatedOn;
  String id;

  CreatePollModelDatum({
    required this.fromUserId,
    required this.meetingId,
    List<Question>? questions,
    required this.surveyName,
    required this.createdOn,
    required this.updatedOn,
    required this.id,
  }) : questions = questions ?? <Question>[];

  factory CreatePollModelDatum.fromJson(Map<String, dynamic> json) =>
      _$CreatePollModelDatumFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePollModelDatumToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Question {
  String question;
  String questionType;
  List<Option> options;
  String id;

  Question({
    required this.question,
    required this.questionType,
    List<Option>? options,
    required this.id,
  }) : options = options ?? <Option>[];

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Option {
  String ansOption;
  String id;

  Option({
    required this.ansOption,
    required this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
