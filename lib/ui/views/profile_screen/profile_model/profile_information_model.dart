// To parse this JSON data, do
//
//     final profileInformationModel = profileInformationModelFromJson(jsonString);

import 'dart:convert';

ProfileInformationModel profileInformationModelFromJson(String str) => ProfileInformationModel.fromJson(json.decode(str));

String profileInformationModelToJson(ProfileInformationModel data) => json.encode(data.toJson());

class ProfileInformationModel {
  int? statusCode;
  String? status;
  String? message;
  ProfileInfoData? data;
  dynamic body;
  dynamic totalCount;

  ProfileInformationModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory ProfileInformationModel.fromJson(Map<String, dynamic> json) => ProfileInformationModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileInfoData.fromJson(json["data"]),
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

class ProfileInfoData {
  String? lastName;
  String? mobileNumber;
  int? isndasigned;
  int? isOfounder;
  String? emailId;
  DateTime? joinedDate;
  String? countryCode;
  dynamic ofJoinedDate;
  dynamic ndasign;
  String? alternateEmail;
  String? totalEarnings;
  String? affiliationLink;
  int? cutomerAccountId;
  String? profilePic;
  int? reseller;
  String? nationality;
  dynamic ndasigndate;
  String? firstName;
  int? emailVerified;
  String? affiliationName;
  dynamic totalAffiliateDetails;
  int? customerId;
  String? name;
  String? location;
  String? affiliationId;
  int? totalAffiliates;
  String? region;

  ProfileInfoData({
    this.lastName,
    this.mobileNumber,
    this.isndasigned,
    this.isOfounder,
    this.emailId,
    this.joinedDate,
    this.countryCode,
    this.ofJoinedDate,
    this.ndasign,
    this.alternateEmail,
    this.totalEarnings,
    this.affiliationLink,
    this.cutomerAccountId,
    this.profilePic,
    this.reseller,
    this.nationality,
    this.ndasigndate,
    this.firstName,
    this.emailVerified,
    this.affiliationName,
    this.totalAffiliateDetails,
    this.customerId,
    this.name,
    this.location,
    this.affiliationId,
    this.totalAffiliates,
    this.region,
  });

  factory ProfileInfoData.fromJson(Map<String, dynamic> json) => ProfileInfoData(
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        isndasigned: json["isndasigned"],
        isOfounder: json["isOfounder"],
        emailId: json["emailId"],
        joinedDate: json["joinedDate"] == null ? null : DateTime.parse(json["joinedDate"]),
        countryCode: json["countryCode"],
        ofJoinedDate: json["ofJoinedDate"],
        ndasign: json["Ndasign"],
        alternateEmail: json["alternateEmail"],
        totalEarnings: json["totalEarnings"],
        affiliationLink: json["affiliationLink"],
        cutomerAccountId: json["cutomerAccountID"],
        profilePic: json["profilePic"],
        reseller: json["reseller"],
        nationality: json["Nationality"],
        ndasigndate: json["ndasigndate"],
        firstName: json["firstName"],
        emailVerified: json["emailVerified"],
        affiliationName: json["affiliationName"],
        totalAffiliateDetails: json["totalAffiliateDetails"],
        customerId: json["customerID"],
        name: json["name"],
        location: json["location"],
        affiliationId: json["affiliationId"],
        totalAffiliates: json["totalAffiliates"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "isndasigned": isndasigned,
        "isOfounder": isOfounder,
        "emailId": emailId,
        "joinedDate": joinedDate?.toIso8601String(),
        "countryCode": countryCode,
        "ofJoinedDate": ofJoinedDate,
        "Ndasign": ndasign,
        "alternateEmail": alternateEmail,
        "totalEarnings": totalEarnings,
        "affiliationLink": affiliationLink,
        "cutomerAccountID": cutomerAccountId,
        "profilePic": profilePic,
        "reseller": reseller,
        "Nationality": nationality,
        "ndasigndate": ndasigndate,
        "firstName": firstName,
        "emailVerified": emailVerified,
        "affiliationName": affiliationName,
        "totalAffiliateDetails": totalAffiliateDetails,
        "customerID": customerId,
        "name": name,
        "location": location,
        "affiliationId": affiliationId,
        "totalAffiliates": totalAffiliates,
        "region": region,
      };
}
