// To parse this JSON data, do
//
//     final getProfileResponseModel = getProfileResponseModelFromJson(jsonString);

import 'dart:convert';

GetProfileResponseModel getProfileResponseModelFromJson(String str) => GetProfileResponseModel.fromJson(json.decode(str));

String getProfileResponseModelToJson(GetProfileResponseModel data) => json.encode(data.toJson());

class GetProfileResponseModel {
  int? statusCode;
  String? status;
  String? message;
  GetProfileResponsData? data;

  GetProfileResponseModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) => GetProfileResponseModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: GetProfileResponsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
  bool get isOFounder => data?.isOfounder == true;

}

class GetProfileResponsData {
  String? alternateEmail;
  String? lastName;
  String? oFounderRefId;
  String? displayName;
  List<CustomerAccount>? customerAccounts;
  String? profilePic;
  bool? isOfounder;
  String? emailId;
  List<SubscribedProduct>? subscribedProducts;
  bool? isNdaSigned;
  String? firstName;
  String? nationality;
  int? customerId;
  int? theme;
  String? countryName;
  String? region;
  String? referenceCode;
  Overify? overify;

  GetProfileResponsData({
    this.alternateEmail,
    this.lastName,
    this.oFounderRefId,
    this.displayName,
    this.customerAccounts,
    this.profilePic,
    this.isOfounder,
    this.emailId,
    this.subscribedProducts,
    this.isNdaSigned,
    this.firstName,
    this.nationality,
    this.customerId,
    this.theme,
    this.countryName,
    this.region,
    this.referenceCode,
    this.overify,
  });

  factory GetProfileResponsData.fromJson(Map<String, dynamic> json) => GetProfileResponsData(
        alternateEmail: json["alternateEmail"],
        lastName: json["lastName"],
        oFounderRefId: json["oFounderRefId"],
        displayName: json["displayName"],
        customerAccounts: List<CustomerAccount>.from(json["customerAccounts"].map((x) => CustomerAccount.fromJson(x))),
        profilePic: json["profilePic"],
        isOfounder: json["isOfounder"],
        emailId: json["emailId"],
        subscribedProducts: List<SubscribedProduct>.from(json["subscribedProducts"].map((x) => SubscribedProduct.fromJson(x))),
        isNdaSigned: json["isNdaSigned"],
        firstName: json["firstName"],
        nationality: json["nationality"],
        customerId: json["customerId"],
        theme: json["theme"],
        countryName: json["countryName"],
        region: json["region"],
        referenceCode: json["referenceCode"],
        overify: json["overify"] != null ? Overify.fromJson(json["overify"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "alternateEmail": alternateEmail,
        "lastName": lastName,
        "oFounderRefId": oFounderRefId,
        "displayName": displayName,
        "customerAccounts": List<dynamic>.from(customerAccounts!.map((x) => x.toJson())),
        "profilePic": profilePic,
        "isOfounder": isOfounder,
        "emailId": emailId,
        "subscribedProducts": List<dynamic>.from(subscribedProducts!.map((x) => x.toJson())),
        "isNdaSigned": isNdaSigned,
        "firstName": firstName,
        "nationality": nationality,
        "customerId": customerId,
        "theme": theme,
        "countryName": countryName,
        "region": region,
        "referenceCode": referenceCode,
        "overify": overify?.toJson(),
      };
}

class CustomerAccount {
  String? affiliateLink;
  String? affiliateName;
  double? balance;
  DateTime? createdDate;
  int? cart;
  int? custAffId;
  int? omailAccessed;

  CustomerAccount({
    required this.affiliateLink,
    required this.affiliateName,
    required this.balance,
    required this.createdDate,
    required this.cart,
    required this.custAffId,
    required this.omailAccessed,
  });

  factory CustomerAccount.fromJson(Map<String, dynamic> json) => CustomerAccount(
        affiliateLink: json["affiliate_link"],
        affiliateName: json["affiliate_name"],
        balance: json["balance"],
        createdDate: DateTime.parse(json["created_date"]),
        cart: json["cart"],
        custAffId: json["cust_aff_id"],
        omailAccessed: json["omail_accessed"],
      );

  Map<String, dynamic> toJson() => {
        "affiliate_link": affiliateLink,
        "affiliate_name": affiliateName,
        "balance": balance,
        "created_date": createdDate!.toIso8601String(),
        "cart": cart,
        "cust_aff_id": custAffId,
        "omail_accessed": omailAccessed,
      };
}

class Overify {
  int? custKycId;
  int? customerId;
  String? kycId;
  String? kysStatus;
  bool? kycConsent;
  DateTime? createdDate;
  String? fullName;
  String? dateofBirth;

  Overify({
    this.custKycId,
    this.customerId,
    this.kycId,
    this.kysStatus,
    this.kycConsent,
    this.createdDate,
    this.fullName,
    this.dateofBirth,
  });

  factory Overify.fromJson(Map<String, dynamic> json) => Overify(
        custKycId: json["custKycId"],
        customerId: json["customerId"],
        kycId: json["kycId"],
        kysStatus: json["kysStatus"],
        kycConsent: json["kycConsent"],
        createdDate: DateTime.parse(json["createdDate"]),
        fullName: json["fullName"],
        dateofBirth: json["dateofBirth"],
      );

  Map<String, dynamic> toJson() => {
        "custKycId": custKycId,
        "customerId": customerId,
        "kycId": kycId,
        "kysStatus": kysStatus,
        "kycConsent": kycConsent,
        "createdDate": createdDate!.toIso8601String(),
        "fullName": fullName,
        "dateofBirth": dateofBirth,
      };
}

class SubscribedProduct {
  String? isTrial;
  String? productName;

  SubscribedProduct({this.isTrial, this.productName});

  factory SubscribedProduct.fromJson(Map<String, dynamic> json) => SubscribedProduct(
        isTrial: json["is_trial"] ?? 'free',
        productName: json['product_name'],
      );

  Map<String, dynamic> toJson() => {
        "is_trial": isTrial,
        'product_name': productName,
      };
}
