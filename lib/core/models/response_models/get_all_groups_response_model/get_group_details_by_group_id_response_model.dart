import 'package:json_annotation/json_annotation.dart';

part 'get_group_details_by_group_id_response_model.g.dart';

@JsonSerializable()
class GetGroupsDetailsByGroupIdResponseModel {
  int statusCode;
  String status;
  String? message;
  Data data;
  dynamic body;
  dynamic totalCount;

  GetGroupsDetailsByGroupIdResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory GetGroupsDetailsByGroupIdResponseModel.fromJson(Map<String, dynamic> json) => GetGroupsDetailsByGroupIdResponseModel(
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
  int groupId;
  int customerAccountId;
  String? groupName;
  String? description;
  String? groupPic;
  String? allEmails;
  String? toEmail;
  String? ccEmail;
  String? bccEmail;
  dynamic allEmailsData;
  dynamic toEmailsData;
  dynamic ccEmailsData;
  dynamic bccEmailsData;
  List<Contact> contacts;
  dynamic contactsCount;
  int trash;
  DateTime createdDate;
  DateTime updatedTime;

  Data({
    required this.groupId,
    required this.customerAccountId,
    required this.groupName,
    required this.description,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        contacts: List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
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
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
        "contactsCount": contactsCount,
        "trash": trash,
        "createdDate": createdDate.toIso8601String(),
        "updatedTime": updatedTime.toIso8601String(),
      };
}

class Contact {
  int? contactId;
  int? sponsorCustomerAccountId;
  dynamic customerAccountId;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? companyName;
  dynamic omailEmailId;
  String? alternateEmailId;
  String? countryCallCode;
  int? countryId;
  dynamic countryName;
  dynamic stateName;
  String? contactNumber;
  DateTime dateOfBirth;
  int? stateId;
  dynamic ofounderId;
  String? zipcode;
  String? contactPic;
  String? address;
  int? favStatus;
  int? trash;
  int? badgeId;
  dynamic sourceBadge;
  int? isEmailAllowed;
  int? emailAllowPermission;
  DateTime? createdDate;
  DateTime? updatedDate;

  Contact({
    required this.contactId,
    required this.sponsorCustomerAccountId,
    required this.customerAccountId,
    required this.firstName,
    required this.lastName,
    required this.jobTitle,
    required this.companyName,
    required this.omailEmailId,
    required this.alternateEmailId,
    required this.countryCallCode,
    required this.countryId,
    required this.countryName,
    required this.stateName,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.stateId,
    required this.ofounderId,
    required this.zipcode,
    required this.contactPic,
    required this.address,
    required this.favStatus,
    required this.trash,
    required this.badgeId,
    required this.sourceBadge,
    required this.isEmailAllowed,
    required this.emailAllowPermission,
    required this.createdDate,
    required this.updatedDate,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        contactId: json["contactId"],
        sponsorCustomerAccountId: json["sponsorCustomerAccountId"],
        customerAccountId: json["customerAccountId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        jobTitle: json["jobTitle"],
        companyName: json["companyName"],
        omailEmailId: json["omailEmailId"],
        alternateEmailId: json["alternateEmailId"],
        countryCallCode: json["countryCallCode"],
        countryId: json["countryId"],
        countryName: json["countryName"],
        stateName: json["stateName"],
        contactNumber: json["contactNumber"],
        dateOfBirth: json['dateOfBirth'] == null ? DateTime(1900) : DateTime.parse(json["dateOfBirth"]),
        stateId: json["stateId"],
        ofounderId: json["ofounderId"],
        zipcode: json["zipcode"],
        contactPic: json["contactPic"],
        address: json["address"],
        favStatus: json["favStatus"],
        trash: json["trash"],
        badgeId: json["badgeId"],
        sourceBadge: json["sourceBadge"],
        isEmailAllowed: json["isEmailAllowed"],
        emailAllowPermission: json["emailAllowPermission"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        updatedDate: json["updatedDate"] == null ? null : DateTime.parse(json["updatedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "sponsorCustomerAccountId": sponsorCustomerAccountId,
        "customerAccountId": customerAccountId,
        "firstName": firstName,
        "lastName": lastName,
        "jobTitle": jobTitle,
        "companyName": companyName,
        "omailEmailId": omailEmailId,
        "alternateEmailId": alternateEmailId,
        "countryCallCode": countryCallCode,
        "countryId": countryId,
        "countryName": countryName,
        "stateName": stateName,
        "contactNumber": contactNumber,
        "dateOfBirth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "stateId": stateId,
        "ofounderId": ofounderId,
        "zipcode": zipcode,
        "contactPic": contactPic,
        "address": address,
        "favStatus": favStatus,
        "trash": trash,
        "badgeId": badgeId,
        "sourceBadge": sourceBadge,
        "isEmailAllowed": isEmailAllowed,
        "emailAllowPermission": emailAllowPermission,
        "createdDate": createdDate?.toIso8601String(),
        "updatedDate": updatedDate?.toIso8601String(),
      };
}
