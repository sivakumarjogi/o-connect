// To parse this JSON data, do
//
//     final getAllContactsModel = getAllContactsModelFromJson(jsonString);

import 'dart:convert';

AllContactsResponseModel getAllContactsModelFromJson(String str) => AllContactsResponseModel.fromJson(json.decode(str));

String getAllContactsModelToJson(AllContactsResponseModel data) => json.encode(data.toJson());

class AllContactsResponseModel {
  int? statusCode;
  String? status;
  String? message;
  dynamic data;
  List<AllContactsResponseModelBody>? body;
  dynamic totalCount;

  AllContactsResponseModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory AllContactsResponseModel.fromJson(Map<String, dynamic> json) => AllContactsResponseModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"],
        body: json["body"] == null ? [] : List<AllContactsResponseModelBody>.from(json["body"]!.map((x) => AllContactsResponseModelBody.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "message": message,
        "data": data,
        "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class AllContactsResponseModelBody {
  int? contactId;
  int? sponsorCustomerAccountId;
  int? customerAccountId;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? companyName;
  String? omailEmailId;
  String? alternateEmailId;
  String? countryCallCode;
  int? countryId;
  String? countryName;
  dynamic stateName;
  String? contactNumber;
  DateTime? dateOfBirth;
  dynamic stateId;
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
  dynamic userJoinedDate;
  bool? isCheck;
  int? participantsValue;
  bool? show;

  AllContactsResponseModelBody({
    this.contactId,
    this.sponsorCustomerAccountId,
    this.customerAccountId,
    this.firstName,
    this.lastName,
    this.jobTitle,
    this.companyName,
    this.omailEmailId,
    this.alternateEmailId,
    this.countryCallCode,
    this.countryId,
    this.countryName,
    this.stateName,
    this.contactNumber,
    this.dateOfBirth,
    this.stateId,
    this.ofounderId,
    this.zipcode,
    this.contactPic,
    this.address,
    this.favStatus,
    this.trash,
    this.badgeId,
    this.sourceBadge,
    this.isEmailAllowed,
    this.emailAllowPermission,
    this.createdDate,
    this.updatedDate,
    this.userJoinedDate,
    this.isCheck = false,
    this.participantsValue = 3,
    this.show = true,

    /// for using Guest roleId
  });

  factory AllContactsResponseModelBody.fromJson(Map<String, dynamic> json) => AllContactsResponseModelBody(
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
        dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
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
        userJoinedDate: json["userJoinedDate"],
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
        "dateOfBirth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
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
        "userJoinedDate": userJoinedDate,
      };

  AllContactsResponseModelBody copyWith({
    int? contactId,
    int? sponsorCustomerAccountId,
    int? customerAccountId,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? companyName,
    String? omailEmailId,
    String? alternateEmailId,
    String? countryCallCode,
    int? countryId,
    String? countryName,
    String? stateName,
    String? contactNumber,
    DateTime? dateOfBirth,
    dynamic stateId,
    dynamic ofounderId,
    String? zipcode,
    String? contactPic,
    String? address,
    int? favStatus,
    int? trash,
    int? badgeId,
    dynamic sourceBadge,
    int? isEmailAllowed,
    int? emailAllowPermission,
    DateTime? createdDate,
    DateTime? updatedDate,
    dynamic userJoinedDate,
    bool? isCheck,
    int? participantsValue,
    bool? show,
  }) {
    return AllContactsResponseModelBody(
      contactId: contactId ?? this.contactId,
      sponsorCustomerAccountId: sponsorCustomerAccountId ?? this.sponsorCustomerAccountId,
      customerAccountId: customerAccountId ?? this.customerAccountId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      omailEmailId: omailEmailId ?? this.omailEmailId,
      alternateEmailId: alternateEmailId ?? this.alternateEmailId,
      countryCallCode: countryCallCode ?? this.countryCallCode,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
      stateName: stateName ?? this.stateName,
      contactNumber: contactNumber ?? this.contactNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      stateId: stateId ?? this.stateId,
      ofounderId: ofounderId ?? this.ofounderId,
      zipcode: zipcode ?? this.zipcode,
      contactPic: contactPic ?? this.contactPic,
      address: address ?? this.address,
      favStatus: favStatus ?? this.favStatus,
      trash: trash ?? this.trash,
      badgeId: badgeId ?? this.badgeId,
      sourceBadge: sourceBadge ?? this.sourceBadge,
      isEmailAllowed: isEmailAllowed ?? this.isEmailAllowed,
      emailAllowPermission: emailAllowPermission ?? this.emailAllowPermission,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      userJoinedDate: userJoinedDate ?? this.userJoinedDate,
      isCheck: isCheck ?? this.isCheck,
      participantsValue: participantsValue ?? this.participantsValue,
      show: show ?? this.show,
    );
  }
}
