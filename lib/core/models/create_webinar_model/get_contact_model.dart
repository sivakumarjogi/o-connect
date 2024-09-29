
import 'dart:convert';

AllContactsModel allContactsModelFromJson(String str) => AllContactsModel.fromJson(json.decode(str));

String allContactsModelToJson(AllContactsModel data) => json.encode(data.toJson());

class AllContactsModel {
  int? statusCode;
  String? status;
  String? message;
  AllContactsModelData? data;
  dynamic body;
  dynamic totalCount;

  AllContactsModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory AllContactsModel.fromJson(Map<String, dynamic> json) => AllContactsModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AllContactsModelData.fromJson(json["data"]),
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

class AllContactsModelData {
  int? pageNumber;
  int? pageSize;
  int? recordsSize;
  List<AllContactsModelDataRecord>? records;

  AllContactsModelData({
    this.pageNumber,
    this.pageSize,
    this.recordsSize,
    this.records,
  });

  factory AllContactsModelData.fromJson(Map<String, dynamic> json) => AllContactsModelData(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        recordsSize: json["recordsSize"],
        records: json["records"] == null ? [] : List<AllContactsModelDataRecord>.from(json["records"]!.map((x) => AllContactsModelDataRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "recordsSize": recordsSize,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class AllContactsModelDataRecord {
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
  String? dateOfBirth;
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
  String? createdDate;
  String? updatedDate;
  String? userJoinedDate;

  AllContactsModelDataRecord({
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
  });

  factory AllContactsModelDataRecord.fromJson(Map<String, dynamic> json) => AllContactsModelDataRecord(
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
        dateOfBirth: json["dateOfBirth"],
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
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
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
        "dateOfBirth": dateOfBirth,
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
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "userJoinedDate": userJoinedDate,
      };
}
