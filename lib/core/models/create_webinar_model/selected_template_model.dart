class SelectTemplateModel {
  bool? status;
  List<SelectedTemplateDatum>? data;

  SelectTemplateModel({
    this.status,
    this.data,
  });

  factory SelectTemplateModel.fromJson(Map<String, dynamic> json) => SelectTemplateModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<SelectedTemplateDatum>.from(json["data"]!.map((x) => SelectedTemplateDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SelectedTemplateDatum {
  String? id;
  String? templateName;
  String? meetingId;
  int? userId;
  int? status;
  String? meetingName;
  String? meetingType;
  dynamic meetingAgenda;
  DateTime? createdOn;
  DateTime? updatedOn;

  SelectedTemplateDatum({
    this.id,
    this.templateName,
    this.meetingId,
    this.userId,
    this.status,
    this.meetingName,
    this.meetingType,
    this.meetingAgenda,
    this.createdOn,
    this.updatedOn,
  });

  factory SelectedTemplateDatum.fromJson(Map<String, dynamic> json) => SelectedTemplateDatum(
    id: json["_id"],
    templateName: json["template_name"],
    meetingId: json["meeting_id"],
    userId: json["user_id"],
    status: json["status"],
    meetingName: json["meeting_name"],
    meetingType: json["meeting_type"],
    meetingAgenda: json["meeting_agenda"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "template_name": templateName,
    "meeting_id": meetingId,
    "user_id": userId,
    "status": status,
    "meeting_name": meetingName,
    "meeting_type": meetingType,
    "meeting_agenda": meetingAgenda,
    "created_on": createdOn?.toIso8601String(),
    "updated_on": updatedOn?.toIso8601String(),
  };
}
