// To parse this JSON data, do
//
//     final getAllGroupsModel = getAllGroupsModelFromJson(jsonString);

import 'dart:convert';

GetAllGroupsModel getAllGroupsModelFromJson(String str) => GetAllGroupsModel.fromJson(json.decode(str));

String getAllGroupsModelToJson(GetAllGroupsModel data) => json.encode(data.toJson());

class GetAllGroupsModel {
  int? statusCode;
  String? status;
  String? message;
  Data? data;
  dynamic body;
  dynamic totalCount;

  GetAllGroupsModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory GetAllGroupsModel.fromJson(Map<String, dynamic> json) => GetAllGroupsModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    body: json["body"],
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "body": body,
    "totalCount": totalCount,
  };
}

class Data {
  int? pageNumber;
  int? pageSize;
  int? recordsSize;
  List<Record>? records;

  Data({
    this.pageNumber,
    this.pageSize,
    this.recordsSize,
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    recordsSize: json["recordsSize"],
    records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "recordsSize": recordsSize,
    "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class Record {
  int? groupId;
  int? customerAccountId;
  String? groupName;
  dynamic description;
  String? groupPic;
  String? allEmails;
  String? toEmail;
  String? ccEmail;
  String? bccEmail;
  dynamic allEmailsData;
  dynamic toEmailsData;
  dynamic ccEmailsData;
  dynamic bccEmailsData;
  dynamic contacts;
  int? contactsCount;
  int? trash;
  DateTime? createdDate;
  DateTime? updatedTime;
  bool isCheck;
  Record({
    this.groupId,
    this.customerAccountId,
    this.groupName,
    this.description,
    this.groupPic,
    this.allEmails,
    this.toEmail,
    this.ccEmail,
    this.bccEmail,
    this.allEmailsData,
    this.toEmailsData,
    this.ccEmailsData,
    this.bccEmailsData,
    this.contacts,
    this.contactsCount,
    this.trash,
    this.createdDate,
    this.updatedTime,
    this.isCheck = false
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
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    updatedTime: json["updatedTime"] == null ? null : DateTime.parse(json["updatedTime"]),
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
    "createdDate": createdDate?.toIso8601String(),
    "updatedTime": updatedTime?.toIso8601String(),
  };
}
