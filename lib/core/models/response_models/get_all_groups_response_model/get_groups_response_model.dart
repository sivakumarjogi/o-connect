//
//     final getAllGroupsResponseModel = getAllGroupsResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'get_groups_response_model.g.dart';

@JsonSerializable()
class GetAllGroupsResponseModel {
  int statusCode;
  String status;
  String message;
  Data data;
  dynamic body;
  dynamic totalCount;

  GetAllGroupsResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory GetAllGroupsResponseModel.fromJson(Map<String, dynamic> json) => GetAllGroupsResponseModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    body: json["body"],
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data.toJson(),
    "body": body,
    "totalCount": totalCount,
  };
}

class Data {
  int pageNumber;
  int pageSize;
  int recordsSize;
  List<Record> records;

  Data({
    required this.pageNumber,
    required this.pageSize,
    required this.recordsSize,
    required this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    recordsSize: json["recordsSize"],
    records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "recordsSize": recordsSize,
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

class Record {
  int groupId;
  int customerAccountId;
  String groupName;
  String? description;
  String? groupPic;
  String allEmails;
  String toEmail;
  String ccEmail;
  String bccEmail;
  dynamic allEmailsData;
  dynamic toEmailsData;
  dynamic ccEmailsData;
  dynamic bccEmailsData;
  dynamic contacts;
  int contactsCount;
  int trash;
  DateTime createdDate;
  DateTime updatedTime;

  Record({
    required this.groupId,
    required this.customerAccountId,
    required this.groupName,
    this.description,
    required this.groupPic,
    required this.allEmails,
    required this.toEmail,
    required this.ccEmail,
    required this.bccEmail,
    required this.allEmailsData,
    required this.toEmailsData,
    required this.ccEmailsData,
    required this.bccEmailsData,
    required this.contacts,
    required this.contactsCount,
    required this.trash,
    required this.createdDate,
    required this.updatedTime,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    groupId: json["groupId"],
    customerAccountId: json["customerAccountId"],
    groupName: json["groupName"],
    description: json["description"],
    groupPic: json["groupPic"],
    allEmails: json["allEmails"],
    toEmail: json["toEmail"],
    ccEmail: json["ccEmail"],
    bccEmail: json["bccEmail"],
    allEmailsData: json["allEmailsData"],
    toEmailsData: json["toEmailsData"],
    ccEmailsData: json["ccEmailsData"],
    bccEmailsData: json["bccEmailsData"],
    contacts: json["contacts"],
    contactsCount: json["contactsCount"],
    trash: json["trash"],
    createdDate: DateTime.parse(json["createdDate"]),
    updatedTime: DateTime.parse(json["updatedTime"]),
  );

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "customerAccountId": customerAccountId,
    "groupName": groupName,
    "description": description,
    "groupPic": groupPic,
    "allEmails": allEmails,
    "toEmail": toEmail,
    "ccEmail": ccEmail,
    "bccEmail": bccEmail,
    "allEmailsData": allEmailsData,
    "toEmailsData": toEmailsData,
    "ccEmailsData": ccEmailsData,
    "bccEmailsData": bccEmailsData,
    "contacts": contacts,
    "contactsCount": contactsCount,
    "trash": trash,
    "createdDate": createdDate.toIso8601String(),
    "updatedTime": updatedTime.toIso8601String(),
  };
}
