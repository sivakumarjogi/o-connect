// To parse this JSON data, do
//
//     final generateTokenModel = generateTokenModelFromJson(jsonString);

import 'dart:convert';

GenerateTokenOConnectModel generateTokenModelFromJson(String str) =>
    GenerateTokenOConnectModel.fromJson(json.decode(str));

String generateTokenModelToJson(GenerateTokenOConnectModel data) =>
    json.encode(data.toJson());

class GenerateTokenOConnectModel {
  bool? status;
  GenerateTokenData? data;

  GenerateTokenOConnectModel({
    this.status,
    this.data,
  });

  factory GenerateTokenOConnectModel.fromJson(Map<String, dynamic> json) =>
      GenerateTokenOConnectModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GenerateTokenData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class GenerateTokenData {
  String? accessToken;
  String? refreshToken;
  GenerateTokenUser? user;

  GenerateTokenData({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory GenerateTokenData.fromJson(Map<String, dynamic> json) =>
      GenerateTokenData(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        user: json["user"] == null
            ? null
            : GenerateTokenUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "user": user?.toJson(),
      };
}

class GenerateTokenUser {
  int? id;
  int? roleId;
  String? userPassword;
  String? userNameUrl;
  String? userFirstName;
  String? userName;
  dynamic userLastName;
  String? userEmail;
  String? userPrimaryPhone;
  int? userLoginAttempts;
  dynamic profilePicUrl;
  dynamic uniqueId;
  dynamic sessionIdleTime;
  DateTime? createdOn;
  int? createdBy;
  DateTime? updatedOn;
  int? updatedBy;
  int? userStatus;
  String? isAccountverified;
  dynamic token;
  dynamic tokenCreatedAt;
  int? customerId;
  int? accountId;

  GenerateTokenUser({
    this.id,
    this.roleId,
    this.userPassword,
    this.userNameUrl,
    this.userFirstName,
    this.userName,
    this.userLastName,
    this.userEmail,
    this.userPrimaryPhone,
    this.userLoginAttempts,
    this.profilePicUrl,
    this.uniqueId,
    this.sessionIdleTime,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.userStatus,
    this.isAccountverified,
    this.token,
    this.tokenCreatedAt,
    this.customerId,
    this.accountId,
  });

  factory GenerateTokenUser.fromJson(Map<String, dynamic> json) =>
      GenerateTokenUser(
        id: json["id"],
        roleId: json["roleId"],
        userPassword: json["userPassword"],
        userNameUrl: json["userNameUrl"],
        userFirstName: json["userFirstName"],
        userName: json["userName"],
        userLastName: json["userLastName"],
        userEmail: json["userEmail"],
        userPrimaryPhone: json["userPrimaryPhone"],
        userLoginAttempts: json["userLoginAttempts"],
        profilePicUrl: json["profilePicUrl"],
        uniqueId: json["uniqueId"],
        sessionIdleTime: json["sessionIdleTime"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        createdBy: json["createdBy"],
        updatedOn: json["updatedOn"] == null
            ? null
            : DateTime.parse(json["updatedOn"]),
        updatedBy: json["updatedBy"],
        userStatus: json["userStatus"],
        isAccountverified: json["isAccountverified"],
        token: json["token"],
        tokenCreatedAt: json["tokenCreatedAt"],
        customerId: json["customerID"],
        accountId: json["cutomerAccountID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roleId": roleId,
        "userPassword": userPassword,
        "userNameUrl": userNameUrl,
        "userFirstName": userFirstName,
        "userName": userName,
        "userLastName": userLastName,
        "userEmail": userEmail,
        "userPrimaryPhone": userPrimaryPhone,
        "userLoginAttempts": userLoginAttempts,
        "profilePicUrl": profilePicUrl,
        "uniqueId": uniqueId,
        "sessionIdleTime": sessionIdleTime,
        "createdOn": createdOn?.toIso8601String(),
        "createdBy": createdBy,
        "updatedOn": updatedOn?.toIso8601String(),
        "updatedBy": updatedBy,
        "userStatus": userStatus,
        "isAccountverified": isAccountverified,
        "token": token,
        "tokenCreatedAt": tokenCreatedAt,
        "customerID": customerId,
        "cutomerAccountID": accountId,
      };
}
